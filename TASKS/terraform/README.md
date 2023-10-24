# otus-linux-adv
## TASK 1 Deploing a VM in Yandex Cloud with NGINX
The first prerequisite is to prepare your cloud account in Yandex to work with Terraform.
Please make sure you have completed all necessary steps described in the link:
https://cloud.yandex.com/en/docs/tutorials/infrastructure-management/terraform-quickstart

After cloning the repository, please modify the variables to your desired values and pay attention to the path of the SSH keys on your Terraform machine:
`terraform/infra/yandex-tf/input.auto.tfvars`
```
vpc_name = "vpc_name"
subnet_name = "subnet_name"
subnet_cidrs = [ "list", "of", "subnets" ] # e.g. [ "10.10.10.0/24" ]

vm_name = "vm-name"
ssh_pvt = "path_to_the_private_ssh_key" #e.g. "~/.ssh/id_rsa_tf_lab"
```
In the `provider.tf` file, use the following local variables with your parameters:
```
locals {
  cloud_id           = "your_cloud_id"
  folder_id          = "your_folder_id"
  zone               = "ru-central1-a"
}
```
If you prefer using an S3 bucket instead of local storage to keep your `.tfstate` file, please use the `backend "s3"` section with your parameters:
```
  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket   = "your-bucket-name"
    region   = "region-of-the-bucket"
    key      = "path_to_the_file" #e.g. "environments/otus/yandex/terraform.tfstate"
    access_key = "access_key_to_the_bucket"
    secret_key = "secret_key_to_the_bucket"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
```
Unfortunately, Terraform does not support using variables in the backend section (https://github.com/hashicorp/terraform/issues/22088)

Navigate to the `terraform/infra/yandex-tf` folder and initialize Terraform. After that, execute the following commands to set up the environment with the VM running the NGINX server:
```
terraform init
terraform validate
terraform plan
terraform apply
```

Some explanation about using Ansible with Terraform:
The `local-exec` provisioner runs without waiting for the VM to become available, so the execution of the playbook may precede the actual availability of the VM.
To remedy this, you define the `remote-exec` provisioner to contain commands to execute on the target server. For `remote-exec` to execute, the target server must be available.
Since `remote-exec` runs before `local-exec`, the server will be fully initialized by the time Ansible is invoked. python3 comes preinstalled on the VM.
The `local-exec` provisioner in our case execute bash script which is situated in the Scripts folder. The script requires two arguments external IP address of the VM and private key pass.
IP address we get after VM has been installed and we use the variable, ssh key we has been defined in the variables file.

To verify that everything is installed as expected:
```
terraform show -json | jq

```
To get the public IP of the VM:
```
terraform state show 'yandex_compute_instance.instance' | grep nat_ip_address
nat_ip_address     = "158.160.41.70"
```
For example, visit http://158.160.41.70, and the test web page should be displayed:
<img width="657" alt="image" src="https://github.com/SergeyNowitzki/otus-linux-adv/assets/39993377/7826bd3b-cfb3-4bd8-ab67-a9785b932db7">

