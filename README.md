# Docker Virtual Environment for PyCharm

This project provides a template for using Docker as a virtual environment in PyCharm. It allows you to:

- Keep your development environment consistent across different machines
- Isolate project dependencies
- Easily share the environment configuration with team members

## Files

- `requirements.txt`: Lists Python packages needed for the project
- `Dockerfile`: Defines the Docker container configuration

## Setup Instructions

### Prerequisites

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop)
2. Install [PyCharm Professional](https://www.jetbrains.com/pycharm/download/) (Docker integration requires the Professional edition)

### Setting Up Docker in PyCharm

1. Open your project in PyCharm
2. Go to `File > Settings > Build, Execution, Deployment > Docker`
3. Click the `+` button to add a new Docker configuration
4. Select the Docker connection type (usually "Docker for Windows" on Windows)
5. Click "Apply" and "OK"

### Configuring Python Interpreter to Use Docker

1. Go to `File > Settings > Project > Python Interpreter`
2. Click the gear icon and select "Add..."
3. Select "Docker" from the left panel
4. Choose the Docker server you configured earlier
5. Set the image name to a name for your project (e.g., "my-project-env")
6. Set the Python interpreter path to "python"
7. Click "OK"

### Building and Using the Docker Environment

1. PyCharm will automatically build the Docker image using your Dockerfile
2. You can now run and debug your Python code using this Docker-based interpreter
3. PyCharm will mount your project directory into the container, so changes to your code are immediately available

## Customizing Your Environment

- Modify `requirements.txt` to add or update Python packages
- Edit the `Dockerfile` if you need to:
  - Change the Python version
  - Install system dependencies
  - Set environment variables
  - Configure other container settings

## Troubleshooting

- If you encounter issues with Docker integration, ensure Docker Desktop is running
- For permission issues, make sure your user has permissions to access Docker
- If packages aren't being found, try rebuilding the Docker image (in PyCharm: `File > Invalidate Caches / Restart`)

## Additional Resources

- [PyCharm Docker Documentation](https://www.jetbrains.com/help/pycharm/docker.html)
- [Docker Python Guide](https://docs.docker.com/language/python/)