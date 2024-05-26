from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time

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
            if href and "javascript:fn.download" in href:
                # Extract parameters from the fn.download JavaScript function
                start = href.find('(') + 1
                end = href.find(')')
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
    return products

# Start scraping
url = "https://opensource.lge.com/product/list?ctgr=005&page="
page = 0
all_products = {}

while True:
    driver.get(url + str(page))
    time.sleep(3)  # Wait for the page to load

    try:
        WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, "table"))
        )
    except:
        break  # No more pages

    products = scrape_page()

    if not products:
        break

    all_products.update(products)
    page += 1

# Close the webdriver
driver.quit()
