#!/bin/bash
yum -y update
yum -y install httpd
amazon-linux-extras install epel -y
yum install stress -y
systemctl start httpd
systemctl enable httpd
cat <<EOT > /var/www/html/index.html
<html>
<body style="background-color: yellow;">
    <h1 syle="color: green;"> Hi there from $(hostname -f) </h1>

    <h2 style="color: blue;">Version 1.0</h2>
</body>
</html>
EOT
