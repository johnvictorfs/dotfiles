import requests
from bs4 import BeautifulSoup
import html5lib

def format_temperature(state, temp):
    return f"{state} ({temperature} °C)"

try:
    url = "https://www.timeanddate.com/weather/brazil/fortaleza"
    soup = BeautifulSoup((requests.get(url)).text, 'html5lib')
    weather_test = soup.find(class_="h2")

    state = soup.find(class_="mtt")['title'][:-1]

    temperature = int((weather_test.text.split('\xa0'))[0])

    if "F" in ((weather_test).text.split("\xa0"))[1]:
        # Convert temperature from farenheit to celsius
        temperature = round((temperature - 32 ) * (5/9))

    formatted_temperature = format_temperature(state, temperature)
except requests.exceptions.ConnectionError:
    formatted_temperature = ""

if formatted_temperature:
    print(formatted_temperature)

