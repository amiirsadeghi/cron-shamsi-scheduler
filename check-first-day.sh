#!/usr/bin/env bash
set -euo pipefail

REPORT_SCRIPT="${REPORT_SCRIPT:-/usr/local/bin/monthly-report.sh}"

# FORCE=1 ./check-first-day.sh
if [[ "${FORCE:-0}" == "1" ]]; then
  exec "$REPORT_SCRIPT"
fi

if ! command -v python3 >/dev/null 2>&1; then
  exit 0
fi

python3 - <<'PY'
from datetime import date
import sys

def gregorian_to_jalali(gy, gm, gd):
    g_d_m = [0,31,59,90,120,151,181,212,243,273,304,334]
    if gy > 1600:
        jy = 979
        gy -= 1600
    else:
        jy = 0
        gy -= 621
    if gm > 2:
        gy2 = gy + 1
    else:
        gy2 = gy
    days = 365*gy + (gy2+3)//4 - (gy2+99)//100 + (gy2+399)//400 - 80 + gd + g_d_m[gm-1]
    jy += 33 * (days // 12053)
    days %= 12053
    jy += 4 * (days // 1461)
    days %= 1461
    if days > 365:
        jy += (days - 1)//365
        days = (days - 1) % 365
    if days < 186:
        jm = 1 + days // 31
        jd = 1 + (days % 31)
    else:
        jm = 7 + (days - 186) // 30
        jd = 1 + ((days - 186) % 30)
    return jy + 1, jm, jd

t = date.today()
jd = gregorian_to_jalali(t.year, t.month, t.day)[2]
sys.exit(10 if jd == 1 else 0)
PY

status=$?
if [[ $status -eq 10 ]]; then
  exec "$REPORT_SCRIPT"
fi

exit 0
