# syntax=docker/dockerfile:1 
# This directive instructs the Docker builder what syntax to use when parsing the Dockerfile,
# and allows older Docker versions with BuildKit enabled to upgrade the parser before starting the build.

# Tells Docker what base image we would like to use for our application.
FROM python:3.9

# Create a working directory.
# This instructs Docker to use this path as the default location for all subsequent commands.
WORKDIR /app

# Set environment variables
ENV PORT=8000

# Copy the dependencies file to the working directory.
COPY requirements.txt .

# Install dependencies.
RUN pip install -r requirements.txt

# Copy our source code into the working directory.
COPY . /app

# collect static files
RUN python manage.py collectstatic --noinput

# Indicates which port the container will be executed on.
EXPOSE 8000

# Indicates which statement should run when your container is launched, run gunicorn.
CMD gunicorn oc_lettings_site.wsgi:application --bind 0.0.0.0:$PORT
