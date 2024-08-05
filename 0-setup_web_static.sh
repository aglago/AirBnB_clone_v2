#!/usr/bin/env bash
# a Bash script that sets up your web servers for the deployment of web_static

# Install Nginx if not already installed
sudo apt-get update
sudo apt-get -y install nginx

# Create necessary folders
sudo mkdir -p /data/web_static/releases/test /data/web_static/shared

# Create fake HTML file
echo "<html><head></head><body>Holberton School</body></html>" | sudo tee /data/web_static/releases/test/index.html

# Create symbolic link
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Set ownership
sudo chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
sudo sed -i 's|^.*server_name.*$|&\n\n\tlocation /hbnb_static {\n\t\talias /data/web_static/current/;\n\t}\n|' /etc/nginx/sites-available/default


# Restart Nginx
sudo service nginx restart

exit 0