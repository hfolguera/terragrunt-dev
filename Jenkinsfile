pipeline {

  /*
    Description #TODO
  */
  agent {
    label 'terragrunt'
  }

  //TODO: Parameters -> Auto-apply? default:No

  environment {
    TF_VAR_tenancy_ocid          = credentials('tenancy_ocid')
    TF_VAR_user_ocid             = credentials('user_ocid')
    TF_VAR_fingerprint           = credentials('fingerprint')
    private_key                  = credentials('private_key')
    AWS_ACCESS_KEY_ID            = credentials('AWS_ACCESS_KEY_ID')
    AWS_SECRET_ACCESS_KEY        = credentials('AWS_SECRET_ACCESS_KEY')

    PATH             = "/var/jenkins_home/terraform_temp:${env.PATH}" // Add terraform and terragrunt to PATH
    TF_IN_AUTOMATION = true
  }

  stages {
    stage('Init'){
      steps {
        ansiColor('xterm') {
          sh 'terragrunt run-all init --terragrunt-non-interactive'
        }
      }
    }

    stage('Validate'){
      steps {
        ansiColor('xterm') {
          sh 'terragrunt run-all validate --terragrunt-non-interactive'
        }
      }
    }

    stage('Format'){
      steps {
        ansiColor('xterm') {
          sh 'terragrunt hclfmt --terragrunt-check --terragrunt-non-interactive'
        }
      }
    }

    stage('Plan'){
      steps {
        ansiColor('xterm') {
          sh 'echo $private_key > id_rsa.pem'
          sh 'TF_VAR_private_key_path=./id_rsa.pem terragrunt run-all plan --terragrunt-non-interactive'
        }
      }
    }

    stage('Apply'){
      steps {
        input ("Please, review the plan output. Apply configuration?")
        ansiColor('xterm') {
          sh 'terragrunt run-all apply --terragrunt-non-interactive'
        }
      }
    }
  }
}
