#!/bin/bash

source ./common.sh
checkroot

dnf install nginx -y &>>LOGFILE
VALIDATE $? "installing the ngnix"

systemctl enable nginx &>>LOGFILE
VALIDATE $? "enabling the ngnix"

systemctl start nginx &>>LOGFILE
VALIDATE $? "start the ngnix"

rm -rf /usr/share/nginx/html/*  &>>LOGFILE
VALIDATE $? "removing existing content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>LOGFILE
VALIDATE $? "downloading frontend code"

cd /usr/share/nginx/html &>>LOGFILE
unzip /tmp/frontend.zip &>>LOGFILE
VALIDATE $? "extracting the code of frontend"

cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf &>>LOGFILE
VALIDATE $? "copying the expense conf"

systemctl restart nginx &>>LOGFILE
VALIDATE $? "restarting the nginx"