# Use latest version of Pythong for specific version use python:<tag_of_version>
FROM python:latest 

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Install the dependencies
RUN pip install -r requirements.txt

# Expose the port 8000 outside of the container
EXPOSE 8000

# Run the commands to start the application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--reload"]