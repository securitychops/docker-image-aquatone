#!/bin/bash

mkdir -p ~/.aws/
echo "[default]" >> ~/.aws/credentials
echo "aws_access_key_id = $S3_BUCKET_KEY" >> ~/.aws/credentials
echo "aws_secret_access_key = $S3_BUCKET_SECRET" >> ~/.aws/credentials

UUID=$(cat /proc/sys/kernel/random/uuid)

current_time=$(date "+%Y.%m.%d.%H.%M.%S")

aws s3 cp s3://$S3_BUCKET_NAME/tmp/$DOMAINS_FILE /tmp/scanme

aws s3 cp s3://$S3_BUCKET_NAME/exclude-url-patterns.txt /tmp/exclude-url-patterns.txt

grep -v -f /tmp/exclude-url-patterns.txt /tmp/scanme | ./aquatone -out /tmp/output -ports $PORT_SIZE -resolution "640,480" -save-body -scan-timeout 500

mkdir -p /tmp/$TLD

mv -v /tmp/output/* /tmp/$TLD/

aws s3 mv /tmp/$TLD/ s3://$S3_BUCKET_NAME/reports/$TLD/$current_time/ --recursive

echo "$TLD/$current_time" > /tmp/$UUID
aws s3 mv /tmp/$UUID s3://$S3_BUCKET_NAME/tmp/$UUID

echo '{"task_type":"eyeballer","screenshots_file":"'$UUID'"}' > /tmp/$UUID
aws s3 mv /tmp/$UUID s3://$S3_BUCKET_NAME/tasks/
