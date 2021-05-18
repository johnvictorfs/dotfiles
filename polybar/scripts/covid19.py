from typing import TypedDict
import time
import sys

import requests


class CountryResponse(TypedDict):
    name: str
    year: int
    country: str
    cases: int
    todayCases: int
    deaths: int
    todayDeaths: int
    recovered: int
    active: int
    critical: int
    casesPerOneMillion: int


class TotalResponse(TypedDict):
    cases: int
    deaths: int
    recovered: int
    updated: int


if __name__ == '__main__':
    while True:
        try:
            # pass 'global' as arg to show cases and deaths data as 'country/global'
            show_global = 'global' in sys.argv[1].lower() if len(sys.argv) > 1 else False

            country_endpoint = 'https://corona.lmao.ninja/v2/countries/brazil'
            total_endpoint = 'https://corona.lmao.ninja/all'

            country_r = requests.get(country_endpoint)
            country_data: CountryResponse = country_r.json()

            yellow = '%{F#fffb1c}'
            red = '%{F#fc5549}'

            skull_crossbones = ''
            biohazard = ''

            if show_global:
                total_r = requests.get(total_endpoint)
                total_data: TotalResponse = total_r.json()

                print(f"{yellow}{biohazard} {country_data['cases']:,}/{total_data['cases']:,} (+{country_data['todayCases']:,})", end="  ")
                print(f"{red}{skull_crossbones} {country_data['deaths']:,}/{total_data['deaths']:,} (+{country_data['todayDeaths']:,})")
            else:
                print(f"{yellow}{biohazard} {country_data['cases']:,} (+{country_data['todayCases']:,})", end="  ")
                print(f"{red}{skull_crossbones} {country_data['deaths']:,} (+{country_data['todayDeaths']:,})")
                break
        except Exception as e:
            time.sleep(1000)

