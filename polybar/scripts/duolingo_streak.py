#!/bin/python

import sys
import os
import duolingo

try:
    lingo = duolingo.Duolingo(os.environ['DUOLINGO_USERNAME'], os.environ['DUOLINGO_PASSWORD'])

    streak = lingo.get_streak_info()

    if streak['streak_extended_today']:
        print(f' {streak["site_streak"]}')
    else:
        print('%{F#fc5549} ' + str(streak["site_streak"]))
except Exception:
    print('%{F#fc5549} ')
    pass
