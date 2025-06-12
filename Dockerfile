# Base Python image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Create and set working directory
WORKDIR /app

# Copy requirements file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files (when using with PyCharm, this will be handled by the IDE)
# COPY . .

# Command to run when container starts
# This is a placeholder - PyCharm will override this when running the container
CMD ["python", "-m", "pytest"]