pipeline {
    agent any

    stages {
        stage('Git_checkout') {
             steps {
                git branch: 'main', url: 'https://github.com/balu1391/k8s-static-page-code.git'
            }
        }
        stage('docker login') {
            steps {
                sh 'aws ecr get-login-password --region ap-south-1 | sudo docker login --username AWS --password-stdin 861531569385.dkr.ecr.ap-south-1.amazonaws.com'
            }
        }
        stage('docker build') {
            steps {
		        sh 'sudo docker build -t 861531569385.dkr.ecr.ap-south-1.amazonaws.com/first-repo:$BUILD_NUMBER .'
                }
        }
        stage('docker image') {
            steps {
		        sh 'sudo docker push 861531569385.dkr.ecr.ap-south-1.amazonaws.com/first-repo:$BUILD_NUMBER'
                }
        }
        stage('replace build number') {
            steps {
		        sh 'sed -i s/number/$BUILD_NUMBER/g all-yaml/deployment.yaml'
                }
        }
        stage('1.namespace') {
            steps {
		        sh 'kubectl apply -f all-yaml/namespace.yaml'
                }
        }
         stage('2.deployment') {
            steps {
		        sh 'kubectl apply -f all-yaml/deployment.yaml'
                }
        }
        stage('3.service') {
            steps {
		        sh 'kubectl apply -f all-yaml/service.yaml'
                }
        }
        stage('4.ingress') {
            steps {
		        sh 'kubectl apply -f all-yaml/ingress.yaml'
                }
        }
        stage('get ingress enpoint') {
            steps {
		        sh 'kubectl get ingress -n static'
                }
        }
        
   }
}
