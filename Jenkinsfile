pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: maven
            image: maven:latest
            command:
            - cat
            tty: true
          - name: kaniko
            image: gcr.io/kaniko-project/executor:v1.6.0-debug
            command:
            - cat
            tty: true
            volumeMounts:
              - name: jenkins-docker-cfg
                mountPath: /kaniko/.docker
          - name: kubectl
            image: bitnami/kubectl:latest
            command:
            - cat
            tty: true
          volumes:
          - name: jenkins-docker-cfg
            secret:
              secretName: kaniko-secret

        '''
    }
  }
  options {
    ansiColor('xterm')
  }
  environment {
    NEXUS_VERSION = "nexus3"
    NEXUS_PROTOCOL = "http"
    NEXUS_URL = "10.16.2.159:8081"
    NEXUS_REPOSITORY = "artifactrepo"
    NEXUS_CREDENTIAL_ID = "nexuslogin"
    NEXUS_USERNAME = "admin"
    NEXUS_PASSWORD = "nexus123"
    //APP_NAME = "spring-petclinic"
    DOCKER_REPO = "10.16.2.159:8082/repository/dockerrepo"
    IMAGE_NAME = "spring-petclinic"
    TAG = "V${env.BUILD_ID}"
    ///OUTPUT_FILE = "pulledimage" 
    PROJECT_ID = "cicd-javaapp"
    ///KUBE_NAMESPACE = "app-tst"
  }
  stages {
    stage('Continuous Integration') {
      steps {
        container('maven') {
          sh 'mvn -version'
          sh 'mvn -DskipTests clean install'
          echo "Now Archiving."
          archiveArtifacts artifacts: '**/*.jar'
          script {
            pom = readMavenPom file: "pom.xml";
            filesByGlob = findFiles(glob: "target/*.${pom.packaging}"); 
            echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
            artifactPath = filesByGlob[0].path;
            artifactExists = fileExists artifactPath;
            if(artifactExists) {
                echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";
                nexusArtifactUploader(
                    nexusVersion: NEXUS_VERSION,
                    protocol: NEXUS_PROTOCOL,
                    nexusUrl: NEXUS_URL,
                    groupId: pom.groupId,
                    version: "${env.BUILD_ID}",
                    repository: NEXUS_REPOSITORY,
                    credentialsId: NEXUS_CREDENTIAL_ID,
                    artifacts: [
                        [artifactId: pom.artifactId,
                        classifier: '',
                        file: artifactPath,
                        type: pom.packaging],
                        [artifactId: pom.artifactId,
                        classifier: '',
                        file: "pom.xml",
                        type: "pom"]
                    ]
                );
            } else {
                error "*** File: ${artifactPath}, could not be found";
            }
          }
        }

        container('kaniko') {
          sh "ls $WORKSPACE"
         // sleep 900
          sh "/kaniko/executor --dockerfile $WORKSPACE/dockerfile -c $WORKSPACE/ --insecure --skip-tls-verify --cache=true --destination=${DOCKER_REPO}/${IMAGE_NAME}:${TAG} --force"
        }

        container('kubectl') { 
          //sleep 9000
          sh "kubectl apply -f $WORKSPACE/springpet.yaml"
                }
             }
         }
     }  
  }
