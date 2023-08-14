cp mongodb.repo /etc/yum.repos.d/mongodb.repo
yum install mongodb-org -y 
#update the listen address from 127.0.0.1 to 0.0.0.0 
systemctl enable mongod 
systemctl start mongod 
