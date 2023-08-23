cp user.service /etc/systemd/system/user.service
cp mongo.repo /etc/yum.repos.d/mongo.repo
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
useradd roboshop
mkdir /app 
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip 
cd /app 
unzip /tmp/user.zip
cd /app 
npm install 

yum install mongodb-org-shell -y
mongo --host mongodb.akhildevops.online </app/schema/user.js

systemctl daemon-reload
systemctl enable user 
systemctl restart user
