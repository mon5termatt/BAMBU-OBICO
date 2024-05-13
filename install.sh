#!/bin/bash

# Check if running with sudo
if [[ $EUID -eq 0 ]]; then
   echo -e "\e[31mPlease run this script without sudo\e[0m" 
   exit 1
fi

# Step: 1 - Set Printer Configuration and OctoPrint Port
echo -e "\e[32mStep: 1 - Setting printer configuration and OctoPrint port\e[0m"
read -p "Enter your printer IP address: " printer_ip
read -p "Enter your printer access key: " printer_key
read -p "Enter the port for OctoPrint (default is 80): " octoprint_port
octoprint_port=${octoprint_port:-80}
echo -e "\e[32mPrinter IP:\e[0m $printer_ip"
echo -e "\e[32mPrinter Access Key:\e[0m $printer_key"
echo -e "\e[32mOctoprint Port:\e[0m $octoprint_port"

# Store current directory
current_dir=$(pwd)

# Step: 2 - Add Docker Installation Dependencies
echo -e "\e[32mStep: 2 - Adding Docker's official GPG key and repository to Apt sources\e[0m"

# Add Docker's official GPG key
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Step: 3 - Install Docker
echo -e "\e[32mStep: 3 - Installing Docker\e[0m"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify installation
echo -e "\e[32mDocker version:\e[0m"
sudo docker --version

# Step: 4 - Clone the repository and navigate into the directory
echo -e "\e[32mStep: 4 - Cloning the repository and navigating into the directory\e[0m"
git clone https://github.com/slynn1324/BambuP1Streamer
cd BambuP1Streamer || exit

# Step: 5 - Downloading Additional required files
echo -e "\e[32mStep: 5 - Downloading Additional required files\e[0m"
wget https://public-cdn.bambulab.com/upgrade/studio/plugins/01.04.00.15/linux_01.04.00.15.zip
unzip linux_01.04.00.15.zip
wget https://github.com/AlexxIT/go2rtc/releases/download/v1.6.2/go2rtc_linux_amd64
chmod a+x go2rtc_linux_amd64

# Step: 6 - Compile Source Code
echo -e "\e[32mStep: 6 - Compiling source code\e[0m"
echo -e "\e[32mCurrent directory is: $(pwd)\e[0m"
sudo docker run --rm -v $(pwd):$(pwd) docker.io/gcc:12 gcc $(pwd)/src/BambuP1Streamer.cpp -o $(pwd)/BambuP1Streamer

# Step: 7 - Build Docker Image
echo -e "\e[32mStep: 7 - Building Docker image\e[0m"
sudo docker build -t bambu_p1_streamer .

# Step: 8 - Create Docker Compose File
echo -e "\e[32mStep: 8 - Creating Docker Compose file\e[0m"
cat <<EOF >docker-compose.yml
version: "3.3"
services:
  bambu_p1_streamer:
    container_name: bambu_p1_streamer
    ports:
      - 1984:1984
    environment:
      - PRINTER_ADDRESS=$printer_ip
      - PRINTER_ACCESS_CODE=$printer_key
    image: bambu_p1_streamer
networks: {}
EOF

# Display the Docker Compose file
echo -e "\e[32mContents of docker-compose.yml:\e[0m"
cat docker-compose.yml

# Prompt for confirmation
read -p "Does the Docker Compose file look correct? (Y/N): " confirm
if [[ $confirm == "Y" || $confirm == "y" ]]; then
    # Step: 9 - Start Docker Containers
    echo -e "\e[32mStep: 9 - Starting Docker containers\e[0m"
    sudo docker compose up -d
    # Display Docker containers
    echo -e "\e[32mDocker containers:\e[0m"
    sudo docker ps
else
    echo -e "\e[31mAborted. Please review and correct the Docker Compose file.\e[0m"
fi

# Navigate back to the parent directory and create the "octoprint" folder
cd "$current_dir" || exit
mkdir -p octoprint
cd octoprint || exit

# Step: 10 - Create OctoPrint Docker Compose File
echo -e "\e[32mStep: 10 - Creating OctoPrint Docker Compose file\e[0m"

cat <<EOF >docker-compose.yaml
version: "2.4"
services:
  octoprint:
    image: octoprint/octoprint
    restart: unless-stopped
    ports:
      - $octoprint_port:80
    volumes:
      - octoprint:/octoprint
volumes:
  octoprint: null
networks: {}
EOF

echo -e "\e[32mOctoPrint Docker Compose file created successfully.\e[0m"

# Step: 11 - Start OctoPrint Docker Containers
echo -e "\e[32mStep: 11 - Starting OctoPrint Docker containers\e[0m"
cat docker-compose.yaml

read -p "Does the OctoPrint Docker Compose file look correct? (Y/N): " confirm_octoprint
if [[ $confirm_octoprint == "Y" || $confirm_octoprint == "y" ]]; then
    sudo docker compose up -d
    echo -e "\e[32mOctoPrint Docker containers started successfully.\e[0m"
else
    echo -e "\e[31mAborted. Please review and correct the OctoPrint Docker Compose file.\e[0m"
fi

# Step: 12 - Get IP Address and Port, Prompt User for Setup
echo -e "\e[32mStep: 12 - Getting the IP address and port of the machine\e[0m"
ip_address=$(hostname -I | cut -d' ' -f1)

# Prompt user to visit OctoPrint setup
if [[ $octoprint_port == 80 ]]; then
    echo -e "\e[32mPlease visit http://$ip_address in your web browser to set up OctoPrint.\e[0m"
else
    echo -e "\e[32mPlease visit http://$ip_address:$octoprint_port in your web browser to set up OctoPrint.\e[0m"
fi
