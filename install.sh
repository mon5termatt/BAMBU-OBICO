#!/bin/bash

# a big thanks to chatGPT for helping write some of this code

# Store current directory
current_dir=$(pwd)

# Step: 1 - Add Docker's official GPG key and repository to Apt sources
echo -e "\e[32mStep: 1 - Adding Docker's official GPG key and repository to Apt sources\e[0m"

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

# Step: 2 - Install Docker
echo -e "\e[32mStep: 2 - Installing Docker\e[0m"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify installation
echo -e "\e[32mDocker version:\e[0m"
sudo docker --version

# Step: 3 - Clone the repository and navigate into the directory
echo -e "\e[32mStep: 3 - Cloning the repository and navigating into the directory\e[0m"
git clone https://github.com/slynn1324/BambuP1Streamer
cd BambuP1Streamer || exit

# Step: 4
echo -e "\e[32mStep: 4\e[0m"
wget https://public-cdn.bambulab.com/upgrade/studio/plugins/01.04.00.15/linux_01.04.00.15.zip
unzip linux_01.04.00.15.zip

# Step: 5
echo -e "\e[32mStep: 5\e[0m"
wget https://github.com/AlexxIT/go2rtc/releases/download/v1.6.2/go2rtc_linux_amd64
chmod a+x go2rtc_linux_amd64

# Step: 6
echo -e "\e[32mStep: 6\e[0m"
echo -e "\e[32mCurrent directory is: $(pwd)\e[0m"
sudo docker run --rm -v $(pwd):$(pwd) docker.io/gcc:12 gcc $(pwd)/src/BambuP1Streamer.cpp -o $(pwd)/BambuP1Streamer

# Step: 7
echo -e "\e[32mStep: 7\e[0m"
sudo docker build -t bambu_p1_streamer .

# Step: 8
echo -e "\e[32mStep: 8\e[0m"
read -p "Enter your printer IP address: " printer_ip
read -p "Enter your printer access key: " printer_key

echo -e "\e[32mPrinter IP:\e[0m $printer_ip"
echo -e "\e[32mPrinter Access Key:\e[0m $printer_key"

# Step: 9
echo -e "\e[32mStep: 9 - Creating Docker Compose file\e[0m"
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
    # Step: 10
    echo -e "\e[32mStep: 10\e[0m"
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

# Step: 11
echo -e "\e[32mStep: 11 - Creating OctoPrint Docker Compose file\e[0m"
read -p "Enter the port for OctoPrint (default is 80): " octoprint_port
octoprint_port=${octoprint_port:-80}

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

# Step: 12
echo -e "\e[32mStep: 12 - Confirming OctoPrint Docker Compose file and running Docker Compose\e[0m"
cat docker-compose.yaml

read -p "Does the OctoPrint Docker Compose file look correct? (Y/N): " confirm_octoprint
if [[ $confirm_octoprint == "Y" || $confirm_octoprint == "y" ]]; then
    # Run Docker Compose for OctoPrint
    sudo docker compose up -d
    echo -e "\e[32mOctoPrint Docker containers started successfully.\e[0m"
else
    echo -e "\e[31mAborted. Please review and correct the OctoPrint Docker Compose file.\e[0m"
fi

# Step: 13
echo -e "\e[32mStep: 13 - Getting the IP address and port of the machine\e[0m"
ip_address=$(hostname -I | cut -d' ' -f1)

# Prompt user to visit OctoPrint setup
if [[ $octoprint_port == 80 ]]; then
    echo -e "\e[32mPlease visit http://$ip_address in your web browser to set up OctoPrint.\e[0m"
else
    echo -e "\e[32mPlease visit http://$ip_address:$octoprint_port in your web browser to set up OctoPrint.\e[0m"
fi
