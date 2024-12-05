# HeatMap
# -
# https://github.com/Heatena/HeatMap
# Author: Heatena
# -
# Usage:
#   $ cd /opt
#   $ git clone https://github.com/Heatena/HeatMap.git
#   $ cd HeatMap/docker
#   $ docker build -t heatmap:latest .
#   $ docker run -d -v /opt/HeatMap/docker/xml:/opt/xml -p 8000:8000 heatmap:latest
#
# Nmap Example:
#   $ nmap -sT -A -oX /tmp/myscan.xml 192.168.1.0/24
#   $ mv /tmp/myscan.xml /opt/HeatMap/docker/xml
#
# Now you can point your browser to http://localhost:8000

FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

# Install required system packages, including python3-venv
RUN apt-get update && apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
    python3 python3-pip python3-venv curl wget git wkhtmltopdf libssl-dev vim nmap tzdata

# Create directories and download wkhtmltopdf
RUN mkdir /opt/xml && mkdir /opt/notes && \
    wget -P /opt/ https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    cd /opt/ && tar -xvf /opt/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz

# Create a virtual environment and install Python dependencies
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install Django requests xmltodict

# Set up the Django project
RUN cd /opt/ && /opt/venv/bin/django-admin startproject nmapdashboard && \
    cd /opt/nmapdashboard && \
    git clone https://github.com/Heatena/HeatMap.git nmapreport && \
    cd nmapreport && git checkout main

# Copy configuration and scripts
RUN cp /opt/nmapdashboard/nmapreport/docker/settings.py /opt/nmapdashboard/nmapdashboard/
RUN cp /opt/nmapdashboard/nmapreport/docker/urls.py /opt/nmapdashboard/nmapdashboard/
RUN cp /opt/nmapdashboard/nmapreport/docker/tzdata.sh /root/tzdata.sh
RUN cp /opt/nmapdashboard/nmapreport/docker/startup.sh /startup.sh

# Run migrations
RUN cd /opt/nmapdashboard && /opt/venv/bin/python manage.py migrate

# Cleanup and permissions
RUN apt-get autoremove -y
RUN ln -s /opt/nmapdashboard/nmapreport/token.py /root/token
RUN chmod +x /root/token

# Expose the application port
EXPOSE 8000

# Set the entry point
ENTRYPOINT ["bash", "/startup.sh"]
