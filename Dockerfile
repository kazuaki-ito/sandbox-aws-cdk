FROM python:3.9-alpine

RUN apk add nodejs npm yarn
RUN apk add bash vim curl

RUN npm install -g aws-cdk

RUN pip3 install --upgrade aws-cdk.core
RUN pip3 install awscli

RUN mkdir /root/app

WORKDIR /root/app
