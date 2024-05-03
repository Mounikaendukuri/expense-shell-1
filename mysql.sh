#!/bin/bash

source ./common.sh

checkroot

echo " please enter DB Password "
read mysql_root_password

dnf install mysql-server -y &>>$LOGFILE
systemctl enable mysqld &>>$LOGFILE
systemctl start mysqld &>>$LOGFILE


# my root password

mysql -h db.mounikadaws.online -uroot -p${mysql_root_password} -e 'show databases' &>>$LOGFILE
if [ $? -ne 0 ]
then     
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
else
    echo -e "my sql password $Y already setup $N"
fi





