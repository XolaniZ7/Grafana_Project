#!/bin/bash

# Update and install prerequisites
sudo apt-get update -y
sudo apt-get install -y wget apt-transport-https software-properties-common curl gnupg

# --- Install Grafana ---
# Add Grafana GPG key and repository
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

# Update the repository and install the latest version of Grafana
sudo apt-get update -y
sudo apt-get install -y grafana

# Enable and start Grafana service
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Check Grafana service status
sudo systemctl status grafana-server --no-pager

# --- Install InfluxDB ---
# Add the InfluxData repository key
wget -qO- https://repos.influxdata.com/influxdata-archive_compat.key | sudo apt-key add -

# Add the InfluxData repository to the sources list
echo "deb https://repos.influxdata.com/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/influxdb.list

# Update the package list again and install InfluxDB
sudo apt-get update -y
sudo apt-get install -y influxdb

# Enable and start the InfluxDB service
sudo systemctl enable influxdb
sudo systemctl start influxdb

# Check InfluxDB service status
sudo systemctl status influxdb --no-pager
