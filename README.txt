Just a simple project for learning Terraform and Ansible

Scripts are able to spin up a customizable set of EC2 instances on aws
then output an inventory file for ansible and use an ansible-playbook
to install and initialize an apache webserver on each instance dynamically
handling requirements for different linux distros.
