

#!/bin/bash
apt update -y
apt install apache2 -y
systemctl start apache2
systemctl enable apache2
echo "Hello from Dharani 2-Tier Project" > /var/www/html/index.html