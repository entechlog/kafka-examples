FROM golang:alpine

RUN apk add --update bash curl git && \
    apk add ca-certificates wget && \
    update-ca-certificates && \ 
    rm -rf /var/cache/apk/*

RUN git clone https://github.com/linkedin/Burrow.git

WORKDIR Burrow

RUN go mod tidy && \
    go install