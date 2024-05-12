# BAMBU-OBICO
A half automated setup of Obico / Octoprint / BambuP1Streamer

# this script assumes you are using a fresh install of PIOS or Debian

## only tested on a virtual install of debian 12


------------------------------------------------------------------------------

# Step 1: Run install.sh

##### Script steps:
1. **Add Docker Installation Dependencies:** Configures the system to install Docker.
2. **Install Docker:** Installs Docker and Docker Compose on the system.
3. **Clone Repository:** Clones a specified GitHub repository.
4. **Compile Source Code:** Compiles source code using a Docker container.
5. **Build Docker Image:** Builds a Docker image for the project.

6. **Set Printer Configuration:** Prompts users to input printer IP address and access key.

7. **Create Docker Compose File:** Generates a Docker Compose file based on user inputs.
8. **Start Docker Containers:** Starts Docker containers using Docker Compose.
9. **Create OctoPrint Docker Compose File:** Creates a Docker Compose file for OctoPrint with user-defined port.
10. **Start OctoPrint Docker Containers:** Starts OctoPrint Docker containers using Docker Compose.

# Step 2: Install and Configure Octoprint

Install Octoprint and go through the setup wizard.

# Step 3: Install the plugins

#### Step 3A:
Install and setup this plugin: [GitHub - jneilliii/OctoPrint-BambuPrinter 82](https://github.com/jneilliii/OctoPrint-BambuPrinter)

1. Using the plugin manager click the **GET MORE** button.
2. Enter your password you set in the wizard.
3. find the **... from URL** and enter the url `https://github.com/jneilliii/OctoPrint-BambuPrinter/archive/master.zip`

#### Step 3B:
Install and setup this plugin: `Obico for OctoPrint: Full Remote Access - AI Failure Detection & Smart 3D Printing`

1. Using the plugin manager click the **GET MORE** button.
2. Enter your password you set in the wizard.
3. find the **... from the Plugin Repository** and search for `Obico for OctoPrint`
4. Click the big **install** button.

# Step 4: Restart the Octoprint Instance if needed

# Step 5: Setup the plugins.

Under plugins we need a few things.
* Bambu Printer
* Classic Webcam

Under Bambu Printer you need to set up a few options



5- Install Obico app to get notification/screenshots on your phone and be able to pause prints manually if needed (Obico does it automatically).
6- Profit.
