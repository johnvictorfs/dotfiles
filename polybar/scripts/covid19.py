from typing import TypedDict

import requests


class Response(TypedDict):
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


if __name__ == '__main__':
    endpoint = 'https://corona.lmao.ninja/countries/brazil'

    r = requests.get(endpoint)
    data: Response = r.json()

    yellow = '%{F#fffb1c}'
    red = '%{F#fc5549}'

    skull_crossbones = ''
    biohazard = ''

    print(f"{yellow}{biohazard} {data['cases']:,} (+{data['todayCases']:,})", end="  ")
    print(f"{red}{skull_crossbones} {data['deaths']:,} (+{data['todayDeaths']:,})")
