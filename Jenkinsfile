pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }

    stages {
        stage('Clone Terraform Repo') {
            steps {
                echo '🔍 Starting: Clone Terraform Repo'
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/Yuga-23/infra-assign.git',
                        credentialsId: 'github-credentials'
                    ]]
                ])
                echo '✅ Completed: Clone Terraform Repo'
            }
        }

        stage('Docker Login') {
            steps {
                echo '🔐 Starting: Docker Login'
                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    bat '''
                        echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                    '''
                }
                echo '✅ Completed: Docker Login'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🐳 Starting: Docker Build'
                bat 'docker build -t yugandhar/my-app:latest .'
                echo '✅ Completed: Docker Build'
            }
        }

        stage('Push Docker Image') {
            steps {
                echo '📤 Starting: Docker Push'
                bat 'docker push yugandhar/my-app:latest'
                echo '✅ Completed: Docker Push'
            }
        }

        stage('Initialize Terraform') {
            steps {
                echo '🔧 Starting: Terraform Init'
                bat 'terraform init'
                echo '✅ Completed: Terraform Init'
            }
        }

        stage('Validate Terraform') {
            steps {
                echo '🔍 Starting: Terraform Validate'
                bat 'terraform validate'
                echo '✅ Completed: Terraform Validate'
            }
        }

        stage('Plan Infrastructure') {
            steps {
                echo '📐 Starting: Terraform Plan'
                bat 'terraform plan -out=tfplan'
                echo '✅ Completed: Terraform Plan'
            }
        }

        stage('Apply Infrastructure') {
            steps {
                echo 'terraform apply'
                bat 'terraform apply -auto-approve tfplan'
                echo '✅ Completed: Terraform Apply'
            }
        }
    }

    post {
        success {
            echo '🎉 Pipeline finibated successfully!'
        }
        failure {
            echo '⚠️ Pipeline failed. Check which stage was last completed.'
        }
    }
}
