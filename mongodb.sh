cp mongodb.repo /etc/yum.repos.d/mongodb.repo
yum install mongodb-org -y 
#sed -i 's/127.0.0.1/0.0.0.0/' etc/mongodb.conf
systemctl enable mongod 
systemctl start mongod 
