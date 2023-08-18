pipeline {
    agent any
    parameters {
        choice choices: ["dev"], name: "ENVIRONMENT"
        choice choices: ["common_infra", "lambda_layers", "frontend"], name: "COMPONENT"
        booleanParam defaultValue: false, name: "DESTROY"
        booleanParam defaultValue: false, name: "SKIP_APPLY"
    }

    environment {
        NICKNAME = "petstore"
        CREDENTIALS = "756143471679_UserFull"
        AWS_REGION = "cn-north-1"
        ECR_REGISTRY="756143471679.dkr.ecr.cn-north-1.amazonaws.com.cn"
        TF_IMAGE="756143471679.dkr.ecr.cn-north-1.amazonaws.com.cn/terraform:1.3.4"
    }

    stages {
        stage("Prepare Environment") {
            steps {
                script {
                    def timestamps = sh(script: "echo `date +%s`", returnStdout: true).trim()
                    def tag = "${timestamps}.${env.BUILD_NUMBER}"
                    writeFile(file: "tag.txt", text: tag)
                }
                withAWS(credentials: "${env.CREDENTIALS}", region: "${env.AWS_REGION}") {
                    catchError(message: "Failed to authenticate to AWS", stageResult: "FAILURE") {
                        sh """
                            ./scripts/ci/generate_cred.sh ${env.CREDENTIALS}
                            ./scripts/ci/ecr_login.sh ${env.ECR_REGISTRY}
                        """
                    }
                }
            }
        }

        stage("Format & Validate") {
            steps {
                catchError(message: "Failed to format and validate terraform", stageResult: "FAILURE") {
                    sh "./scripts/ci/validate.sh"
                }
            }
        }

        stage("Package") {
            when {
                expression {
                    return "${params.COMPONENT}" == "lambda_layers" && params.DESTROY == false
                }
            }
            steps {
                catchError(message: "Failed to package dependencies", stageResult: "FAILURE") {
                    sh "./scripts/ci/package.sh"
                }
            }
        }

        stage("Init") {
            steps {
                catchError(message: "Failed to init terraform", stageResult: "FAILURE") {
                    sh """
                        mkdir -p ${WORKSPACE}/.terraform.d/plugin-cache
                        rm -f ${WORKSPACE}/terraform/deployment/${params.COMPONENT}/.terraform.lock.hcl
                        ./scripts/ci/init.sh ${params.COMPONENT} ${params.ENVIRONMENT}

                    """
                }
            }
        }

        stage("Plan") {
            when { expression { return params.DESTROY == false } }
            steps {
                catchError(message: "Failed to create a plan", stageResult: "FAILURE") {
                    sh "./scripts/ci/plan.sh ${params.COMPONENT} ${params.ENVIRONMENT}"
                }
            }
        }

        stage("Destroy Plan") {
            when { expression { return params.DESTROY == true } }
            steps {
                catchError(message: "Failed to create a destroy plan", stageResult: "FAILURE") {
                    sh "./scripts/ci/destroy.sh ${params.COMPONENT} ${params.ENVIRONMENT}"
                }
            }
        }

        stage("Apply") {
            when {
                branch "main"
                expression { return params.SKIP_APPLY == false }
            }
            steps {
                catchError(message: "Failed to apply a plan", stageResult: "FAILURE") {
                    sh "./scripts/ci/apply.sh ${params.COMPONENT}"
                }
            }
        }

    }
    post {
        // Clean after build
        always {
            cleanWs(cleanWhenNotBuilt: false,
                    deleteDirs: true,
                    disableDeferredWipeout: true,
                    notFailBuild: true,
                    patterns: [[pattern: ".aws", type: "INCLUDE"]])
        }
    }
}
