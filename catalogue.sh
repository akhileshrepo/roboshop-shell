#component=catalogue
#schema_type=mongodb
#source common.sh

#func_nodejs

log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>> Create Catalogue service <<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cp catalogue.service /etc/systemd/system/catalogue.service &>>${log}


echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>  create Mongodb repos  <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cp mongo.repo /etc/yum.repos.d/mongo.repo  &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>  Install Nodejs Repos  <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>> Install Nodejs <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
yum install nodejs -y    &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> create application user <<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
useradd roboshop   &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> remove the old content <<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
rm -rf /app   &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> create application directory <<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
mkdir /app   &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Download application content <<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip  &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Extract application content <<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cd /app  &>>${log}
unzip /tmp/catalogue.zip     &>>${log}
cd /app    &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install Nodejs dependencies <<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
npm install    &>>${log}


echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install Mongo client<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
yum install mongodb-org-shell -y    &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Load catalogue schema <<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
mongo --host mongodb.akhildevops.online </app/schema/catalogue.js   &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Start catalogue service <<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
systemctl daemon-reload   &>>${log}
systemctl enable catalogue   &>>${log}
systemctl restart catalogue   &>>${log}