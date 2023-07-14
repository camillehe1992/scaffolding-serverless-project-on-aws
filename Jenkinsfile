pipeline {
    agent any

    environment {
        ENVIRONMENT = "dev"
        NICKNAME = "posts"
    }

    stages {
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
                sh 'terraform fmt -check -diff -recursive ./terraform'
                sh 'terraform validate'
            }
        }
        
        stage('Terraform Init & Apply') {
            steps {
                sh "./scripts/deploy.sh common_infra ${ENVIRONMENT} ${NICKNAME}"
            }
        }
    }
}