# EBS-Encryption-Project
This project showcases both manual and automated methods for encrypting unencrypted AWS EBS volumes. It uses the AWS Management Console for the manual process and combines Terraform with a Bash script for the automated approach.

________________________________________

## 🛠️ Features
- ✅ **Manual EBS Encryption** using AWS Management Console
- ⚡ **Automated EBS Encryption** using Terraform & Bash
- 🔍 **Checkov Integration** for Terraform security scanning
- 💾 **Snapshot-based encryption** for existing EBS volumes
- 🔒 **Security Best Practices** (IAM, KMS)

________________________________________

## 📁 Project Structure
EBS-Encryption-Project/
│
├── .gitignore                   # Ignore sensitive and system files
├── README.md                    # Project documentation
├── ebs-encryptionhelper.sh       # Bash script for encryption automation
│
├── terraform/                    # Terraform code directory
│   ├── main.tf                   # Main resources configuration
│   ├── output.tf                 # Terraform outputs
│   ├── provider.tf               # AWS provider config
│   ├── terraform.tfvars          # Variables with actual values (no secrets)
│   ├── unencryptedebs_volume.tf  # Unencrypted EBS volume config
│   ├── variables.tf              # Variables definitions
│
├── docs/                         # Documentation & screenshots
│   ├── ebs-encryptionprocess-report.pdf   # Step-by-step project report
│  
└── screenshots/                  # Screenshots for manual process and automated process
    ├── ebs1.png
    └── terraebs1.png
________________________________________

🖥️ Manual Process (AWS Console)
If you want to manually encrypt an existing unencrypted EBS volume:
1. Create a snapshot of the unencrypted volume.
2. Copy the snapshot with encryption enabled.
3. Create a new encrypted volume from the copied snapshot.
4. Detach the unencrypted volume and attach the new encrypted one.

________________________________________

Automating AWS EBS Volume Encryption using Terraform, Bash, and Checkov
Overview
This project automates the process of creating unencrypted AWS EBS volumes and EC2 instances using Terraform, then encrypts the unencrypted volumes using a Bash script, and finally scans the Terraform code for security misconfigurations using the Checkov tool.
________________________________________
Tools Used
Terraform
Terraform is an open-source Infrastructure as Code (IaC) tool that enables users to define and provision infrastructure using a declarative configuration language. It simplifies cloud resource management and supports multi-cloud deployments.
Checkov
Checkov is a static code analysis tool for Infrastructure as Code (IaC). It scans Terraform, CloudFormation, Kubernetes, and other IaC frameworks for misconfigurations and security compliance violations.
________________________________________
Step 1: Automating EBS Creation using Terraform
1.1 AWS Configuration
•	Run the following command to configure AWS credentials: 
•	aws configure
1.2 Write Terraform Code
•	provider.tf → Defines AWS as the provider.
•	main.tf → Contains resources for EC2 instance and unencrypted EBS volumes.
•	unencryptedebs_volume.tf → Defines the unencrypted EBS volume.
•	variables.tf → Manages input variables.
•	output.tf → Outputs key resource information.
•	terraform.tfvars → Holds variable values.
1.3 Execute Terraform Commands
terraform init       # Initialize Terraform
terraform fmt        # Format configuration files
terraform validate   # Validate the code
terraform plan       # Preview the changes
terraform apply      # Apply the infrastructure
1.4 Verify EBS Creation
•	AWS Management Console: 
o	Check EBS volumes, snapshots, and EC2 instances.
o	Connect to the EC2 instance using SSH: 
o	ssh -i EBSvolkeypair.pem ec2-user@<EC2_PUBLIC_IP>
________________________________________
Step 2: Encrypting Unencrypted Volumes Using Bash Script
2.1 Run Bash Script
•	The Bash script ebs-encryptionhelper.sh automates the encryption process.
2.2 Verify Encrypted Volumes
•	AWS Management Console: 
o	Check the updated EBS volume encryption status.
•	AWS CLI: 
•	aws ec2 describe-volumes --query "Volumes[*].{ID:VolumeId,Encrypted:Encrypted}" --region us-east-1
________________________________________
Step 3: Scanning Terraform Code Using Checkov
3.1 Install Checkov
pip install checkov
3.2 Run Checkov Scan
checkov -d /home/kali/EBSVolencryption/
•	Review security findings and address misconfigurations.
________________________________________
Step 4: Clean Up Resources
•	Destroy all resources created by Terraform: 
•	terraform destroy
________________________________________

.gitignore Template
# Terraform
.terraform/
*.tfstate
*.tfstate.backup
terraform.tfvars

# SSH Keys
*.pem

# Logs
*.log

# Misc
*.bak
.DS_Store
________________________________________
✅ Conclusion
This project showcases both the manual process using the AWS Management Console and the automated process using Terraform and a Bash script to encrypt unencrypted AWS EBS volumes. It also highlights the importance of code security by scanning the Terraform code using Checkov.
By following this approach, you ensure that your AWS infrastructure is both secure and compliant with best practices.
________________________________________
💡 Tip: Always scan your IaC code before deploying to avoid misconfigurations that could lead to security breaches.
🔐 Happy Securing!


