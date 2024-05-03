#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M_%S)
SCRIPT_NAME=$( echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
checkroot () {
    if [ $USERID -ne 0 ]
    then 
        echo "you need root access to execute"
        exit 1 #manually exist 
    else
        echo "you are super user"
    fi
}

VALIDATE() {
    if [ $? -ne 0 ]
    then
        echo -e "$2 is $R failure $N"
        exit 1
    else 
        echo -e "$2 is $G sucess $N"
    fi
}

