#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y awscli
sudo apt install -y htop

# Register instance with load balancer
instance_id="$(curl http://169.254.169.254/latest/meta-data/instance-id)"
aws elb register-instances-with-load-balancer --load-balancer-name ${elb_name} --instances $instance_id --region eu-west-1

sudo locale-gen en_GB.UTF-8

# Allow SSH access
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCo6AI0U+VFs2dkrwNDMKcU7j5lhSPFDuboQrsGyC1tv8aUBlCSfVDaPRPT20lYANN7tFgQD9mKXaMlUd9bCJJFs7L3CbE+/kSQCE85rfPFDaTMb3/WzYzwMjDD05pRtvdBwmkS6o8IFA4Yyd29qahYhnrO3jexBIZnNdM4nWZCac+nX/8bWckPOGWIR7fTNWoS8C8tioiUDqa/ZflzGqA0NKv7M0I1kwKqHt25FHaqZxnGmnKEC9QIUGbS4cC1cJQ2AO3NqJGPWhb39QrZwvv+Juh9rU3vuohDfx7Xm1Lh8NMVf3+c1vNTcK+DvaGGLZJ20JUBXlRRFFviLo9eaaf5fHIn5bM9aKFwxoPZtlj73FQpv04bUJf/LlbnGgLeW+B6Pl2w2qFp3u5p5NtvPEnLLPm4ljiPsJwl6vdmZy/xLc8/Ze0xyOeMaENm9MFK8BykgBqXqmEsSntvryP2fp1LgwDOt9ufLpF+yLq6hXl/JKYDJZiCTUjpwSbO/GRbsf2PCjzcwLxKIru3QtR9IZmiopeYRbDvH6Zofs/4M4mQVlBv15CKthVSTwwvcb9vOQyRa2uRW6FkY//g04+2yXpU742Cuh0CgNUd1fJ/vO3kCO0Fup/m3M0B7Vsr4NE5/0XdZSXOd5sF9oB4uVh9vE7apD0+hGbeQHzXz5cRNn52KQ== karl.alec.baker@gmail.com" >> /home/ubuntu/.ssh/authorized_keys

# Install pip and dependencies used in this start-up script
sudo apt install -y python-pip
pip install awscli
pip install csvkit

# Install Python 3.6
sudo add-apt-repository ppa:deadsnakes/ppa -y && sudo apt-get update
sudo apt-get install -y python3.6
sudo apt install -y python3-pip

sudo su - ubuntu

# Create Python 3.6 virtual environment
cd /var
mkdir envs
cd envs
sudo apt install -y virtualenv
virtualenv -p python3.6 python36
source python36/bin/activate

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
cd govuk-knowledge-graph

export DATA_DIR=$PWD/data
export CONFIG=$PWD/config

cd /var/data/github/govuk-knowledge-graph

# Install dependencies
pip install -r requirements.txt
pip install tqdm==4.32.2
pip install pymongo==3.8.0
pip install lxml==4.3.4

# Install Mongo
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list

sudo apt-get update -y
sudo apt-get install -y mongodb-org
sudo service mongod start

echo "Finding latest content backup..."
LATEST_CONTENT_BACKUP_PATH=$(aws s3api list-objects-v2 --bucket ${database_backups_bucket_name} --prefix mongo-api --query "Contents[?contains(Key, '-content_store_production.gz')]" | jq  -c "max_by(.LastModified)|.Key" | xargs)

echo "Downloading latest content store backup..."
aws s3 cp s3://${database_backups_bucket_name}/$LATEST_CONTENT_BACKUP_PATH /var/data/latest_content_store_backup.gz

# Extract content store backup
cd /var/data
tar -xvf latest_content_store_backup.gz
ls -lat content_store_production

# Restore content store data to MongoDb
mongorestore -d content_store -c content_items /var/data/content_store_production/content_items.bson

# Build the graph data
cd /var/data/github/govuk-knowledge-graph
python3.6 src/build_graph_data.py

# Stop Neo4j to begin import process
sudo service neo4j stop

# Get graph data directory
cd data
graph_data_dir=$(find -name 'graph_data*' -printf '%f\n')

# Update Neo4j configuration to un-sandbox plugins
echo "dbms.security.procedures.unrestricted=algo.*,apoc.*" | sudo tee -a /etc/neo4j/neo4j.template

# Start Neo4j (it takes some time to start-up, so start now before we need to use cypher-shell)
sudo service neo4j start

related_links_file=$(aws s3api list-objects-v2 --bucket ${related_links_bucket_name} --query "Contents[?contains(Key, '_related_links.json')]" | jq  -c "max_by(.LastModified)|.Key" | xargs)
aws s3 cp s3://${related_links_bucket_name}/$related_links_file $graph_data_dir/cid_has_suggested_ordered_related_items_cid.csv
csvformat -T $graph_data_dir/cid_has_suggested_ordered_related_items_cid.csv > $graph_data_dir/cid_has_suggested_ordered_related_items_cid.tsv

# Copy all the graph data to Neo4j's import directory
cp -R $graph_data_dir/. /var/lib/neo4j/import

# Download additional non-content store data from S3
aws s3 cp s3://${related_links_bucket_name}/functional_edges.csv /var/lib/neo4j/import/functional_edges.csv
aws s3 cp s3://${related_links_bucket_name}/structural_edges.csv /var/lib/neo4j/import/structural_edges.csv
aws s3 cp s3://${related_links_bucket_name}/cid_has_similar_content_cid_edgelist.csv /var/lib/neo4j/import/cid_has_similar_content_cid_edgelist.csv
aws s3 cp s3://${related_links_bucket_name}/people_nodelist.csv /var/lib/neo4j/import/people_nodelist.csv
aws s3 cp s3://${related_links_bucket_name}/people_to_roles_edgelist.csv /var/lib/neo4j/import/people_to_roles_edgelist.csv
aws s3 cp s3://${related_links_bucket_name}/roles_nodelist.csv /var/lib/neo4j/import/roles_nodelist.csv
aws s3 cp s3://${related_links_bucket_name}/roles_to_orgs_edgelist.csv /var/lib/neo4j/import/roles_to_orgs_edgelist.csv

# Get current Neo4j credentials and base64 encode
credentials="neo4j:$instance_id"
encoded_credentials=$(echo -n $credentials | base64)

# Update Neo4j credentials with the password from SSM
new_password=$(/usr/local/bin/aws ssm get-parameter --name govuk_knowledge_graph_shared_password --query "Parameter.Value" --region eu-west-1 --with-decryption | jq -r '.')
curl -X POST -H "Accept: application/json" \
  -H "Authorization: Basic $encoded_credentials" \
  -H "Content-Type: application/json; charset=UTF-8" \
  -d '{"password": "'$new_password'"}' \
  http://localhost:7474/user/neo4j/password

# Build graph in Neo4j
cat /var/data/github/govuk-knowledge-graph/src/neo4j/import_edgelist.cypher | cypher-shell -u neo4j -p $new_password
