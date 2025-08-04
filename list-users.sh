#!/usr/bin/bash

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username
TOKEN=$token

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# Validate that the required variables and arguments are provided
if [ -z "$USERNAME" ] || [ -z "$TOKEN" ]; then
    echo "Error: The environment variables USERNAME and TOKEN must be set."
    exit 1
fi

if [ -z "$REPO_OWNER" ] || [ -z "$REPO_NAME" ]; then
    echo "Error: Repository owner and repository name must be provided as arguments."
    echo "Usage: $0 <repo_owner> <repo_name>"
    exit 1
fi


# Function to make a GET request to the GitHub API
function get_github_data() {
    local endpoint=$1
    local url="$API_URL/$endpoint"

    curl -s -u "$USERNAME:$TOKEN" "$url"
}

# Function to list users with read access to a repository
function list_users_with_read_access() {
    local endpoint="repos/$REPO_OWNER/$REPO_NAME/collaborators"

    # Fetch the list of collaborators
    collaborators="$(get_github_data "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the list of collaborators with read access
    if [ -z "$collaborators" ]; then
        echo "No users with read access found for repository $REPO_OWNER/$REPO_NAME."
    else
        echo "Users with read access to $REPO_OWNER/$REPO_NAME:"
        echo "$collaborators"
    fi
}

# Main script execution

echo "Listing users with read access to repository $REPO_OWNER/$REPO_NAME..."
list_users_with_read_access
echo "Done."