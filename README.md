# Usage instructions

## task 1 terraform
I am confused about step 3, which involves Route 53. To my understanding, we can't directly point a NAT gateway to an EC2 instance, as NAT gateways are only used for outgoing connections. I have sent an email regarding this but have not received a response. for the first two stages,

* Add default variable to each field in `variable.tf` file
* Provide IAM credentials to either to the machine or set it in `provider` block
* run `terraform plan` and verify the changes
* run `terraform apply` to apply the infrastructure configurations


## task 2 kubernetes
Ensure that a valid config file is present and place it either in your ~/.kube/ directory, set it with the KUBECONFIG environment variable, or use the path as a value for the --kubeconfig flag with all the given commands.