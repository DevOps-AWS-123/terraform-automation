properties([
    parameters([
        choice(
            choices: ['dev', 'prod'],  // Add both 'dev' and 'prod' as choices
            name: 'Environment',       // This parameter will let the user select the environment
            description: 'Select the environment to deploy (dev or prod)'
        ),
        choice(
            choices: ['init', 'plan', 'apply', 'destroy'], 
            name: 'Terraform_Action',  // The action to perform (init, plan, apply, destroy)
            description: 'Select the Terraform action to perform'
        )
    ])
])

pipeline {
    agent any
    stages {
        stage('Preparing') {
            steps {
                sh 'echo Preparing'
            }
        }

        stage('Git Pulling') {
            steps {
                git branch: 'main', url: 'https://github.com/DevOps-AWS-123/terraform-automation.git'
            }
        }

        stage('Init') {
            when {
                expression { params.Terraform_Action == 'init' }
            }
            steps {
                withAWS(credentials: 'aws-creds', region: 'us-east-1') {
                    sh 'terraform init'
                }
            }
        }

        stage('Validate') {
            when {
                expression { params.Terraform_Action in ['plan', 'apply', 'destroy'] }
            }
            steps {
                withAWS(credentials: 'aws-creds', region: 'us-east-1') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Action') {
            when {
                expression { params.Terraform_Action in ['plan', 'apply', 'destroy'] }
            }
            steps {
                withAWS(credentials: 'aws-creds', region: 'us-east-1') {
                    script {
                        // Dynamically use the selected environment (dev or prod)
                        def envFile = "${params.Environment}.tfvars"
                        echo "Running Terraform Action '${params.Terraform_Action}' on Environment '${params.Environment}' using ${envFile}"

                        if (params.Terraform_Action == 'plan') {
                            sh "terraform plan -var-file=${envFile}"
                        } else if (params.Terraform_Action == 'apply') {
                            sh "terraform apply -var-file=${envFile} -auto-approve"
                        } else if (params.Terraform_Action == 'destroy') {
                            sh "terraform destroy -var-file=${envFile} -auto-approve"
                        } else {
                            error "Invalid Terraform action: ${params.Terraform_Action}"
                        }
                    }
                }
            }
        }
    }
}
