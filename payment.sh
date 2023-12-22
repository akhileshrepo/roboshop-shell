#component=payment
#source common.sh
#rabbitmq_app_password=$1
#if [ -z "${rabbitmq_app_password}" ]; then
#  echo Input RabbitMQ AppUser Password Missing
#  exit 1
#fi
#func_python

cp payment.service /etc/systemd/system/payment.service
dnf install python36 gcc python3-devel -y
useradd roboshop
mkdir /app
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app
unzip /tmp/payment.zip
cd /app
pip3.6 install -r requirements.txt


systemctl daemon-reload
systemctl enable payment
systemctl start payment