pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'us-west-2'
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/akshbala2003/jenkins.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }
        stage('Approval') {
             when {
                expression { env.GIT_BRANCH == 'origin/main' || env.GIT_BRANCH == 'main' }
            }
            steps {
                script {
                    def userInput = input(
                        message: "Approve Terraform Apply?",
                        parameters: [booleanParam(defaultValue: false, description: 'Approve apply?', name: 'Proceed')]
                    )
                    if (!userInput) {
                        error("Terraform Apply Canceled")
                    }
                }
            }

        }
        stage('Terraform Apply') {
             when {
                expression { env.GIT_BRANCH == 'origin/main' || env.GIT_BRANCH == 'main' }
            }
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }
    
}
