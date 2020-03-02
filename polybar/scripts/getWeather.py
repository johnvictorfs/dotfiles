import requests
from bs4 import BeautifulSoup
import html5lib
import time

images = {
    'night': {
        'Broken clouds': '',
        'Passing clouds': '',
        'Scattered clouds': '',
        'A few showers. Broken clouds': '',
        'A few showers. Mostly cloudly': '',
        'Light showers. Mostly cloudly': '',
        'Light showers. Broken clouds': '',
        'Rain showers. Mostly cloudly': '',
        'Rain showers. Broken clouds': '',
        'Heavy rain. Overcast': '',
        'Strong thunderstorms. Low clouds': '',
        'Sprinkles. Clearing skies': '',
        'default': ''
    },
    'day': {
        'Mostly sunny': '',
        'Partly sunny': '',
        'Broken clouds': '',
        'Scattered clouds': '',
        'Passing clouds': '',
        'More clouds than sun': '',
        'A few showers. Partly sunny': '',
        'A few showers. Mostly cloudly': '',
        'A few showers. Broken clouds': '',
        'Light showers. Partly sunny': '',
        'Light showers. Mostly cloudly': '',
        'Light showers. Broken clouds': '',
        'Rain. Afternoon clouds': '',
        'Sprinkles. Clearing skies': '',
        'Heavy rain. Overcast': '',
        'Rain showers. Partly sunny': '',
        'Rain showers. Mostly cloudly': '',
        'Rain showers. Broken clouds': '',
        'Scattered showers. Scattered clouds': '',
        'Light showers. Increasing cloudiness': '',
        'Showers late. Scattered clouds': '',
        'Strong thunderstorms. Low clouds': '',
        'default': ''
    },
    'default': ''
}

def format_temperature(state, temp):
    current_time = time.localtime()

    if current_time.tm_hour < 6 or current_time.tm_hour > 18:
        image = images['night'].get(state, images['night']['default'])
    else:
        image = images['day'].get(state, images['day']['default'])

    return f"{image} {state} ({temperature} °C)"

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

