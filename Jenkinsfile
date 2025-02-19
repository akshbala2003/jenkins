pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'us-west-2'
    }
    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'gitlab-jenkins-id', 
                url: 'https://gitlab.presidio.com/abalakrishnan/jenkins',
                 branch: "${env.BRANCH_NAME}"
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
                branch 'master'
            }
            steps {
                input 'Approve to apply changes?'
            }
        }
        stage('Terraform Apply') {
            when {
                branch 'master'
            }
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }
    
}
