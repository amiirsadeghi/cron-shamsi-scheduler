# Cron Shamsi Scheduler

Run cron jobs based on the **Jalali (Shamsi)** calendar on Linux.  
By default, `cron` only understands the Gregorian calendar. This project provides lightweight Bash + Python3 scripts that allow you to trigger jobs on the **first day of each Jalali month**.

---

## Features
- Works with standard Linux `cron`
- No external dependencies (`jdate/jcal` not required)
- Pure Python Gregorian→Jalali conversion algorithm embedded
- Easy to integrate with any existing scripts
- Includes a sample job script and a date-checker utility

---

## Repository Structure
```
cron-shamsi-scheduler/
├── check-first-day.sh     # Runs your job only if today == 1st day of Jalali month
├── show-jalali-date.sh    # Prints today’s Jalali date (for testing/debugging)
└── monthly-report.sh      # Example job script (replace with your real logic)
```

---

## Installation
Clone the repository:
```bash
git clone https://github.com/amiirsadeghi/cron-shamsi-scheduler.git
cd cron-shamsi-scheduler
```

Make scripts executable:
```bash
chmod +x check-first-day.sh show-jalali-date.sh monthly-report.sh
```

Optionally copy them into a system path:
```bash
sudo cp check-first-day.sh /usr/local/bin/
sudo cp show-jalali-date.sh /usr/local/bin/
sudo cp monthly-report.sh /usr/local/bin/
```

> **Timezone note:** The conversion uses your server's local time (`date.today()`). Ensure the server timezone matches what you expect (e.g., `Asia/Tehran`).

---

## Usage

### 1. Print today’s Jalali date
```bash
/usr/local/bin/show-jalali-date.sh
```
Example output:
```
📅 Today’s Jalali date: 1404/06/10 (10 Shahrivar)
🔢 Day of month: 10
```

### 2. Run the job manually (force)
```bash
FORCE=1 /usr/local/bin/check-first-day.sh
```
The `FORCE=1` environment variable skips the date check and forces execution of your job.

### 3. Setup cron
Edit your crontab (`crontab -e`) and add:
```cron
0 9 * * * REPORT_SCRIPT=/usr/local/bin/monthly-report.sh /usr/local/bin/check-first-day.sh >/dev/null 2>&1
```
This will check every day at 09:00.  
If today is the **first day of a Jalali month**, it will execute your job script (`monthly-report.sh`).  
Otherwise, it will silently exit.

---

## Customization
- **REPORT_SCRIPT**: Path to your own script (defaults to `/usr/local/bin/monthly-report.sh`).  
  Example:
  ```cron
  0 9 * * * REPORT_SCRIPT=/path/to/your-script.sh /usr/local/bin/check-first-day.sh >/dev/null 2>&1
  ```
- Replace `monthly-report.sh` with your actual logic (e.g., generating backups, sending webhooks, compiling monthly reports, etc.).

---

## Why not `jdate/jcal`?
Tools like `jdate`/`jcal` exist but may have inaccuracies (e.g., one-day offset in some versions).  
This project avoids external dependencies by embedding a Gregorian→Jalali conversion algorithm in Python (no external libraries).

---

## Example Workflow
- Write your own job logic inside `monthly-report.sh`  
- Ensure it’s executable: `chmod +x monthly-report.sh`  
- Let `check-first-day.sh` handle the Jalali calendar logic  
- Schedule via `cron` → done ✅

---

## License
This project is licensed under the MIT License. See [LICENSE](./LICENSE).
