from selenium import webdriver
from selenium.webdriver.common.keys import Keys



chrome_options = webdriver.ChromeOptions()
chrome_options.add_experimental_option("detach", True)

driver = webdriver.Chrome(options=chrome_options)
driver.get("https://secure-retreat-92358.herokuapp.com")


first_name = driver.find_element("name", "fName")
first_name.send_keys("Douglas")
last_name = driver.find_element("name", "lName")
last_name.send_keys("Saturnino")
email = driver.find_element("name", "email")
email.send_keys("douglassaturnino@live.com")

submit = driver.find_element("css selector", "form button")
submit.click()




# chrome_driver_path = "C:\Users\douglassaturnino\AppData\Local\Programs\chromedriver-win64\chromedriver.exe"
# driver = webdriver.Chrome(chrome_driver_path)
# driver.get("https://secure-retreat-92358.herokuapp.com")

# driver.close()
# driver.quit()