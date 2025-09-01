#!/usr/bin/env bash
set -euo pipefail

# Path of the script that should run on the 1st day of each Jalali month.
# Can be overridden via environment: REPORT_SCRIPT=/path/to/your-script.sh
REPORT_SCRIPT="${REPORT_SCRIPT:-/usr/local/bin/monthly-report.sh}"

# Optional: force execution for manual testing (skips date check)
# Usage: FORCE=1 check-first-day.sh
if [[ "${FORCE:-0}" == "1" ]]; then
  exec "$REPORT_SCRIPT"
fi

# We need python3 for the conversion
if ! command -v python3 >/dev/null 2>&1; then
  # Exit silently to avoid cron spam
  exit 0
fi

# Run embedded Python to get Jalali day-of-month. Exit with code 10 if jd == 1.
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
    return jy, jm, jd  # fixed: no +1

t = date.today()
jd = gregorian_to_jalali(t.year, t.month, t.day)[2]
sys.exit(10 if jd == 1 else 0)
PY

status=$?
if [[ $status -eq 10 ]]; then
  exec "$REPORT_SCRIPT"
fi

exit 0
