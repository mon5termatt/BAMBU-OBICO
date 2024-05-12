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
During the `Classic Webcam Wizard` leave the defaults. we WILL change this at a later time.

# Step 3: Install the plugins

Open `OctoPrint Settings` once you have completed the install and navigate to `Plugin Manager`

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
* Obico

#### STEP 5A:

#### Under Bambu Printer you need to set up a few options

* Device Type: What printer model do you own.
* Ip address: The IP we set during install.sh
* Serial Number: Get this from Orcaslicer/Bambu Slicer in the `Device Tab >>> Update`
* Access Code: Again, same as what we entered during install.sh

![image](https://github.com/mon5termatt/BAMBU-OBICO/assets/43628254/9a1eac86-5e61-40cb-b47a-a39a598cb59a)

#### STEP 5B:

#### Under Classic Webcam we need a few more complicated things

**Get your IP that you are currently on.** its the same IP as octoprint. Set thew following options.

* Stream URL: http://`your IP here`:1984/api/stream.mjpeg?src=p1s
* Stream Aspect Ratio: Leave as 16:9
* Snapshot URL: http://`your IP here`:1984/api/frame.jpeg?src=p1s

![image](https://github.com/mon5termatt/BAMBU-OBICO/assets/43628254/6e4b790d-2a74-437b-b413-4019f9dff1e4)
*Under advanced options you can increase the timeout limit, this is useful if obico keeps throwing webcam errors*


#### Troubleshooting No image

* Open http://`YOUR IP`:1984

You should see THIS: ![image](https://github.com/mon5termatt/BAMBU-OBICO/assets/43628254/8516e17e-5d69-4c69-bf3a-02f079d320d3)

Click the `LINKS` link

Find THIS:
![image](https://github.com/mon5termatt/BAMBU-OBICO/assets/43628254/83c81ff4-67ee-4273-b111-7bad3f2aaceb)

* Right Click `stream.mjpeg` and click `Copy Link Address`
* Enter this link into the `Stream URL`

* Right Click `frame.jpeg` and click `Copy Link Address`
* Enter this link into the `Snapshot URL`

#### STEP 5C:

### Under Obico

Run the `Setup Wizard`

# Once the wizard is done you should be able to access your Bambu Printer from OBICO!

# Our work here is done!
