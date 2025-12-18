# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set working directory inside container
WORKDIR /code

# Copy the current directory contents into the container
COPY . /code

# Install required Python packages
RUN pip install --no-cache-dir flask redis

# Run the application
CMD ["python", "app.py"]


