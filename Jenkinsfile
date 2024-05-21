pipeline {
  agent {
      kubernetes {
         yamlFile 'K8s-manifests/k8sPodTemplate.yml' 
      }
  }
  stages {
        stage('Depolying on EKS cluster') {
          steps {
            container('jenkins-agent') {
               sh '''
                 curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.3/2024-04-19/bin/linux/amd64/kubectl
                 chmod +x ./kubectl
                 mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
                 kubectl apply -f K8s-manifests/app.yml
               '''
            }
          }
        }
    }
}
