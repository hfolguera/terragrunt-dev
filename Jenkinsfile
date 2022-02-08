pipeline {

  /*
    Description #TODO
  */
  agent {
    label 'terragrunt'
  }

  environment {
    TF_VAR_tenancy_ocid          = credentials('tenancy_ocid')
    TF_VAR_user_ocid             = credentials('user_ocid')
    TF_VAR_fingerprint           = credentials('fingerprint')
    TF_VAR_private_key           = credentials('private_key')
    AWS_ACCESS_KEY_ID            = credentials('AWS_ACCESS_KEY_ID')
    AWS_SECRET_ACCESS_KEY        = credentials('AWS_SECRET_ACCESS_KEY')

    PATH             = "/var/jenkins_home/terraform_temp:${env.PATH}"
    TF_IN_AUTOMATION = true
  }

  stages {
    stage('Init'){
      steps {
        sh 'env | grep TF_'
        sh 'env | grep AWS'
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
