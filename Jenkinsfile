pipeline {
    agent any

    tools {
        terraform "tf-1.3.4"
    }

    environment {
        ENVIRONMENT = "dev"
        NICKNAME = "posts"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/camillehe1992/scaffolding-serverless-project-on-aws.git']])
            }
        }
        stage('Prepare Environemnt') {
          steps {
            script {
              def timestamps = sh(script: "echo `date +%s`", returnStdout: true).trim()
              echo "${timestamps}"
              def tag = "${timestamps}.${env.BUILD_NUMBER}"
              echo "tag: ${tag}"
              writeFile(file: 'tag.txt', text: tag)
            }
          }
        }

        stage('Terraform Format Check & Validate') {
            steps {
                sh 'terraform fmt -check -diff -recursive ./terraform -no-color'
                sh 'terraform validate -no-color'
            }
        }
        
        stage('Terraform Init & Apply') {
            steps {
                sh "./scripts/deploy.sh common_infra ${ENVIRONMENT} ${NICKNAME}"
            }
        }
    }
}