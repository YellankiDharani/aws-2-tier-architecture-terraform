pipeline {
    agent any

    stages {
        stage('Clone') {
            steps {
                git 'https://github.com/YellankiDharani/aws-2-tier-architecture-terraform.git'
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
                bat 'terraform plan'
            }
        }
    }
}
