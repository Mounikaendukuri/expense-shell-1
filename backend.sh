#!/bin/bash

echo "please enter the root password"
read mysql_root_password


dnf module disable nodejs -y &>>LOGFILE

dnf module enable nodejs:20 -y &>>LOGFILE

dnf install nodejs -y &>>LOGFILE

id expense &>>LOGFILE #id expense will give whether the expense user has been added/not
if [ $? -ne 0 ]
then
    useradd expense &>>LOGFILE 
else
    echo " user expense already created "
fi

mkdir -p /app &>>LOGFILE #-p is used when app directory already created it will skip without throwing error



curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>LOGFILE


cd /app
rm -rf /app/*
unzip /tmp/backend.zip

npm install &>>LOGFILE

# (vim /etc/systemd/system/backend.service) we are not using vim becz shell script wont use vim is for manual so we are giving the absolute path for the backend file

cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service &>>LOGFILE


systemctl daemon-reload &>>LOGFILE

systemctl start backend &>>LOGFILE

systemctl enable backend &>>LOGFILE
dnf install mysql -y &>>LOGFILE


mysql -h db.mounikadaws.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>LOGFILE

systemctl restart backend &>>LOGFILE




