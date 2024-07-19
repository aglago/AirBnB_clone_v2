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

# Create new symbolic link, delete first if already exists
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Give ownership to ubuntu
sudo chown -R ubuntu:ubuntu /data

# Udate Nginx configuration to serve some content to hbnb_static
sudo sed -i "s|server_name _;|&\n\n\tlocation /hbnb_static {\n\t\talias /data/web_static/current/index.html;\n\t}|" /etc/nginx/sites-available/default

# Restart Nginx
sudo service nginx restart

# Exit with status 0
exit 0
