S#!/bin/bash

# Constants
VERSION="v0.1.0"

# Function to display version information
display_version() {
    echo "internsctl $VERSION"
}

# Function to display help information
display_help() {
    echo "Usage: internsctl [OPTIONS] COMMAND [ARGS]..."
    echo "A custom Linux command for various operations."
    echo
    echo "Options:"
    echo "  --help            Show this message and exit."
    echo "  --version         Display the version of internsctl."
    echo
    echo "Commands:"
    echo "  cpu getinfo       Get CPU information."
    echo "  memory getinfo    Get memory information."
    echo "  user create       Create a new user."
    echo "  user list         List all users."
    echo "  user list --sudo-only   List users with sudo permissions."
    echo "  file getinfo      Get information about a file."
}

# Function to handle CPU information retrieval
get_cpu_info() {
    lscpu
}

# Function to handle memory information retrieval
get_memory_info() {
    free
}

# Function to create a new user
create_user() {
    if [ -z "$1" ]; then
        echo "Error: Username not provided."
        exit 1
    fi
    sudo useradd -m "$1"
}

# Function to list users
list_users() {
    if [ "$1" == "--sudo-only" ]; then
        getent passwd | cut -d: -f1,3,4 | awk -F: '$2 >= 1000 && $2 != 65534 {print $1}'
    else
        getent passwd | cut -d: -f1
    fi
}

# Function to get file information
get_file_info() {
    local file="$2"
    case "$1" in
        --size|-s)
            stat --printf="%s\n" "$file"
            ;;
        --permissions|-p)
            stat --printf="%A\n" "$file"
            ;;
        --owner|-o)
            stat --printf="%U\n" "$file"
            ;;
        --last-modified|-m)
            stat --printf="%y\n" "$file"
            ;;
        *)
            echo "Error: Invalid option."
            exit 1
            ;;
    esac
}

# Main script logic
case "$1" in
    --version)
        display_version
        ;;
    --help)
        display_help
        ;;
    cpu)
        shift
        get_cpu_info
        ;;
    memory)
        shift
        get_memory_info
        ;;
    user)
        shift
        case "$1" in
            create)
                create_user "$2"
                ;;
            list)
                list_users "$2"
                ;;
            *)
                echo "Error: Invalid user command."
                exit 1
                ;;
        esac
        ;;
    file)
        shift
        get_file_info "$@"
        ;;
    *)
        echo "Error: Invalid command."
        exit 1
        ;;
esac

