#!/bin/bash

AWS_PROFILE="cloudlab-dev"

login_sso () {
    echo "Starting AWS SSO login with profile: $AWS_PROFILE"
    aws sso login --profile "$AWS_PROFILE"
    
    if [ $? -ne 0 ]; then
        echo "AWS SSO login failed."
        exit 1
    fi

    echo "AWS SSO authentication successful!"
}


plan () {
    login_sso

    export AWS_PROFILE=$AWS_PROFILE
    terraform init
    terraform plan -var-file="dev.tfvars"
}


apply () {
    login_sso

    export AWS_PROFILE=$AWS_PROFILE
    terraform init
    terraform apply -var-file="dev.tfvars" --auto-approve
}


destroy () {
    login_sso

    export AWS_PROFILE=$AWS_PROFILE
    terraform destroy -var-file="dev.tfvars" --auto-approve
}


case $1 in
  "plan")
     plan
       ;;
  "apply")
    apply
      ;;
  "destroy")
     destroy
       ;;
  *)
echo "Error! Select the following options: | plan | apply | destroy Example: ./terraform.sh plan"
exit 1
;;
esac