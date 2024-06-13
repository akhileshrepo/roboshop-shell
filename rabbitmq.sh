rabbitmq_app_password=$1
if [ -z "${rabbitmq_app_password}" ]; then
  echo Input RabbitMQ AppUser Password Missing
  exit 1
fi

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
yum install rabbitmq-server -y
systemctl enable rabbitmq-server
systemctl start rabbitmq-server
rabbitmqctl add_user roboshop ${rabbitmq_app_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
