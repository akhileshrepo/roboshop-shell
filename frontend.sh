source common.sh

log=/tmp/roboshop.log

echo "\e[36m>>>>>>>>>>>>>Install the nginx server<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
yum install nginx -y &>>${log}
func_exit_status

echo "\e[36m>>>>>>>>>>>>>copy the roboshop configuration<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log}
func_exit_status

echo "\e[36m>>>>>>>>>>>>>Remove the existing content<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
rm -rf /usr/share/nginx/html/* &>>${log}
func_exit_status

echo "\e[36m>>>>>>>>>>>>>Download the app content<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
func_exit_status

echo "\e[36m>>>>>>>>>>>>>change the Directory<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
cd /usr/share/nginx/html &>>${log}
func_exit_status

echo "\e[36m>>>>>>>>>>>>>Extract the Frontend content<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
unzip /tmp/frontend.zip &>>${log}
func_exit_status

echo "\e[36m>>>>>>>>>>>>>Restart the Nginx service<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
systemctl enable nginx &>>${log}
systemctl restart nginx &>>${log}
func_exit_status
