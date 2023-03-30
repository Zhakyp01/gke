pipeline {
    agent any
    environment {
        GCLOUD_CREDS = credentials('cred')
        PROJECT_ID = 	'student-project-379814'
        CLUSTER_NAME = 'private-cluster'
        LOCATION = 'us-west1-a'
        CREDENTIALS_ID = 'student-project-379814'
    }
    parameters {
        string(name: 'environment', defaultValue: 'terraform', description: 'Workspace/environment file to use for deployment')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        booleanParam(name: 'destroy', defaultValue: false, description: 'Destroy Terraform build?')

    }
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', credentialsId: 'jenkins', url: 'https://github.com/Zhakyp01/gke.git'
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'terraform init -reconfigure'
                
            }
        }
        stage('Terraform Plan') {
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            steps {
                
               
                sh 'terraform plan -var "cred=$GCLOUD_CREDS"'
                
            }
        }
        stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }
               not {
                    equals expected: true, actual: params.destroy
                }
           }
           
                
            

           steps {
               script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
           }
       }
        stage('Terraform Apply') {
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            steps {
                
                sh 'terraform apply --auto-approve -var "cred=$GCLOUD_CREDS"'
            
            }
        }
        stage('Destroy') {
            when {
                equals expected: true, actual: params.destroy
            }
        
        steps {
           
           sh 'terraform destroy --auto-approve -var "cred=$GCLOUD_CREDS"'
           
        }
    }
        stage('deploytokubernetes') {
           steps {
              sh 'gcloud container clusters get-credentials env.CLUSTER_NAME --zone env.LOCATION --project env.PROJECT_ID'
              step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'deployment.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
    
        }
      }
    }
}
