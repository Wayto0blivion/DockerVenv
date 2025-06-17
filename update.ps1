# update.ps1 - Script to manage packages in Docker container
# Usage: .\update.ps1 install <package-name>

param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$Action,

    [Parameter(Position=1, Mandatory=$true)]
    [string]$Package
)

# Check if Docker is running
try {
    docker info | Out-Null
} catch {
    Write-Host "Error: Docker is not running. Please start Docker Desktop." -ForegroundColor Red
    exit 1
}

# Check command line arguments
if ($Action -ne "install") {
    Write-Host "Unknown action: $Action" -ForegroundColor Red
    Write-Host "Usage: .\update.ps1 install <package-name>"
    exit 1
}

# Get the container name (assuming it's running)
$ContainerName = docker ps --filter "ancestor=python:3.10-slim" --format "{{.Names}}" | Select-Object -First 1

if ([string]::IsNullOrEmpty($ContainerName)) {
    Write-Host "Error: No running container found based on python:3.10-slim." -ForegroundColor Red
    Write-Host "Make sure your Docker container is running."
    exit 1
}

if ($Action -eq "install") {
    Write-Host "Installing package: $Package" -ForegroundColor Green

    # Install the package in the container
    docker exec -it $ContainerName pip install $Package

    # Update requirements.txt
    Write-Host "Updating requirements.txt..." -ForegroundColor Green
    # Use -NoNewline to avoid BOM and ensure clean output
    docker exec $ContainerName pip freeze | Out-File -FilePath "requirements.txt" -Encoding utf8 -NoNewline

    # Rebuild the container
    Write-Host "Rebuilding the container..." -ForegroundColor Green
    # Get the image name from the container
    $ImageName = docker inspect --format='{{.Config.Image}}' $ContainerName

    # Stop the container
    docker stop $ContainerName

    # Rebuild the image
    docker build -t $ImageName .

    Write-Host "Done! Package $Package installed and container rebuilt." -ForegroundColor Green
    Write-Host "You may need to restart your container or PyCharm to apply changes."
}
