component = payment
source common.sh
rabbimq_app_password=$1
if [-z "${rabbitmq_app_password}"]; then
    echo Input rabbitmq appuser password missing
    exit1
fi
func_python
