#!/bin/bash

# Clear the screen
clear

# Check if xclip is installed
if ! command -v xclip &> /dev/null; then
    echo "xclip could not be found. Attempting to install..."
    sudo apt-get install xclip -y
fi

# Display the app name in color
echo -e "\e[1;34m============================"
echo -e "\e[1;32mWelcome to Clippy!"
echo -e "\e[1;34m============================\e[0m"

# If a script name is passed as a command line argument, use it
# Otherwise, prompt the user for a script name
if [ -z "$1" ]; then
    echo -e "\e[1;33mPlease enter the script name:\e[0m"
    read script_name
else
    script_name="$1"
fi

# Get the clipboard content
clipboard_content=`xclip -selection clipboard -o`

# Check the first line of the clipboard content for a shebang to determine the file type
if [[ "$clipboard_content" == '#!'*python* ]]; then
    file_extension=".py"
elif [[ "$clipboard_content" == '#!'*bash* ]] || [[ "$clipboard_content" == '#!'*sh* ]]; then
    file_extension=".sh"
else
    echo -e "\e[1;33m" "Could not determine the file type from the clipboard content. Please enter the file type (.py or .sh):" "\e[0m"
    read file_extension
fi

# Define the base directory
base_directory="/home/pi/bin"

# Check if the directory exists
if [ ! -d "$base_directory/$script_name" ]; then
    # If the directory does not exist, create it
    mkdir "$base_directory/$script_name"
fi

# Navigate to the directory
cd "$base_directory/$script_name"

# Create a new file and fill it with the clipboard content
echo "$clipboard_content" > "$script_name$file_extension"

# If the file is a Python script, make it executable
if [ "$file_extension" == ".py" ]; then
    chmod +x "$script_name$file_extension"
fi

# Report success in color
echo -e "\e[1;32mSuccessfully created and set up the script $script_name$file_extension in the directory $base_directory/$script_name/\e[0m"
