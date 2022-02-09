pipeline {

  /*
    This is an example Jenkinsfile with a CI/CD pipeline for Terragrunt repository
    The steps in this pipeline include:
    - terragrunt init
    - terragrunt validate
    - terragrunt hclfmt
    - terragrunt plan
    - terragrunt apply (manual)

    In order to this pipeline work properly your Jenkins environment must satisfy the following requirements:
    - Have an Agent labeled with terragrunt having terraform and terragrunt binaries installed
    - OCI Credentials created (All credentials must be 'Secret Text' type, except the private_key_path which has to be 'Secret File')
  */
  agent {
    label 'terragrunt'
  }

  //TODO: Parameters -> Auto-apply? default:No
  parameters {
    boolean(name: 'AutoApply', description: 'Whether to run apply without approval', defaultValue: true)
  }

  environment {
    TF_VAR_tenancy_ocid          = credentials('tenancy_ocid')
    TF_VAR_user_ocid             = credentials('user_ocid')
    TF_VAR_fingerprint           = credentials('fingerprint')
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
          withCredentials([
            file(credentialsId: 'private_key', variable: 'TF_VAR_private_key_path'),
          ]) {
            sh 'terragrunt run-all plan --terragrunt-non-interactive'
          }
        }
      }
    }

    stage('Approve'){
      when {
        // Skip approval if AutoApply parameter has been set to true
        expression {AutoApply != true}
      }
      steps {
        input ("Please, review the plan output. Apply configuration?")
      }
    }

    stage('Apply'){
      steps {
        ansiColor('xterm') {
          withCredentials([
            file(credentialsId: 'private_key', variable: 'TF_VAR_private_key_path'),
          ]) {
            sh 'terragrunt run-all apply --terragrunt-non-interactive'
          }
        }
      }
    }
  }
}
