#log=/tmp/roboshop.log


#func_exit_status() {
#  if [ $? -eq 0 ]; then
#    echo -e "\e[32m SUCCESS \e[0m"
#  else
#    echo -e "\e[31m FAILURE \e[0m"
#  fi
#}

#func_apppreq() {
#  echo -e "\e[36m>>>>>>>>>>>>  Create ${component} Service  <<<<<<<<<<<<\e[0m"
#  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
#  func_exit_status
#
#  echo -e "\e[36m>>>>>>>>>>>>  Create Application User  <<<<<<<<<<<<\e[0m"
#  id roboshop &>>${log}
#  if [ $? -ne 0 ]; then
#    useradd roboshop &>>${log}
#  fi
#  func_exit_status

#  echo -e "\e[36m>>>>>>>>>>>>  Cleanup Existing Application Content  <<<<<<<<<<<<\e[0m"
#  rm -rf /app &>>${log}
#  func_exit_status

#  echo -e "\e[36m>>>>>>>>>>>>  Create Application Directory  <<<<<<<<<<<<\e[0m"
#  mkdir /app &>>${log}
#  func_exit_status

#  echo -e "\e[36m>>>>>>>>>>>>  Download Application Content  <<<<<<<<<<<<\e[0m"
#  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
#  func_exit_status

#  echo -e "\e[36m>>>>>>>>>>>>  Extract Application Content  <<<<<<<<<<<<\e[0m"
#  cd /app
#  unzip /tmp/${component}.zip &>>${log}
#  func_exit_status
#}

#func_systemd() {
#echo -e "\e[36m>>>>>>>>>>>>  Start ${component} Service  <<<<<<<<<<<<\e[0m"  | tee -a /tmp/roboshop.log
#  systemctl daemon-reload &>>${log}
#  systemctl enable ${component} &>>${log}
#  systemctl restart ${component} &>>${log}
#  func_exit_status
#}

#func_schema_setup() {
#if [ "${schema_type}" == "mongodb" ]; then
#    echo -e "\e[36m>>>>>>>>>>>>  INstall Mongo Client  <<<<<<<<<<<<\e[0m"  | tee -a /tmp/roboshop.log
#    yum install mongodb-org-shell -y &>>${log}
#    func_exit_status
#
#    echo -e "\e[36m>>>>>>>>>>>>  Load User Schema  <<<<<<<<<<<<\e[0m"  | tee -a /tmp/roboshop.log
#    mongo --host 172.31.90.43 </app/schema/${component}.js &>>${log}
#    func_exit_status
#  fi

#  if [ "${schema_type}" == "mysql" ]; then
#    echo -e "\e[36m>>>>>>>>>>>>  Install MySQL Client   <<<<<<<<<<<<\e[0m"
#    yum install mysql -y &>>${log}
#    func_exit_status

#    echo -e "\e[36m>>>>>>>>>>>>  Load Schema   <<<<<<<<<<<<\e[0m"
#    mysql -h mysql-dev.akhildevops.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
#    func_exit_status
#  fi

#}

func_apppreq() {

    log=/tmp/roboshop.log

    echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>> Create ${component} service <<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    cp ${component}.service /etc/systemd/system/${component}.service &>>${log}

    echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> create application user <<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    useradd roboshop   &>>${log}

    echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> remove the old content <<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    rm -rf /app   &>>${log}

    echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> create application directory <<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    mkdir /app   &>>${log}

    echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Download application content <<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  &>>${log}

    echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Extract application content <<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    cd /app  &>>${log}
    unzip /tmp/${component}.zip     &>>${log}
    cd /app    &>>${log}
}

func_systemd() {

   log=/tmp/roboshop.log

   echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Start ${component} service <<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
   systemctl daemon-reload   &>>${log}
   systemctl enable ${component}   &>>${log}
   systemctl restart ${component}   &>>${log}
}

func_schema_setup() {
    log=/tmp/roboshop.log

    if [ "${schema_type}" == "mongodb"]; then
      echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install Mongo client<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
      yum install mongodb-org-shell -y    &>>${log}

      echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Load ${component} schema <<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
      mongo --host mongodb.akhildevops.online </app/schema/${component}.js   &>>${log}
    fi

    if [ "${schema_type}" == "mysql"]; then
      echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>> Install mysql client <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
        dnf install mysql -y  &>>${log}

        echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>> Load schema <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
        mysql -h mysql.akhildevops.online -uroot -pRoboShop@1 < /app/schema/${component}.sql  &>>${log}
    fi
}

func_nodejs() {

  log=/tmp/roboshop.log

  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>> Create ${component} service <<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}


  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>  create Mongodb repos  <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  cp mongo.repo /etc/yum.repos.d/mongo.repo  &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>  Install Nodejs Repos  <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>> Install Nodejs <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  yum install nodejs -y    &>>${log}

  func_apppreq

  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install Nodejs dependencies <<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  npm install    &>>${log}


  func_schema_setup

  func_systemd
}

func_java() {

  log=/tmp/roboshop.log

  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>>>>>>> Create ${component} service <<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  cp ${component}.service /etc/systemd/system/${component}.service  &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>> Install Maven <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  yum install maven -y  &>>${log}


 func_apppreq

  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>> Build ${component} service <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  mvn clean package  &>>${log}
  mv target/${component}-1.0.jar ${component}.jar  &>>${log}

  func_schema_setup

  func_systemd
}

func_python() {

  log=/tmp/roboshop.log

  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>> Build ${component} service <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  dnf install python36 gcc python3-devel -y &>>${log}

  func_apppreq

  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>> Build ${component} service <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  pip3.6 install -r requirements.txt &>>${log}

  func_systemd

}
