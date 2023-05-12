pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        git branch:'devops', url:'https://github.com/sharmavickram/spring-boot-hello-world.git'
      }
    }

    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv('sonar-server') {
          sh 'mvn clean package sonar:sonar -Dmaven.test.skip=true -Dsonar.projectKey=spring-boot-hello-world'
        }
      }
    }

    stage('Build Docker Images') {
      steps {
        script {
          def modules = ['spring-boot-hello-world'] // Replace with your submodule names
          VERSION_NUMBER = VersionNumber(versionNumberString: '${BUILDS_ALL_TIME}')
          for (def module in modules) {
              def imageName = "mrvikram/${module}"
              def dockerfile = "${module}/Dockerfile" // Replace with the path to your Dockerfile
              
              sh "docker build -t ${imageName} -f ${dockerfile} ."
          }
        }
      }
    }
	
	stage('Push Docker Images') {
      steps {
        script {
          def modules = ['spring-boot-hello-world'] // Replace with your submodule names
          VERSION_NUMBER = VersionNumber(versionNumberString: '${BUILDS_ALL_TIME}')
          for (def module in modules) {
            
            docker.withRegistry('', 'docker_password') {
              def tag = "version-${VERSION_NUMBER}"
              def imageName = "mrvikram/${module}"
              def dockerfile = "${module}/Dockerfile" // Replace with the path to your Dockerfile
              
              sh "docker tag ${imageName}:latest ${imageName}:${tag}"
              sh "docker push ${imageName}:${tag}"
            }
          }
        }
      }
    }
  }
}