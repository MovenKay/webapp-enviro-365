****Project to build and deploy  WebApplication on an EC2 Instance ****
Install docker and AWS CLI on the EC2 instance (Server 1)
Install NGINX Load balancer on the EC2 instance (Server 2)


Step 1
Clone the chat to the EC2 instance server 1
Run git https://github.com/Enviro-365/enviro-chat-app

Change the directory to enviro-chat-app.
Run **sudo docker build -t envirochat:1.0 .** command to build the docker image
Run  **docker run -p 3000:3000 envirochat:1.0** to make the application listen on port 3000

Test the application by accessing the loadbalancer url **http://enviro-365-ap-lb-2087359636.eu-west-1.elb.amazonaws.com:3000/**

Infrastructure provisioning -Terraform
Configuration Management -Ansible
Altenatively , you can create all the infrastructure using Terraform using the code in the folder named Terraform
You can push the configuration to the EC2 instances by using Ansible. The configurations are contained in the foldder named Ansible.

Username for console access : enviro365console
Password : enviro@365
Sign in url : https://movendevops.signin.aws.amazon.com/console
