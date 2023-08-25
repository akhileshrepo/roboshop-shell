func_exit_status() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32m SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
  fi
}

func_apppreq() {
    log=/tmp/roboshop.log

    echo "\e[36m>>>>>>>>>>>>>create ${component} service<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
    func_exit_status

    echo "\e[36m>>>>>>>>>>>>>create application user<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    id roboshop &>>${log}
    if [ $? -ne 0 ]; then
        useradd roboshop &>>${log}
    fi
    func_exit_status
    

    echo "\e[36m>>>>>>>>>>>>>cleanup existing content<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    rm -rf /app &>>${log}
    func_exit_status

    echo "\e[36m>>>>>>>>>>>>>create application directory<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    mkdir /app &>>${log}
    func_exit_status

    echo "\e[36m>>>>>>>>>>>>>Download application content<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
    func_exit_status

    echo "\e[36m>>>>>>>>>>>>>Extract application content<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    cd /app 
    unzip /tmp/${component}.zip &>>${log}
    func_exit_status
}

func_systemd() {
    echo "\e[36m>>>>>>>>>>>>>start ${component} service<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    systemctl daemon-reload &>>${log}
    systemctl enable ${component} &>>${log}
    systemctl restart ${component} &>>${log}
    func_exit_status
}

func_schema_setup() {
    if ["${schema_type}" == "mongodb"]; then
        echo "\e[36m>>>>>>>>>>>>>Install Mongo client<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
        yum install mongodb-org-shell -y &>>${log}
        func_exit_status

        echo "\e[36m>>>>>>>>>>>>>Load ${component} schema<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
        mongo --host mongodb.akhildevops.online </app/schema/${component}.js &>>${log}
        func_exit_status
    fi

    if ["${schema_type}" == "mysql"]; then
        echo "\e[36m>>>>>>>>>>>>>Install mysql client<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
        yum install mysql -y &>>${log}
        func_exit_status

        echo "\e[36m>>>>>>>>>>>>>Load schema<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
        mysql -h mysql.rdevopsb72.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
        func_exit_status
    fi
}

func_nodejs() {
    log=/tmp/roboshop.log
    echo -e "\e[36m>>>>>>>>>>>>  Create MongoDB Repo  <<<<<<<<<<<<\e[0m" | tee -a ${log}
    cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
    func_exit_status

    echo "\e[36m>>>>>>>>>>>>>Install Nodejs Repos<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
    func_exit_status

    echo "\e[36m>>>>>>>>>>>>>Install Nodejs<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    yum install nodejs -y &>>${log}
    func_exit_status

    func_apppreq

    echo "\e[36m>>>>>>>>>>>>>Download Nodejs Dependencies<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    npm install &>>${log}
    func_exit_status

    func_schema_setup

    func_systemd
}

func_java() {
    echo "\e[36m>>>>>>>>>>>>>Install Maven<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    yum install maven -y &>>${log}
    func_exit_status

    func_apppreq

    echo "\e[36m>>>>>>>>>>>>>Build cart service<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    mvn clean package &>>${log}
    mv target/${component}-1.0.jar ${component}.jar &>>${log}
    func_exit_status

    func_schema_setup

    func_systemd 

}

func_python() {

    echo "\e[36m>>>>>>>>>>>>>Build ${component} service<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    yum install python36 gcc python3-devel -y &>>${log}
    func_exit_status

    func_apppreq

    sed -i "s/rabbitmq_app_password/${rabbitmq_app_password}/" /etc/systemd/system/${component}.service

    echo "\e[36m>>>>>>>>>>>>>Build ${component} service<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    pip3.6 install -r requirements.txt &>>${log}
    func_exit_status

    func_systemd
}
