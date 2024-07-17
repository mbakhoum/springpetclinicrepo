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
        '''
    }
  }
  environment {
        NEXUS_USER = 'admin'
		NEXUS_PASS = 'nexus123'
		NEXUSIP = '34.144.203.236'
		NEXUS_LOGIN = 'nexuslogin'
        RELEASE_REPO = 'artifactrepo'
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
    stage("UploadArtifact"){
            steps{
                nexusArtifactUploader(
                  nexusVersion: 'nexus3',
                  protocol: 'http',
                  nexusUrl: "${NEXUSIP}",
                  groupId: 'QA',
                  version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
                  repository: "${RELEASE_REPO}",
                  credentialsId: "${NEXUS_LOGIN}",
                  artifacts: [
                    [artifactId: 'springpetclinic',
                     classifier: '',
                     file: 'target/*.jar',
                     type: 'war']
                  ]
                )
            }
        }
    }
}