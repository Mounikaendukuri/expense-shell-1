#!/bin/bash

USERID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.LOG

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE() {
    if [ $? -ne 0 ]
    then
        echo -e "$2 is $R failure $N"
        exit 1
    else 
        echo -e "$2 is $G sucess $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi

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