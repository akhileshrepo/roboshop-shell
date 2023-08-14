cp cart.service /etc/systemd/system/cart.service
cp cart.repo /etc/yum.repos.d/cart.repo
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
useradd roboshop
mkdir /app 
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip 
cd /app 
unzip /tmp/cart.zip
cd /app 
npm install 

yum install mongodb-org-shell -y
mongo --host MONGODB-SERVER-IPADDRESS </app/schema/cart.js

systemctl daemon-reload
systemctl enable cart
systemctl restart cart
