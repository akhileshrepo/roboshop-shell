component=shipping
schema_type=mysql
source common.sh

func_java

app_password=$1
if [ -z "${app_password}" ]; then
  echo "Input password missing"
  exit 1
fi