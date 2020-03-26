FROM alpine:latest

RUN apk update&&apk add nginx&&apk add openrc&&apk add curl&&apk add net-tools&&rm -f /etc/nginx/nginx.conf

COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /var/www/

EXPOSE 8080

CMD ["/usr/sbin/nginx","-c", "/etc/nginx/nginx.conf"]



