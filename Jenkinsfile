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
              def dockerfile = "./Dockerfile" // Replace with the path to your Dockerfile
              
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
            
            docker.withRegistry('', 'dockerhubpass') {
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
    stage ('identifying misconfiguration using datree in helm charts'){
      steps{
          script{
            dir('kubernetes/') {
             withEnv(['DATREE_TOKEN=49e8d2a5-7e55-4606-bf0c-57d18fafa20a']) {
                sh 'helm datree test myapp/ --no-record'
              } 
            }
          }
        }
      }
      stage('get kubernetes cluster nodes details') {
         steps {
                 sh 'export KUBECONFIG=.kube/config/kubeconfig.yaml'
                 sh 'kubectl get nodes'
          }
      }
      stage('deploying applications to k8s cluster'){
        steps{
          script{
            withCredentials([kubeconfigContent(credentialsId: 'kubeconfig', variable: 'KUBECONFIG_CONTENT')]) {
              dir ("kubernetes/"){  
                sh 'helm list'
                sh 'helm upgrade --install --set image.repository="mrvikram/spring-boot-hello-world" --set image.tag=":version-4" --set KUBECONFIG="/home/manish_singh/kubeconfig.yaml" spring-boot-hello-world myapp/ '
                sh 'helm version' 
              }
            } 
          }		
		    }
	    }

      
   }  
}
