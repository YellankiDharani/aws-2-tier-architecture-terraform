pipeline {
    agent any

    stages {
        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/YellankiDharani/aws-2-tier-architecture-terraform.git'
            }
        }

        stage('Terraform Init') {
            steps {
                bat 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                bat 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([usernamePassword(
                credentialsId: 'aws-creds',
                usernameVariable: 'AWS_ACCESS_KEY_ID',
                passwordVariable: 'AWS_SECRET_ACCESS_KEY'
        )]) {

                bat 'terraform plan'
            }
        }
    }
}
