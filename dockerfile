FROM jenkins/jenkins:jdk17-preview 
RUN  mkdir /Spring-Project
COPY  . /Spring-Project
RUN  /Spring-Project/mvnw package
EXPOSE 8080
ENTRYPOINT [java -jar target/*.jar]