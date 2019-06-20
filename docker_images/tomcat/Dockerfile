FROM tomcat:8.5.35-jre10
MAINTAINER "Diego Alejandro Asencio Cuellar <diegoasencio96@gmail.com">


VOLUME ["/usr/local/tomcat/conf"]
VOLUME ["/usr/local/tomcat/webapps"]

EXPOSE 8080
CMD chmod +x /usr/local/tomcat/bin/catalina.sh
CMD ["catalina.sh", "run"]