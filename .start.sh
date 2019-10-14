#!/bin/bash

export PATH=$PATH:/root/go/bin

mkdir -p ~/.aws/
echo "[default]" >> ~/.aws/credentials
echo "aws_access_key_id = $S3_BUCKET_KEY" >> ~/.aws/credentials
echo "aws_secret_access_key = $S3_BUCKET_SECRET" >> ~/.aws/credentials

current_time=$(date "+%Y.%m.%d.%H.%M.%S")

aws s3 cp s3://$S3_BUCKET_NAME/tmp/$DOMAINS_FILE /tmp/scanme

cat /tmp/scanme | aquatone -out /tmp/output -ports xlarge -resolution "640,480" -scan-timeout 500

mkdir -p /tmp/$TLD/$current_time

mv -v /tmp/output/* /tmp/$TLD/

aws s3 mv /tmp/$TLD/ s3://$S3_BUCKET_NAME/reports/$TLD/$current_time/ --recursive
