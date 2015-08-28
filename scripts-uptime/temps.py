#!/usr/bin/python3
import re
import time
import sys


def temps():
    cpu = open("/proc/uptime", 'r')
    val = cpu.readline()
    cpu.close()
    rslt = re.compile("^\d+.\d{2}")
    val2 = float(rslt.match(val).group())
    t = time.gmtime(val2)
    sys.stdout.write("Le système fonctionne depuis %d jour(s), %d heure(s) et %d minute(s)\
    " % (t[2]-1, t[3], t[4]))

temps()
