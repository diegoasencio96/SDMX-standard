FROM tomcat:8-jre7
MAINTAINER "Diego Alejandro Asencio Cuellar <diegoasencio96@gmail.com">

ENV CLASSPATH="/usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar"

EXPOSE 8080
CMD chmod +x /usr/local/tomcat/bin/catalina.sh
CMD ["catalina.sh", "run"]