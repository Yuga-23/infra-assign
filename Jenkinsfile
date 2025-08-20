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
                bat 'docker build -t yuga23/terraform-runner:latest .'
                echo '✅ Completed: Docker Build'
            }
        }

        stage('Push Docker Image') {
            steps {
                echo '📤 Starting: Docker Push'
                bat 'docker push yuga23/terraform-runner:latest'
                echo '✅ Completed: Docker Push'
            }
        }

        stage('Terraform Plan in Docker') {
            steps {
                echo '📐 Starting: Terraform Plan in Docker'
                bat '''
                    docker run --rm ^
                      -v %WORKSPACE%:/workspace ^
                      -w /workspace ^
                      -e AWS_ACCESS_KEY_ID=%AWS_ACCESS_KEY_ID% ^
                      -e AWS_SECRET_ACCESS_KEY=%AWS_SECRET_ACCESS_KEY% ^
                      yuga23/terraform-runner:latest ^
                      terraform plan -out=tfplan
                '''
                echo '✅ Completed: Terraform Plan'
            }
        }

        stage('Terraform Apply (Host Execution)') {
            steps {
                echo '🚀 Starting: Terraform Apply on Host'
                bat 'terraform apply -auto-approve tfplan'
                echo '✅ Completed: Terraform Apply'
            }
        }
    }

    post {
        success {
            echo '🎉 Pipeline completed successfully!'
        }
        failure {
            echo '⚠️ Pipeline failed. Check logs for details.'
        }
    }
}
