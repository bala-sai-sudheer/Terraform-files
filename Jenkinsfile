pipeline{
    agent any
    stages{
        stage("Code"){
            steps{
                git 'https://github.com/bala-sai-sudheer/Terraform-files.git'
            }
        }
        stage("Infra") {
            steps{
              sh 'terraform init'
              sh 'terraform plan'
              sh 'terraform apply --auto-approve'
             --sh 'terraform destroy --auto-approve'
            }
        }
    }
}
