# otus-linux-adv
## TASK 11 Deploying a VM in Proxmox with Terraform

### Prerequisites
Before getting started with deploying a VM in Proxmox using Terraform, ensure that you have completed the following prerequisites:

1. **Install cloud-init:** Ensure that cloud-init is installed on your Proxmox server. This is essential for cloud-init support in your VMs.

2. **Nested Virtualization:** Make sure that your Proxmox server has nested virtualization enabled. This is required for running virtual machines inside virtual machines.

3. **Configure Required Storage:** Set up the necessary storage types and ensure they are configured correctly for your VMs.

4. **Configure SDN Network:** Configure Software Defined Networking (SDN) on your Proxmox server if required for your setup.

### Getting Started
1. Clone this repository to your local machine.

2. Modify the variables in the Terraform configuration to match your desired values. Pay special attention to the SSH key path on your Terraform machine. You can do this in the `TASKS/proxmox/main.tf` file:

```hcl
ipconfig0 = "ip=192.168.99.20${count.index + 1}/24,gw=192.168.99.254"
nameserver = "192.168.99.100"
```
In the terraform.tfvars file, use the following local variables and set them to your parameters:
```
pm_api_url = "https://<ip address>:8006/api2/json"
cloudinit_template_name = "VM template name"
proxmox_node = "proxmox node"
ssh_key = "ssh-rsa YOUR SSH PUB KEY"
proxmox_api_token_id="root@pam!apiuser"
proxmox_api_token_secret="your-api-token-secret-here"
proxmox_password="api user password"
```
If you prefer using a password instead of an API token in the provider.tf file, uncomment the section with your parameters or set the variable in .tfvars:
```
#pm_password = var.proxmox_password
```

Deployment
Navigate to the `terraform/` folder and initialize Terraform. After that, execute the following commands to set up the environment with the VM running the NGINX server:
```
terraform init
terraform validate
terraform plan
terraform apply
```

Verification
To verify that everything is installed as expected:
```
terraform show -json | jq
```
For example, visit https://192.168.99.131:8006/, and the test web page should be displayed:
<img width="1237" alt="image" src="https://github.com/SergeyNowitzki/otus-linux-adv/assets/39993377/8021ea53-9aaa-44c4-bd31-a792be3af991">

