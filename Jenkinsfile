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

    PATH                  = "/var/jenkins_home/terraform_temp:${env.PATH}"
  }

  stages {
    stage('Init'){
      steps {
        sh 'terragrunt run-all init --terragrunt-non-interactive'
      }
    }

    stage('Validate'){
      steps {
        sh 'terragrunt run-all validate --terragrunt-non-interactive'
      }
    }

    stage('Format'){
      steps {
        sh 'terragrunt hfclfmt --terragrunt-check --terragrunt-non-interactive'
      }
    }
  }
}
