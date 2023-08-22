cp catalogue.service /etc/systemd/system/catalogue.service
cp mongodb.repo /etc/yum.repos.d/mongodb.repo
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
useradd roboshop

mkdir /app 
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip 

cd /app 
unzip /tmp/catalogue.zip
cd /app 
npm install 

yum install mongodb-org-shell -y
mongo --host mongodb.akhildevops.online </app/schema/catalogue.js

systemctl daemon-reload
systemctl enable catalogue 
systemctl restart catalogue

