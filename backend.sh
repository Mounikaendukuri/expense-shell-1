#!/bin/bash

USERID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.LOG

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "please enter the root password"
read mysql_root_password

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


dnf module disable nodejs -y &>>LOGFILE
VALIDATE $? " Disable the old version "

dnf module enable nodejs:20 -y &>>LOGFILE
VALIDATE $? " enable  the new version in system "

dnf install nodejs -y &>>LOGFILE
VALIDATE $? " install the new version "

id expense &>>LOGFILE #id expense will give whether the expense user has been added/not
if [ $? -ne 0 ]
then
    useradd expense &>>LOGFILE 
    VALIDATE $? " creating expense user "
else
    echo " user expense already created "
fi

mkdir -p /app &>>LOGFILE #-p is used when app directory already created it will skip without throwing error
VALIDATE $? " creating app directory "


curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>LOGFILE
VALIDATE $? " download the backend code "

cd /app
rm -rf /app/*
unzip /tmp/backend.zip
VALIDATE $? " Extracted the backend code "

npm install &>>LOGFILE
VALIDATE $? " installing node js dependencies "

# (vim /etc/systemd/system/backend.service) we are not using vim becz shell script wont use vim is for manual so we are giving the absolute path for the backend file

cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service &>>LOGFILE

VALIDATE $? "copied backend service"

systemctl daemon-reload &>>LOGFILE
VALIDATE $? "daemon reload"

systemctl start backend &>>LOGFILE
VALIDATE $? "starting backend"

systemctl enable backend &>>LOGFILE
VALIDATE $? "Enable backend"

dnf install mysql -y &>>LOGFILE
VALIDATE $? "installing mysql client"


mysql -h db.mounikadaws.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>LOGFILE
VALIDATE $? "schema loading"

systemctl restart backend &>>LOGFILE
VALIDATE $? "restaring backend"



