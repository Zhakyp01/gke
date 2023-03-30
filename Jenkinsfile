pipeline {
    agent any
    parameters {
        string(name: 'environment', defaultValue: 'terraform', description: 'Workspace/environment file to use for deployment')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        booleanParam(name: 'destroy', defaultValue: false, description: 'Destroy Terraform build?')

    }
    environment {
    PROJECT_ID =   'student-project-379814'
//     LOCATION = 'us-central1-b'
    GCLOUD_CREDS = credentials('student-project-379814')
  }
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', credentialsId: 'jenkins', url: 'https://github.com/Zhakyp01/gke.git'
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'gcloud auth activate-service-account --key-file="$GCLOUD_CREDS"'
                sh 'terraform init '
                
            }
        }
        stage('Terraform Plan') {
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            steps {
                 withCredentials([[$class: 'FileBinding', credentialsId: 'student-project-379814', variable: 'GOOGLE_APPLICATION_CREDENTIALS']]) 
                {
               
                sh 'terraform plan'
                }
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
                withCredentials([[$class: 'FileBinding', credentialsId: 'student-project-379814', variable: 'GOOGLE_APPLICATION_CREDENTIALS']])  
                {
                sh 'terraform apply --auto-approve'
                }
            }
        }
        stage('Destroy') {
            when {
                equals expected: true, actual: params.destroy
            }
        
        steps {
           withCredentials([[$class: 'FileBinding', credentialsId: 'student-project-379814', variable: 'GOOGLE_APPLICATION_CREDENTIALS']])  
           {
           sh "terraform destroy --auto-approve"
           }
        }
    }
    }
}