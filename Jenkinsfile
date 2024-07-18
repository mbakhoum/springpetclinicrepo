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
    }
  }
  environment {
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_USER = 'admin'
		    NEXUS_PASS = 'nexus123'
		    NEXUS_URL = '34.144.203.236'
		    NEXUS_CREDENTIAL_ID = 'nexuslogin'
        NEXUS_REPOSITORY = 'artifactrepo'
    }
  stages {
    stage('Run maven') {
      steps {
        container('maven') {
          sh 'mvn -version'
          sh 'mvn -s pom.xml -DskipTests clean install'
          echo "Now Archiving."
          archiveArtifacts artifacts: '**/*.jar'
          
        }      
      } 
    }
  }
}
