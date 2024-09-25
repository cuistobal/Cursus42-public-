#!/bin/bash

#This script is meant to run you pushswap with X sets of Y numbers. it logs everything in a log/ file that doesnt need to be created. It then compares the amount of commands
#executed by your push_swap and compares thems to the Z number of command you state as benchmark.
#
#You need to have your pushswap executable in the folder as this script for it to work. You can add a "make install" rule to your makefile so it send a copy of the executable
#each time you make.
#
#Remember that you need to execute the script with 3 arguments.
#ex: ./run_push_swap 100 500 5500
#In this exemple, the script will generate 100 sets of 500 numbers and check if they get sorted in less than 5500 command.
#
#I'm currently working on an improve meta script that would also check if you meet other criteria for evaluation.
#
#By the way, this script was generated with ChatGPT (:


# Check if three arguments have been provided
if [ "$#" -ne 3 ] || ! [[ "$1" =~ ^[0-9]+$ ]] || ! [[ "$2" =~ ^[0-9]+$ ]] || ! [[ "$3" =~ ^[0-9]+$ ]] || [ "$1" -lt 1 ] || [ "$1" -gt 9999 ] || [ "$2" -lt 1 ] || [ "$2" -gt 500 ] || [ "$3" -lt 1 ]; then
    echo "Usage: $0 <Y (1-9999)> <X (1-500)> <max_instructions>"
    exit 1
fi


Y=$1  # Number of executions
X=$2  # Number of unique numbers to generate
max_instructions=$3  # Maximum number of instructions

# Create the main log folder if it doesn't exist
mkdir -p log

# Find the next folder number to create
next_num="0000"
while [ -d "log/log$next_num" ]; do
    next_num=$(printf "%04d" $((10#$next_num + 1)))  # Increment the number
done

# Create the log folder for this execution
log_folder="log/log$next_num"
mkdir -p "$log_folder"  # Create the folder for this execution

# Recap file
recap_file="$log_folder/recap.txt"
> "$recap_file"  # Clear the file if it already exists

# Add the first line to the recap file
echo "RECAP ($next_num):" > "$recap_file"

# Initialize counters
ok_count=0
ko_count=0

# Execute the process Y times
for (( i=0; i<Y; i++ )); do
    # Find the next log number within the created folder
    log_num="0000"

    while [ -f "$log_folder/log$log_num" ]; do
        log_num=$(printf "%04d" $((10#$log_num + 1)))  # Increment the number
    done

    # Create the log file name
    log_file="$log_folder/log$log_num"

    # Generate X unique numbers between -500 and 500
    numbers=()

    # Fill the array with unique numbers
    while [ ${#numbers[@]} -lt "$X" ]; do
        num=$(( RANDOM % 1001 - 500 ))  # Generate a number between -500 and 500
        if [[ ! " ${numbers[@]} " =~ " ${num} " ]]; then
            numbers+=("$num")  # Add the number to the array if it's not already present
        fi
    done

    # Execute the push_swap program with the generated numbers and redirect the output
    {
        echo -e "Arguments:\n"  # New line after "Arguments:"
        echo "${numbers[*]}"    # Display the generated numbers
        echo -e "\n"            # Add a new line
        ./push_swap "${numbers[@]}"  # Execute push_swap with the numbers
    } > "$log_file" 2>&1

    # Count the number of lines in the log for movements
    movement_count=$(wc -l < "$log_file")
    # Count the number of generated numbers
    arg_count=$X

    # Determine the instruction status (OK or KO)
    if [ "$movement_count" -le "$max_instructions" ]; then
        status="[OK]"
        color_code="\e[32m"  # Green
        ((ok_count++))  # Increment the OK counter
    else
        status="[KO]"
        color_code="\e[31m"  # Red
        ((ko_count++))  # Increment the KO counter
    fi

    # Create a new log file with the requested formatting
    {
        # Add the file name in UPPERCASE and a new line
        echo "$(basename "$log_file" | tr '[:lower:]' '[:upper:]')"  # File name in UPPERCASE
        echo -e "\n"  # First new line
        echo "Number of arguments: ($arg_count)"  # Display the number of arguments
        echo "Number of instructions: ($movement_count)"  # Display the number of instructions
        echo -e "${color_code}${status}\e[0m"  # Display the status with color on a new line
        echo -e "\n"  # Add a new line
        echo "Arguments:"  # Display "Arguments:"
        echo "${numbers[*]}"  # Display the generated arguments
        echo -e "\n"  # Add a new line
        echo "Movements: ($movement_count)"  # Add the number of movements
        tail -n +4 "$log_file"  # Add the movements from the output of push_swap
    } > "$log_file.tmp"  # Create a temporary file to avoid overwriting the original log file

    mv "$log_file.tmp" "$log_file"  # Rename the temporary file

    # Add details to the recap file
    {
        if [ $i -ne 0 ]; then
            echo ""  # New line for each entry except the first
        fi
        echo "$(basename "$log_file")"  # Log file name
        echo "Number of arguments: ($arg_count)"  # Number of arguments
        echo "Number of instructions: ($movement_count) ${status}"  # Number of movements
    } >> "$recap_file"  # Append to the recap file

    echo "Results have been saved in $log_file"
done

# Add OK and KO counters to the recap file
{
    echo ""  # New line before the statistics
    echo "[OK]: ($ok_count)/($Y)"
    echo "[KO]: ($ko_count)/($Y)"
} >> "$recap_file"  # Append to the recap file

# Add the counters directly after the first line in the recap file
sed -i "2i [OK]: ($ok_count)/($Y)" "$recap_file"
sed -i "3i [KO]: ($ko_count)/($Y)" "$recap_file"

# Display only the first three lines of the recap.txt file in the terminal
echo "The recap has been saved in $recap_file"
head -n 3 "$recap_file"
