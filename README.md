# BAMBU-OBICO
A half automated setup of Obico / Octoprint / BambuP1Streamer

# this script assumes you are using a fresh install of PIOS or Debian

## only tested on a virtual install of debian 12

Step 1: Run install.sh

### Steps:
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
