#!/usr/bin/env bash
set -euo pipefail

# Example monthly job script. Replace with your real logic.
echo "[cron-shamsi] Monthly task started at $(date -Is)"

# Example webhook (disabled):
# curl -sS -X POST "https://example.com/webhook" -H 'Content-Type: application/json' \
#   -d '{"message":"Monthly report triggered (Jalali day 1)."}' >/dev/null

# Example: call other scripts here
# /usr/local/bin/generate-report.sh
# /usr/local/bin/upload-to-storage.sh

echo "[cron-shamsi] Monthly task finished at $(date -Is)"
