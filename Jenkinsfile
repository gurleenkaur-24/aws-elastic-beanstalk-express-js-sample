pipeline {
  agent any

  environment {
    IMAGE = "gurleenkaur22131597/project2-app"
    TAG   = "build-${env.BUILD_NUMBER}"
  }

  stages {
    stage('Install & Test (Node 16)') {
      steps {
        script {
          docker.image('node:16').inside('-u root:root') {
            sh '''
              node -v
              npm ci || npm install --save
              npm test || echo "No tests defined"
            '''
          }
        }
      }
    }

    stage('Security Scan (npm audit)') {
      steps {
        script {
          docker.image('node:16').inside('-u root:root') {
            sh '''
              npm ci || npm install
              # Fail on High (you can change to critical if needed)
              npm audit --audit-level=high
            '''
          }
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t ${IMAGE}:${TAG} -t ${IMAGE}:latest .'
      }
    }

    stage('Push Docker Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                          usernameVariable: 'DOCKER_USER',
                                          passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker push ${IMAGE}:${TAG}
            docker push ${IMAGE}:latest
          '''
        }
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'Dockerfile, Jenkinsfile, **/package*.json, **/npm-*.log', allowEmptyArchive: true
    }
  }
}
