cp mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongo.conf
systemctl enable mongodb
systemctl restart mongodb
