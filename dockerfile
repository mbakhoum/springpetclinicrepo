FROM jenkins/jenkins:jdk17-preview 
ARG NEXUS_USERNAME
ARG NEXUS_PASSWORD
RUN echo "http://${NEXUS_USERNAME}:${NEXUS_PASSWORD}@10.16.2.22:8082/" > /kaniko/.docker/config.json
RUN  mkdir /Spring-Project
COPY  . /Spring-Project
RUN  /Spring-Project/mvnw package
EXPOSE 8080
ENTRYPOINT [java -jar target/*.jar]