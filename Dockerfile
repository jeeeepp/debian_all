FROM debian:buster
#wordpress
RUN apt-get update
RUN apt-get install -y vim
RUN apt-get install -y apache2
RUN apt-get install -y ghostscript 
RUN apt-get install -y libapache2-mod-php 
RUN apt-get install -y wget
RUN apt-get install -y php 
RUN apt-get install -y php-bcmath 
RUN apt-get install -y php-curl 
RUN apt-get install -y php-imagick 
RUN apt-get install -y php-intl 
RUN apt-get install -y php-json 
RUN apt-get install -y php-mbstring 
RUN apt-get install -y php-mysql 
RUN apt-get install -y php-xml 
RUN apt-get install -y php-zip
RUN apt-get install -y git curl
RUN apt-get install -y gnupg
RUN apt-get install -y apt-transport-https

#wordpress
RUN curl -o wordpress.tar.gz -fL "https://wordpress.org/wordpress-5.9.1.tar.gz"; \
	tar -xzf wordpress.tar.gz -C /usr/src/; \
	rm wordpress.tar.gz;
WORKDIR /var/www/html
RUN rm index.html
COPY ./html /var/www/html

#node express
RUN curl -fsSL https://deb.nodesource.com/setup_17.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g express
#run in command line
RUN npm install -g express-generator
#create folder file for express
WORKDIR /usr/src/app
COPY ./jeep/package.json /usr/src/app
RUN npm install
COPY ./jeep /usr/src/app

#jenkins
RUN wget https://pkg.jenkins.io/debian-stable/jenkins.io.key
RUN apt-key add jenkins.io.key
RUN echo "deb https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list
RUN apt-get update
RUN apt-get install -y default-jre
RUN apt-get install -y jenkins
#service jenkins start

#mongodb
RUN wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add -
RUN echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/5.0 main" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list
RUN apt-get update
RUN apt-get install -y mongodb-org
RUN mkdir -p /data/db
RUN apt-get install -y python3

COPY ./my_wrapper_script.sh /usr/src/app/
RUN chmod +x my_wrapper_script.sh
CMD [ "./my_wrapper_script.sh" ]
#ENTRYPOINT [ "/usr/sbin/apache2ctl"],["npm"]
#CMD [ "-DFOREGROUND"],["start"]

#CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
#ENTRYPOINT [ "npm"]
#CMD [ "start" ]
