FROM ghcr.io/ponylang/ponyc:release-alpine

LABEL org.opencontainers.image.source=https://github.com/redvers/pony-odbc-pg

RUN apk update
RUN apk add --no-cache unixodbc-dev psqlodbc bash 
RUN rm -rf /var/cache/apk/*

COPY .odbc.ini /root/
