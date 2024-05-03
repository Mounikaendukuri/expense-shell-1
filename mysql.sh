#!/bin/bash

source ./common.sh

checkroot()

echo "please enter DB Password"
read mysql_root_password


dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "installing mysql sever"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enabling mysql service"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting mysql"

# my root password

mysql -h db.mounikadaws.online -uroot -p${mysql_root_password} -e 'show databases' &>>$LOGFILE
if [ $? -ne 0 ]
then     
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
VALIDATE $? "setting up the root password"
else
    echo -e "my sql password $Y already setup $N"
fi





