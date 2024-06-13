source common.sh

echo -e "\e[36m>>>>>>>>>>> Download mongo repos <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cp mongo.repo /etc/yum.repos.d/mongo.repo
func_exit_status

echo -e "\e[36m>>>>>>>>>>> Install Mongodb <<<<<<<<<<<<<<\e[0m"
yum install mongodb-org -y
func_exit_status

echo -e "\e[36m>>>>>>>>>>> update listen address <<<<<<<<<<<<<<\e[0m"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
func_exit_status

echo -e "\e[36m>>>>>>>>>>> Restart the service <<<<<<<<<<<<<<\e[0m"
systemctl enable mongod
systemctl restart mongod
func_exit_status
