import json
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import os

# Initialize the webdriver (this example uses Chrome)
driver = webdriver.Chrome()

# Function to scrape the page
def scrape_page():
    products = {}
    rows = driver.find_elements(By.XPATH, "//table/tbody/tr")

    for row in rows:
        category = row.find_element(By.CSS_SELECTOR, "td.category dd").text
        model = row.find_element(By.CSS_SELECTOR, "td.model dd").text
        description = row.find_element(By.CSS_SELECTOR, "td.disc dd").text
        
        # Initialize dictionary structure
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
                        # Extract parameters from the fn.download JavaScript function
                        start = href.find('(') + 1
                        end = href.find(')">')
                        params = href[start:end].replace("'", "").split(", ")

                        # Check type and append to corresponding list
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
                        # Extract parameters from the inquiry link
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

# Load previous data if exists
page = load_data()

# Start scraping
url = "https://opensource.lge.com/product/list?ctgr=005&page="


while True:
    driver.get(url + str(page))
    try:
        WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, "table"))
        )
    except:
        break  # No more pages

    products = scrape_page()

    if not products:
        break
    
    # Save data after each page
    save_data(products, page)
    
    page += 1

# Close the webdriver
driver.quit()
