Creating a Docker Machine for an .Onion Site with Dockerfile, Security Keys, and Hostname File for Tor

This guide explains how to create a Docker machine to host an .onion website, using a Dockerfile to include the necessary security keys and the hostname file for Tor. It's important to generate these files through Tor before proceeding with the Dockerfile configuration to avoid recreating the keys every time the Docker machine starts.
Generate Private Key and Hostname:

Use Tor to create a new pair of keys and a hostname for your hidden service. This is done by configuring Tor to create a new hidden service and letting it automatically generate these files. Save the Generated Files: They are usually located in /var/lib/tor/hidden_service/.
Create the Dockerfile:

Dockerfile

FROM debian

# Update packages and install Tor and lighttpd
RUN apt update && apt install -y tor lighttpd curl apt-transport-https nano

# Copy configuration files (ensure you have these files in your local directory)
COPY ./tor/torsocks.conf /etc/tor/torsocks.conf
COPY ./tor/torrc /etc/tor/torrc

# Expose port 80 for the web server
EXPOSE 80

# Create the hidden service directory and set permissions
RUN mkdir -p /var/lib/tor/hidden_service/ && \
    chmod 700 /var/lib/tor/hidden_service/

# Copy the private key and hostname file into the container
COPY ./hidden_service/XXXX_secret_key /var/lib/tor/hidden_service/XXXX_secret_key
COPY ./hidden_service/XXXX_public_key /var/lib/tor/hidden_service/XXXX_public_key
COPY ./hidden_service/hostname /var/lib/tor/hidden_service/hostname

# Set correct permissions for the files
RUN chmod 600 /var/lib/tor/hidden_service/XXXX_secret_key && \
    chmod 600 /var/lib/tor/hidden_service/XXXX_public_key && \
    chmod 600 /var/lib/tor/hidden_service/hostname

# Set correct permissions for the files
RUN chown -R debian-tor:debian-tor /var/lib/tor/hidden_service/

# Command to start the services
CMD service tor start && lighttpd -D -f /etc/lighttpd/lighttpd.conf

Create the docker-compose.yml:

yaml

version: '3'

services:
  webserver-tor:
    build: .
    container_name: debian_lighttpd_tor
    ports:
      - "8888:80"
    volumes:
      - ./html:/var/www/html
      - ./tor:/etc/tor

Alternatively

bash

docker pull nicdercole/webserver-tor-lighttpd

docker run -d --name debian_lighttpd_tor -p 8888:80 -v $(pwd)/html:/var/www/html -v $(pwd)/tor:/etc/tor my-tor-webserver

Info

nicdercole/webserver-tor-lighttpd
