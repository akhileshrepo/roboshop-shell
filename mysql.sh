mysql_root_password = $1
if [-z "${mysql_root_password}"]; then
    echo Input password missing
    exit1
fi
cp mysql.repo /etc/yum.repos.d/mysql.repo
yum module disable mysql -y
yum install mysql-community-server -y
systemctl enable mysqld
systemctl restart mysqld  

mysql_secure_installation --set-root-pass ${mysql_root_password}
