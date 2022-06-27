#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y htop jq zip unzip

#### Install aws cli
# From https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
echo "Installing AWS CLI"
echo "- uninstalling old version"
sudo apt-get remove -y aws # First uninstall the version already installed in this AMI
which -a aws && echo "aws binary found after uninstalling. Something's wrong."
echo "- downloaded new version"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
echo "- installing new version"
sudo ./aws/install
if [ "$(which aws)" == "/usr/local/bin/aws" ]; then
    echo "aws found at /usr/local/bin/aws. All good."
else
    echo "No aws found at /usr/local/bin/aws. Something's wrong."
fi

# Allow SSH access
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1v8UTV0pOjSjZXnvQaWH/m5sOluCQGxeLU8NAbMa20lcazUDhEnQqjQ8SFvfMC06Zu8LWRMMPj3bIdS9I9G7ETWIq4Q8NdHEuOpgBJTcKsiL76hBVyQGWD682xfl4WhAHygsyN6qRGJg8YvkC5sAhYd7nu/9sfI8erc1S7mFt2zzT/4N4ULlI2vHgWGhePPJOfRz7cGi1nxe/WzlYNURVfR0YQfYsxI4vRwjSM0xDelTwKDbb5D1PgcTYx3c2bnrMcQ4FSA7iAyvJJnLSRCcxaCF8XjokR8gBg7Dp9tims0Amjee4J/S1v4ty3Pi8Hm590ZrmuvyVC8KEajCmUnD4JvUAPM7hZYKtLbUsHtR5rF43Ot9gadGV1FF8xEmcMvI0NuqiSuTRV/GPjHxPh+5U5uxrNqODUeTiLHH6m2+Cb55ud5aJJGkbg6nCM2LsWuTN3vbaIwlCxheEdZtp0HLi1XSo6WRiUPKuUpO4a/EX8h9zP+Nd1yeT/9xcyMMFAeieufV3PUjr/7TtG4KpgqzL0C9blWLaYUu9fa7/xT9jJg3yJIFvtidEXtiYvf56tfIr6wWxPkNNYIS5SEarCwI6AoMgMG0geicgzwmPBczovX62IN3lUDskLT0LGo8eliadEeaYCnQ1E3NS2rYwluTdPDYpqIYPH1Vb6MwGajmQBw== kelvin.gan@digital.cabinet-office.gov.uk" >> /home/ubuntu/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvuBdxXkJ2Htbt47fm/CV7+uQLOu//OJ7tJv4mlyM0nChhvvI56ZjfYRCdcZNH+eFXzUDUDh1/HK9J8tA2J/ZTg/OqS+UMylQPdc4+LxPHDenhZjvCigf0Uf4ISJdprTCPJj11I/wc7bq1m6C3HGwK5DWAmSIOh7rqLDhuDIZIKdlx3nz8DEAmUFutcA//3sCfHSd8n3B6Rvpzhw5wqqJhG1nS7upJir3lew+XHt+anu6J17iGHTKKuSlZ9ZgXP7poQPizIjIK7sAkI6S45gLcKtJpbMd5pt8Ze80GcH5qoycylz93kUhy8jQJUAR97eDxh7odaFOX0y+Am2EcDJ33PsjDu9QCqJOQu0NiXWLobRIyqtDo08cdDg7yBYgAg5GuPAska/lCG9SFI1gYe7DNRB3LLvBZ4zKwhbiaQ2wdS4K0o4P1OAXdHq2Jp2XcG0jFERdI677v3uUcVEAuQ7GLVHoVKLpdj6+6IbWnh6j5WxVBLaXY2wLMC+dU60M2F1F19ixDEHNb2TUU7f5WIQuJH0N1u+lM3cDjba5cRQuMXDzlaHEwl8XjmHRGC1nwCdTtiNNAbmRe9sX8myXtbnYG0MgUcLkzd0YjVNQXv5jmmvvrRR80Zj2etTQmLQcOKwFkMScQCT9PJenj8RCm+DeCyT+TpRigxmD/6ztr8lHFzw== max.froumentin@digital.cabinet-office.gov.uk" >> /home/ubuntu/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC77d30YoXpAluaF5hYEPiMQvs7FCa4i2HZoAzKnpKVABYtKioAqrQ5zWg6oB77WBidKU1+0igNIlAzR/zVo9ld8YwDjex78hSql9jsVBdITKuArU7K4WdjcMIhmZwNyNZzMpgQN3PFgETOj2JIF/bGebTmAGHx7W1/nSwWz/BZO665O2cYG1eCr6XCB4Cl9aao77V5INQzSDkP51yBMBPWXXFRcTI7X8nyyim68Fs7VSh8rLHUSqgprvAq+1Lae10Lb050c+J7Gxg8GDjKwWD9WAET6JYcjLYbIpeLSROZfwF6uob8CLF8ojoNTyTJk7vX/o/tIGIWlED6/W0l1WUjnGcuArgd14v6cHekWA9dWWZGVIp+SkiGi2qsu2eO+Q8du92QH1aneKGyJewRWf3f4XB86W/p4DpRmAYnrhlEis3i0rbBxdwNGNHyF4blsPG5iy3b5tcs3y/zlyxcldWpZUeois2Z4SLTEY3YXts96JyHI0Gd0Efn0ekuNSm/1KR5zUrakgSDixayP9g4HH5kxsOiq1Q3E1Pc7ouinjcv88/ogzUw5XDjfWB62sEW9Zw7Ec7cTHLY8IK7Wrd1Wkaj0Gyuq7d+LTEcT5SwzYIls/z8CxwDfEKGm3G6EjNFTttbrVDaEGeEDAgeEYlt3gOEQvIvlj6etoG9xLwVgpvAgQ== duncan.garmonsway@digital.cabinet-office.gov.uk" >> /home/ubuntu/.ssh/authorized_keys

# Register instance with load balancer
instance_id="$(curl http://169.254.169.254/latest/meta-data/instance-id)"
aws elb register-instances-with-load-balancer --load-balancer-name "${elb_name}" --instances $instance_id --region eu-west-1

sudo locale-gen en_GB.UTF-8

# Create data dir
sudo mkdir /var/data
sudo chown -R ubuntu:ubuntu /var/data
sudo chmod g+s /var/data
cd /var/data


################################################################################
# Get Knowledge graph repository to launch the data pipeline


# This is a private repo so we need a github ssh key for cloning
aws ssm get-parameter --name govuk_knowledge_graph_github_deploy_key --query "Parameter.Value" --region eu-west-1 --with-decryption | jq -r '.' > kg_id_rsa
chmod 600 kg_id_rsa

# Add Github deploy key to ssh agent
eval "$(ssh-agent -s)"
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
chmod +x ./provision_knowledge_graph_dev

# Run provisioning script
./provision_knowledge_graph_lab -i $${instance_id} -d ${data_infrastructure_bucket_name} -r ${related_links_bucket_name} 2>&1
