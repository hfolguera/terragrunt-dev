pipeline {

  /*
    Description #TODO
  */
  agent {
    label 'terragrunt'
  }

  environment {
    tenancy_ocid          = credentials('tenancy_ocid')
    user_ocid             = credentials('user_ocid')
    fingerprint           = credentials('fingerprint')
    private_key           = credentials('private_key')
    AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
    AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
  }

  stages {
    stage('Init'){
      steps {
        sh '/var/jenkins_home/terraform_temp/terragrunt run-all init --terragrunt-non-interactive'
      }
    }

    stage('Validate'){
      steps {
        sh '/var/jenkins_home/terraform_temp/terragrunt run-all validate --terragrunt-non-interactive'
      }
    }

    stage('Format'){
      steps {
        sh '/var/jenkins_home/terraform_temp/terragrunt hfclfmt --terragrunt-check --terragrunt-non-interactive'
      }
    }
  }
}
