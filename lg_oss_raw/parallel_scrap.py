import json
import os
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from multiprocessing import Process

# Function to scrape the page
def scrape_page(driver, url, page):
    driver.get(url + str(page))
    try:
        WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, "table"))
        )
    except:
        return None

    products = {}
    rows = driver.find_elements(By.XPATH, "//table/tbody/tr")

    for row in rows:
        category = row.find_element(By.CSS_SELECTOR, "td.category dd").text
        model = row.find_element(By.CSS_SELECTOR, "td.model dd").text
        description = row.find_element(By.CSS_SELECTOR, "td.disc dd").text

        if category not in products:
            products[category] = {}

        products[category][model] = {
            "description": description,
            "notice": [],
            "source": []
        }

        scripts = row.find_elements(By.CSS_SELECTOR, "td a")
        for script in scripts:
            href = script.get_attribute("href")
            if href:
                try:
                    if "javascript:fn.download" in href:
                        start = href.find('(') + 1
                        end = href.find(')">')
                        params = href[start:end].replace("'", "").split(", ")

                        artifact = {
                            "osSeq": params[0],
                            "model": params[1],
                            "type": params[2],
                            "fileId": params[3],
                            "filename": params[4]
                        }
                        if params[2] == 'Li':
                            products[category][model]["notice"].append(artifact)
                        elif params[2] == 'Op':
                            products[category][model]["source"].append(artifact)
                    elif href.startswith("/inquiry?"):
                        params = href.split("?")[1].split("&")
                        params_dict = {p.split("=")[0]: p.split("=")[1] for p in params}
                except:
                    continue

    return products

# Function to save data to a file
def save_data(all_products, page):
    with open(f"products/{page}.json", "w") as f:
        json.dump(all_products, f, indent=4)
    with open("current_page.txt", "w") as f:
        f.write(str(page))

# Function to load data from a file
def load_data():
    if os.path.exists("current_page.txt"):
        with open("current_page.txt", "r") as f:
            page = int(f.read().strip())
    else:
        page = 0

    return page

# Function to run Selenium process
def run_selenium_process(page_range):
    driver = webdriver.Chrome()
    url = "https://opensource.lge.com/product/list?ctgr=005&page="
    for page in page_range:
        products = scrape_page(driver, url, page)
        if products:
            save_data(products, page)
        else:
            break
    driver.quit()

if __name__ == '__main__':
    page_start = 0
    page_end =  1429  # Adjust the range according to your requirement
    page_range = range(page_start, page_end)

    # Split the page range into 10 chunks for parallel processing
    page_chunks = [page_range[i:i + len(page_range) // 10] for i in range(0, len(page_range), len(page_range) // 10)]

    # Start processes
    processes = []
    for chunk in page_chunks:
        p = Process(target=run_selenium_process, args=(chunk,))
        p.start()
        processes.append(p)

    # Wait for all processes to finish
    for p in processes:
        p.join()
