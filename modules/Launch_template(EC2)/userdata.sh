#!/bin/bash

yum update -y
yum install -y httpd

systemctl start httpd
systemctl enable httpd

TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`

INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
http://169.254.169.254/latest/meta-data/instance-id)

PRIVATE_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
http://169.254.169.254/latest/meta-data/local-ipv4)

cat <<EOF > /var/www/html/index.php
<?php
echo "<h1>🚀 2-Tier Project Working</h1>";
echo "<h3>Instance ID: $INSTANCE_ID</h3>";
echo "<h3>Private IP: $PRIVATE_IP</h3>";
echo "<h3>Client IP: " . \$_SERVER['REMOTE_ADDR'] . "</h3>";
?>
EOF

yum install -y php

systemctl restart httpd