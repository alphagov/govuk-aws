#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y awscli
sudo apt install -y htop

# Allow SSH access
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCo6AI0U+VFs2dkrwNDMKcU7j5lhSPFDuboQrsGyC1tv8aUBlCSfVDaPRPT20lYANN7tFgQD9mKXaMlUd9bCJJFs7L3CbE+/kSQCE85rfPFDaTMb3/WzYzwMjDD05pRtvdBwmkS6o8IFA4Yyd29qahYhnrO3jexBIZnNdM4nWZCac+nX/8bWckPOGWIR7fTNWoS8C8tioiUDqa/ZflzGqA0NKv7M0I1kwKqHt25FHaqZxnGmnKEC9QIUGbS4cC1cJQ2AO3NqJGPWhb39QrZwvv+Juh9rU3vuohDfx7Xm1Lh8NMVf3+c1vNTcK+DvaGGLZJ20JUBXlRRFFviLo9eaaf5fHIn5bM9aKFwxoPZtlj73FQpv04bUJf/LlbnGgLeW+B6Pl2w2qFp3u5p5NtvPEnLLPm4ljiPsJwl6vdmZy/xLc8/Ze0xyOeMaENm9MFK8BykgBqXqmEsSntvryP2fp1LgwDOt9ufLpF+yLq6hXl/JKYDJZiCTUjpwSbO/GRbsf2PCjzcwLxKIru3QtR9IZmiopeYRbDvH6Zofs/4M4mQVlBv15CKthVSTwwvcb9vOQyRa2uRW6FkY//g04+2yXpU742Cuh0CgNUd1fJ/vO3kCO0Fup/m3M0B7Vsr4NE5/0XdZSXOd5sF9oB4uVh9vE7apD0+hGbeQHzXz5cRNn52KQ== karl.alec.baker@gmail.com" >> /home/ubuntu/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDIDxPsmi5/Vfqai9OhWXgD6fNvJvHjbNw/VVNw7CjDPJWFKvK8ZUQLvYy8nmmdVS/TCuuUtEjcDJinz+dt/feGviHrO8Mo9b516jKa+al4DwMfR7xZ75SS17dsbo+TRw+ZASVEqCQl1hUJ4JKf30740KrbAVHJ5qnPrf8QcE6NEn68J26JpxAmaCbfSgRnz2qc6+uTX+/ROjJ7qXeDsrLBGRtIX/dRqcaqARMP04Gsf3t+WMa8JsM5CQs+oSi7T5UHkGv/dd0WJwWcIVZqiNXK18jW44xFihu/0yzayXCUVlsw2+CMlPBm/MV4rIxbL42eILayMz4Ppk/4ds5iYiyp6kiED7JO2HRlKVcsjcDpg32pQIgw7FQ12jkgwitPrt8rvgWoMwNzo51xVnL4MVhFG423LeZ8Zcs27ruWIdCu9/6kXj5HYN8YCSP4i4cREIcqs12GbpizzCT2R/idBRT2q7I32t6fSVonIq5y1svYP20/JOGzX30VoamVW2LOgziaI1bsrSuST59kM0RDuB44CXtffv4JK74E4aJlUu6tByeGAYxkOzGHaoFM/a3dZrDLx3kF6RrdWSjcAo+FWHOSKK2HweJokwAGYn/I29ZCjfGKmifjt3NmdqbDL3/dbIx7OAcrDBan0K9yeprgGOgXvPiZpGUiBPKiYOqxj/gJIw== cardno:000610162345" >> /home/ubuntu/.ssh/authorized_keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMcNbnQbVVQAse1UUD8OD/HuKQJ2Divi6scGvNKfL4ai" >> /home/ubuntu/.ssh/authorized_keys # Erin
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvuBdxXkJ2Htbt47fm/CV7+uQLOu//OJ7tJv4mlyM0nChhvvI56ZjfYRCdcZNH+eFXzUDUDh1/HK9J8tA2J/ZTg/OqS+UMylQPdc4+LxPHDenhZjvCigf0Uf4ISJdprTCPJj11I/wc7bq1m6C3HGwK5DWAmSIOh7rqLDhuDIZIKdlx3nz8DEAmUFutcA//3sCfHSd8n3B6Rvpzhw5wqqJhG1nS7upJir3lew+XHt+anu6J17iGHTKKuSlZ9ZgXP7poQPizIjIK7sAkI6S45gLcKtJpbMd5pt8Ze80GcH5qoycylz93kUhy8jQJUAR97eDxh7odaFOX0y+Am2EcDJ33PsjDu9QCqJOQu0NiXWLobRIyqtDo08cdDg7yBYgAg5GuPAska/lCG9SFI1gYe7DNRB3LLvBZ4zKwhbiaQ2wdS4K0o4P1OAXdHq2Jp2XcG0jFERdI677v3uUcVEAuQ7GLVHoVKLpdj6+6IbWnh6j5WxVBLaXY2wLMC+dU60M2F1F19ixDEHNb2TUU7f5WIQuJH0N1u+lM3cDjba5cRQuMXDzlaHEwl8XjmHRGC1nwCdTtiNNAbmRe9sX8myXtbnYG0MgUcLkzd0YjVNQXv5jmmvvrRR80Zj2etTQmLQcOKwFkMScQCT9PJenj8RCm+DeCyT+TpRigxmD/6ztr8lHFzw== max.froumentin@digital.cabinet-office.gov.uk" >> /home/ubuntu/.ssh/authorized_keys
# Register instance with load balancer
instance_id="$(curl http://169.254.169.254/latest/meta-data/instance-id)"
aws elb register-instances-with-load-balancer --load-balancer-name ${elb_name} --instances $instance_id --region eu-west-1

sudo locale-gen en_GB.UTF-8

# Upgrade pip
pip install --upgrade pip

# Install pip and dependencies used in this start-up script
sudo apt install -y python-pip
pip install awscli==1.19.112
pip install futures

# Install Python 3.7
sudo add-apt-repository ppa:deadsnakes/ppa -y && sudo apt-get update
sudo apt-get install -y python3.7
sudo apt install -y python3-pip
sudo apt install -y libpq-dev
sudo apt install -y libicu-dev

# Install zip and unzip utilities
sudo apt install -y zip unzip

sudo su - ubuntu

# Create Python 3.7 virtual environment
cd /var
mkdir envs
cd envs
sudo apt install -y virtualenv
virtualenv -p python3.7 python37
source python37/bin/activate
sudo chown -R ubuntu:ubuntu /var/envs/python37

pip install csvkit

# Create data dir
sudo mkdir /var/data
sudo chown -R ubuntu:ubuntu /var/data
sudo chmod g+s /var/data
cd /var/data

# Get Github deploy key and update permissions
/usr/local/bin/aws ssm get-parameter --name govuk_knowledge_graph_github_deploy_key --query "Parameter.Value" --region eu-west-1 --with-decryption | jq -r '.' > kg_id_rsa
chmod 600 kg_id_rsa

# Add Github deploy key to ssh agent
eval `ssh-agent -s`
ssh-add /var/data/kg_id_rsa

# Accept Github SSH fingerprint
ssh -T git@github.com -o StrictHostKeyChecking=no

# Download knowledge graph repo
mkdir /var/data/github
cd /var/data/github
git clone git@github.com:alphagov/govuk-knowledge-graph.git

# Set correct permissions for provisioning script
cd govuk-knowledge-graph
git checkout sandbox
chmod +x ./provision_knowledge_graph_lab

# Run provisioning script
./provision_knowledge_graph_lab -i $instance_id -d ${data_infrastructure_bucket_name} -r ${related_links_bucket_name}
