# uses Debian Bullseye as the base image, which provides a minimal OS envirnoment to start upon
FROM debian:bullseye

# updates the package manager and installs nginx webserver and OpenSSL tool
RUN apt-get update -y && apt-get upgrade -y \
	&& apt-get install -y nginx openssl \
	&& apt-get clean

# generates a self-signed SSL certificate
RUN mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 100 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt \
	-subj "/C=DE/ST=BW/L=HN/O=42Heilbronn/OU=student/CN=mevangel.42.fr"

# copies my custom nginx configuration to the container
COPY ./conf/nginx.conf /etc/nginx/

# exposes the HTTPS port
EXPOSE 443

# starts NGINX as a foreground, instead of background process (daemon mode)
CMD ["nginx", "-g", "daemon off;"]