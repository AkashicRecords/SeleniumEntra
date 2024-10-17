# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Install .NET SDK
RUN apt-get update && apt-get install -y wget && \
    wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y dotnet-sdk-6.0

# Install Poetry
RUN pip install poetry

# Set the working directory in the container
WORKDIR /app

# Copy the pyproject.toml and poetry.lock files
COPY pyproject.toml poetry.lock* ./

# Install project dependencies
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi

# Copy the current directory contents into the container at /app
COPY . /app

# Install Selenium WebDriver
RUN apt-get install -y wget unzip && \
    wget https://github.com/mozilla/geckodriver/releases/download/v0.30.0/geckodriver-v0.30.0-linux64.tar.gz && \
    tar -xvzf geckodriver-v0.30.0-linux64.tar.gz && \
    chmod +x geckodriver && \
    mv geckodriver /usr/local/bin/

# Make port 80 available to the world outside this container
EXPOSE 80

# Run tests when the container launches
CMD ["bash", "run_tests.sh"]
