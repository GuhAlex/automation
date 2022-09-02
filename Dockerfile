FROM golang:alpine

RUN apk add --update git bash openssh terraform python3 py3-pip
RUN pip3 install cryptography

