#!/bin/bash
t=$(python3 temps.py)

zenity --info --text="$t" --title="uptime"
