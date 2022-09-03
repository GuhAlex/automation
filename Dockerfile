FROM golang:alpine

RUN apk add --update git bash openssh terraform python3 py3-pip
RUN pip3 install cryptography

ARG PARAMETER_TOKEN
ENV PARAMETER_TOKEN=${PARAMETER_TOKEN}

WORKDIR /
COPY script-encrypted-parameter.py .
COPY main.tf .
RUN echo $PARAMETER_TOKEN > parameter.key
RUN python3 script-encrypted-parameter.py parameter.key decrypt

COPY app/* .
RUN go mod download github.com/hashicorp/hcl/v2
RUN go build -o append main.go 

ARG PARAMETER_NAME
ENV PARAMETER_NAME=$(PARAMETER_NAME)

ARG PARAMETER_KEY
ENV PARAMETER_KEY=$(PARAMETER_KEY)

ARG PARAMETER_VALUE
ENV PARAMETER_VALUE=$(PARAMETER_VALUE)

ARG PARAMETER_DESCRIPTION
ENV PARAMETER_DESCRIPTION=$(PARAMETER_DESCRIPTION)

ARG PARAMETER_TYPE
ENV PARAMETER_TYPE=$(PARAMETER_TYPE)

ARG PARAMETER_ENV
ENV PARAMETER_ENV=$(PARAMETER_ENV)

RUN ./append $PARAMETER_NAME $PARAMETER_KEY $PARAMETER_VALUE $PARAMETER_DESCRIPTION $PARAMETER_TYPE $PARAMETER_ENV
RUN python3 script-encrypted-parameter.py parameter.key encrypt


