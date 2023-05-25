# Use the official Python image as the base image
FROM python:3.9-slim-buster

# Set the working directory in the container
WORKDIR /app

# Copy the application files to the container
COPY . .

# Install the Flask package
RUN pip install --no-cache-dir Flask

# Expose the port that the Flask application will be running on
EXPOSE 5000

# Run the Flask application when the container starts
CMD ["python", "main.py"]