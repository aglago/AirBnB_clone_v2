#!/usr/bin/env bash
# Set up web server for deployment of web static

# Install Nginx if not already installed
sudo apt-get update -y
sudo apt-get install nginx -y

# Create directories ...
sudo mkdir -p /data/web_static/{shared,releases/test}

# Create HTML file with content to test NGINX
cat << EOF | sudo tee /data/web_static/releases/test/index.html > /dev/null
<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>
EOF

# Remove symbolic link if exists
if [ -L /data/web_static/current ]; then
	sudo rm /data/web_static/current;
fi

# Create new symbolic link
sudo ln -s /data/web_static/releases/test/ /data/web_static/current

# Give ownership to ubuntu
sudo chown -R ubuntu:ubuntu /data

# Udate Nginx configuration to serve some content to hbnb_static
sudo sed -i "s|server_name _;|&\n\n\tlocation /hbnb_static {\n\t\talias /data/web_static/current/;\n\t}|" /etc/nginx/sites-available/default

# Restart Nginx
sudo nginx -s reload
