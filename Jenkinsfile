pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
    }

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
                checkout scm
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