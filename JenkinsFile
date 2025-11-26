pipeline {
  agent any

  environment {
    IMAGE = "shivsoftapp/static-site"
    TAG = "latest"
  }

  stages {

    stage('Checkout Code') {
      steps {
        git branch: 'main',
            url: 'https://github.com/shivnathyadav73/static-website.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        powershell "docker build -t ${IMAGE}:${TAG} ."
      }
    }

    stage('Push to DockerHub') {
      steps {
        withCredentials([
          usernamePassword(
            credentialsId: 'dockerhub',
            usernameVariable: 'DOCKER_USER',
            passwordVariable: 'DOCKER_PASS'
          )
        ]) {
          powershell 'echo $env:DOCKER_PASS | docker login -u $env:DOCKER_USER --password-stdin'
          powershell "docker push ${IMAGE}:${TAG}"
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        withCredentials([
          file(credentialsId: 'kubeconfig_cred', variable: 'KCFG')
        ]) {
          powershell "(Get-Content k8s-deployment.yaml) -replace 'DOCKERHUB_USERNAME/static-site:latest', '${IMAGE}:${TAG}' | Set-Content k8s-deployment.yaml"
          powershell "kubectl --kubeconfig=$env:KCFG apply -f k8s-deployment.yaml"
          powershell "kubectl --kubeconfig=$env:KCFG rollout status deployment/static-site-deploy"
        }
      }
    }
  }

  post {
    always {
      powershell "docker logout || echo 'Logout failed but safe'"
    }
  }
}
