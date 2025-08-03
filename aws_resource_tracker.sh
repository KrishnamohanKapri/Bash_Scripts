#!/usr/bin/bash

############################################################
# Author: Krish
# Date: 02/08/2025
#
# Version: v1
#Description: This script will report the AWS resource usage
############################################################

# This script creates a new report file on each run.
OUTPUT_FILE="resourceTracker.txt"

# Clear the file or create it if it doesn't exist, and add a title
echo "AWS Resource Usage Report" > "$OUTPUT_FILE"
echo "=========================" >> "$OUTPUT_FILE"

# Resources we are going to track
# AWS S3
# AWS lambda
# AWS Ec2
# AWS IAM Users

set -x # Uncomment for debug mode

# list s3 buckets
echo "Listing S3 buckets..."
echo -e "\nS3 Buckets:" >> "$OUTPUT_FILE"
aws s3api list-buckets | jq -r '.Buckets[].Name' >> "$OUTPUT_FILE"

# list Ec2 instances
echo "Listing EC2 instances..."
echo -e "\nEC2 Instance IDs:" >> "$OUTPUT_FILE"
aws ec2 describe-instances | jq -r '.Reservations[].Instances[] | "\(.InstanceId) (\(.InstanceType))"' >> "$OUTPUT_FILE"

# list lambda
echo "Listing Lambda functions..."
echo -e "\nLambda Functions:" >> "$OUTPUT_FILE"
aws lambda list-functions | jq -r '.Functions[] | "\(.FunctionName) (\(.FunctionArn))"' >> "$OUTPUT_FILE"

# list IAM  users
echo "Listing IAM users..."
echo -e "\nIAM Users:" >> "$OUTPUT_FILE"
aws iam list-users | jq -r '.Users[] | "\(.UserName) (\(.Arn))"' >> "$OUTPUT_FILE"

echo "Report complete. See $OUTPUT_FILE for details."
