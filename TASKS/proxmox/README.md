# otus-linux-adv
## TASK 11 Deploing a VM in PROXMOX with terraform
The first prerequisite is to prepare your Proxmox server to work with Terraform.
Please make sure you have completed all necessary steps:
1. Install clourd-init
2. Nestet virtualization
3. Configure a required storage type
4. Configure SDN network

After cloning the repository, please modify the variables to your desired values and pay attention to the path of the SSH keys on your Terraform machine:
`TASKS/proxmox/main.tf`
```
    ipconfig0 = "ip=192.168.99.20${count.index + 1}/24,gw=192.168.99.254"
    nameserver = "192.168.99.100"
```
In the `terraform.tfvars` file, use the following local variables with your parameters:
```
pm_api_url = "https://<ip address>:8006/api2/json"
cloudinit_template_name = "VM template name"
proxmox_node = "proxmox node"
ssh_key = "ssh-rsa YOUR SSH PUB KEY"
proxmox_api_token_id="root@pam!apiuser"
proxmox_api_token_secret="your-api-token-secret-here"
proxmox_password="api user password"
```
If you prefer using password instead of api token in `provider.tf` file, please uncomment the section with your parameters or set the variable in `.tfvars`:
```
#pm_password = var.proxmox_password
```

Navigate to the `terraform/` folder and initialize Terraform. After that, execute the following commands to set up the environment with the VM running the NGINX server:
```
terraform init
terraform validate
terraform plan
terraform apply
```

To verify that everything is installed as expected:
```
terraform show -json | jq

```
For example, visit https://192.168.99.131:8006/, and the test web page should be displayed:

