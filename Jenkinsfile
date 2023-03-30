pipeline {
    agent any
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
               
                sh 'read -p "IAM name (i.e. tftest ) : " IAMNAME'
                sh 'terraform-backups'
                sh 'MYPROJECT=`gcloud config get-value project`
                sh 'MY_GCP_SA=${IAMNAME}@${MYPROJECT}.iam.gserviceaccount.com'
                sh 'gcloud iam service-accounts keys create ~/${IAMNAME}_key.${MYPROJECT}.json --iam-account ${MY_GCP_SA} --project ${MYPROJECT} eval export GOOGLE_APPLICATION_CREDENTIALS=~/${IAMNAME}_key.${MYPROJECT}.json env | grep GOOGLE_APPLICATION_CREDENTIALS'
                sh 'gcloud auth activate-service-account ${MY_GCP_SA} --key-file ~/${IAMNAME}_key.${MYPROJECT}.json --project ${MYPROJECT}'
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
