FROM golang:1.18.5-alpine3.16

RUN apk add git bash openssh terraform python3 py3-pip aws-cli
RUN pip3 install cryptography

ARG PARAMETER_TOKEN
ENV PARAMETER_TOKEN=${PARAMETER_TOKEN}

WORKDIR /
COPY script-encrypted-parameter.py .
COPY main.tf .
RUN echo $PARAMETER_TOKEN > parameter.key
RUN python3 script-encrypted-parameter.py parameter.key decrypt

COPY app/* /
RUN go build -o append main.go 

ARG PARAMETER_NAME
ENV PARAMETER_NAME=${PARAMETER_NAME}

ARG PARAMETER_KEY
ENV PARAMETER_KEY=${PARAMETER_KEY}

ARG PARAMETER_VALUE
ENV PARAMETER_VALUE=${PARAMETER_VALUE}

ARG PARAMETER_DESCRIPTION
ENV PARAMETER_DESCRIPTION=${PARAMETER_DESCRIPTION}

ARG PARAMETER_TYPE
ENV PARAMETER_TYPE=${PARAMETER_TYPE}

ARG PARAMETER_ENV
ENV PARAMETER_ENV=${PARAMETER_ENV}

ARG AWS_ACCESS_KEY_ID
ENV AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
ARG AWS_SECRET_ACCESS_KEY
ENV AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
ARG AWS_SESSION_TOKEN
ENV AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}

RUN aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID" --profile ops-payer
RUN aws configure set aws_secret_access_id "$AWS_SECRET_ACCESS_KEY" --profile ops-payer
RUN aws configure set aws_session_token "$AWS_SESSION_TOKEN" --profile ops-payer
RUN ./append "$PARAMETER_NAME" "$PARAMETER_KEY" "$PARAMETER_VALUE" "$PARAMETER_DESCRIPTION" "$PARAMETER_TYPE" "$PARAMETER_ENV"


