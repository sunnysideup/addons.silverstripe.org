#!/bin/bash

# 1. Update package lists and install necessary dependencies
sudo apt update

# 2. Download the Typesense 27.1 .deb package
curl -O https://dl.typesense.org/releases/27.1/typesense-server-27.1-amd64.deb

# 3. Install the Typesense .deb package
sudo dpkg -i typesense-server-27.1-amd64.deb

# 4. Fix any missing dependencies
sudo apt --fix-broken install -y

# 5. Start the Typesense service
sudo systemctl start typesense-server

# 6. Enable Typesense to start on boot
sudo systemctl enable typesense-server

# 7. Check if Typesense is running
curl http://localhost:8108/health
