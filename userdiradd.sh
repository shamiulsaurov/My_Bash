#!/bin/bash

# Function to create a user
create_user() {
    local username=$1
    local password=$2
    echo "Creating user $username..."
    sudo useradd -m -s /bin/bash "$username"
    echo "$username:$password" | sudo chpasswd
    echo "User $username created and password set."

    # Create directories in the user's home directory
    local directories=("${@:3}")
    for dir in "${directories[@]}"; do
        local dir_path="/home/$username/$dir"
        if [ ! -d "$dir_path" ]; then
            mkdir "$dir_path"
            chmod 755 "$dir_path"
            chown "$username:$username" "$dir_path"
            echo "Directory $dir_path created with permissions set."
        else
            echo "Directory $dir_path already exists."
        fi
    done
}

# Function to get OS information
get_os_info() {
    echo "Select your OS:"
    echo "1. Ubuntu"
    echo "2. CentOS"
    echo "3. Red Hat"
    read -p "Enter the OS number: " os_choice

    case $os_choice in
        1) os_name="Ubuntu" ;;
        2) os_name="CentOS" ;;
        3) os_name="Red Hat" ;;
        *) echo "Invalid option selected."; exit 1 ;;
    esac

    read -p "Enter the version of $os_name: " os_version
}

# Main function
main() {
    get_os_info

    # Get usernames and directories from the user
    read -p "Enter usernames (comma separated): " usernames_input
    IFS=',' read -r -a usernames <<< "$usernames_input"
    usernames=("${usernames[@]/#/}")

    read -p "Enter directory names (comma separated) to create in each user's home directory: " directories_input
    IFS=',' read -r -a directories <<< "$directories_input"
    directories=("${directories[@]/#/}")

    for username in "${usernames[@]}"; do
        create_user "$username" "$username" "${directories[@]}"
    done
}

# Execute main function
main
