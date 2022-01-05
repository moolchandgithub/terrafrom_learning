#!/bin/bash
apt-get update
apt-get -y install apache2
cat <<EOF > /var/www/html/index.html
 <html>
     <h1>Welcome to GCP</h1><br>
     <h2>This file is built by <font color=red> Terraform </font> File </h2><br>
 </html>
EOF
systemctl restart apache2