#!/bin/bash

# Activate the virtual environment
source /opt/venv/bin/activate

# Set PYTHONPATH to ensure the project directory is included
export PYTHONPATH=/opt/nmapdashboard

# Run the cron job in the background
bash /opt/nmapdashboard/nmapreport/nmap/runcron.sh > /dev/null 2>&1 &

# Start the Django development server
python /opt/nmapdashboard/manage.py runserver 0.0.0.0:8000
