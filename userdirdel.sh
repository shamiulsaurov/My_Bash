#!/bin/bash

# Function to list users with home directories
list_home_users() {
    echo "Listing users with home directories:"
    for dir in /home/*; do
        if [ -d "$dir" ]; then
            local user=$(basename "$dir")
            if id "$user" &>/dev/null; then
                echo "$user"
            fi
        fi
    done
}

# Function to delete a user
delete_user() {
    local username=$1
    read -p "Are you sure you want to delete user $username and their home directory? (yes/no): " confirm
    if [[ $confirm == "yes" ]]; then
        sudo deluser --remove-home "$username"
        echo "User $username and their home directory have been deleted."
    else
        echo "Deletion of user $username was cancelled."
    fi
}

# Main function
main() {
    list_home_users

    # Get usernames to delete from user input
    read -p "Enter usernames (comma separated) to delete: " delete_usernames_input
    IFS=',' read -r -a delete_usernames <<< "$delete_usernames_input"
    delete_usernames=("${delete_usernames[@]/#/}")

    for username in "${delete_usernames[@]}"; do
        if id "$username" &>/dev/null; then
            delete_user "$username"
        else
            echo "User $username does not exist or does not have a home directory."
        fi
    done
}

# Execute main function
main
