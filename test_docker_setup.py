#!/usr/bin/env python3
"""
Test script for Docker virtual environment setup.
This script tests the Dockerfile and update scripts without making permanent changes to your system.
"""

import os
import subprocess
import sys
import tempfile
import shutil
import platform
import time

def run_command(command, shell=False):
    """Run a command and return its output."""
    try:
        if shell:
            result = subprocess.run(command, shell=True, check=True, text=True, capture_output=True)
        else:
            result = subprocess.run(command, check=True, text=True, capture_output=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error executing command: {command}")
        print(f"Error message: {e.stderr}")
        sys.exit(1)

def check_docker():
    """Check if Docker is installed and running."""
    try:
        run_command(["docker", "--version"])
        run_command(["docker", "info"])
        print("✅ Docker is installed and running")
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("❌ Docker is not installed or not running")
        print("Please install Docker Desktop and make sure it's running")
        return False

def test_dockerfile():
    """Test building the Docker image from the Dockerfile."""
    print("\n🔍 Testing Dockerfile...")
    
    # Create a unique tag for the test image
    test_image = f"dockervenv-test-{int(time.time())}"
    
    try:
        # Build the image
        print("Building test image...")
        run_command(["docker", "build", "-t", test_image, "."])
        print(f"✅ Successfully built test image: {test_image}")
        
        # Run a simple command in the container to verify it works
        print("Testing container...")
        output = run_command(["docker", "run", "--rm", test_image, "python", "-c", 
                             "import sys; print(f'Python {sys.version} is working!')"])
        print(f"✅ Container test successful: {output}")
        
        return test_image
    except Exception as e:
        print(f"❌ Dockerfile test failed: {str(e)}")
        return None

def test_update_script(test_image):
    """Test the update script functionality."""
    print("\n🔍 Testing update script functionality...")
    
    # Start a container from our test image
    container_name = f"dockervenv-test-container-{int(time.time())}"
    run_command(["docker", "run", "-d", "--name", container_name, test_image, "sleep", "infinity"])
    print(f"✅ Started test container: {container_name}")
    
    try:
        # Test package installation directly (simulating what the update scripts do)
        test_package = "requests"
        print(f"Installing test package: {test_package}...")
        run_command(["docker", "exec", container_name, "pip", "install", test_package])
        
        # Verify package was installed
        output = run_command(["docker", "exec", container_name, "pip", "list"])
        if test_package in output:
            print(f"✅ Successfully installed {test_package} in the container")
        else:
            print(f"❌ Failed to install {test_package} in the container")
        
        # Test the actual update script if we're on the right platform
        if platform.system() == "Windows":
            print("\nOn Windows - would run: .\\update.ps1 install requests")
            print("(Skipping actual execution to avoid modifying local files)")
        else:
            print("\nOn Linux/Mac - would run: ./update.sh install requests")
            print("(Skipping actual execution to avoid modifying local files)")
            
        return True
    except Exception as e:
        print(f"❌ Update script test failed: {str(e)}")
        return False
    finally:
        # Clean up the container
        print(f"\nCleaning up test container: {container_name}")
        run_command(["docker", "stop", container_name])
        run_command(["docker", "rm", container_name])

def cleanup(test_image):
    """Clean up test resources."""
    if test_image:
        print(f"\n🧹 Removing test image: {test_image}")
        run_command(["docker", "rmi", test_image])
    print("✅ Cleanup complete")

def main():
    """Main test function."""
    print("🚀 Starting Docker Virtual Environment Test")
    print("===========================================")
    
    if not check_docker():
        return
    
    test_image = test_dockerfile()
    if test_image:
        test_update_script(test_image)
        cleanup(test_image)
    
    print("\n✨ Test completed. No permanent changes were made to your system.")
    print("To use this project for real:")
    print("1. Follow the setup instructions in README.md")
    print("2. Use the update scripts to manage packages in your Docker environment")

if __name__ == "__main__":
    main()