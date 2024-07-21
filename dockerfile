FROM jenkins/jenkins:jdk17-preview
USER root
RUN mkdir -p /home/jenkins/Spring-Project
COPY . /home/jenkins/Spring-Project

WORKDIR /home/jenkins/Spring-Project
RUN ./mvnw package

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "target/*.jar"]
