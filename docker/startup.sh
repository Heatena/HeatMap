#!/bin/bash

# Activate the virtual environment
source /opt/venv/bin/activate

# Set PYTHONPATH to include the project directory
export PYTHONPATH=/opt/nmapdashboard

# Verify that Django is installed
if ! python -c "import django" &> /dev/null; then
    echo "Django is not installed. Installing now..."
    pip install django
fi

# Run the cron job in the background
bash /opt/nmapdashboard/nmapreport/nmap/runcron.sh > /dev/null 2>&1 &

# Start the Django development server
python /opt/nmapdashboard/manage.py runserver 0.0.0.0:8000
