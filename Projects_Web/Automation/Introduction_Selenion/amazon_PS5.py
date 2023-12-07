from selenium import webdriver
from selenium.webdriver.common.by import By

chrome_options = webdriver.ChromeOptions()
chrome_options.add_experimental_option("detach", True)

driver = webdriver.Chrome(options=chrome_options)
driver.get("https://www.amazon.com.br/dp/B0BNSR3MW9/ref=cm_gf_aabk_iaab_iaal_d_p0_e0_qd0_6kNUEZgZ7cwYb5SVqs4v?th=1")

price_dolar = driver.find_element(By.CLASS_NAME, value="a-price-whole")
price_cents = driver.find_element(By.CLASS_NAME, value="a-price-fraction")
# documentation_link = driver.find_element(By.CSS_SELECTOR, value=".sponsored-products-truncator-truncated")
documentation_link = driver.find_element(By.XPATH, value='//*[@id="sp_detail2_B09473BQX5"]/a/div')

print(f"The price is {price_dolar.text}.{price_cents.text}")
print(documentation_link.text)

# driver.close()
driver.quit()