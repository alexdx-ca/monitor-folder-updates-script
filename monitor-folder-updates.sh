#!/bin/zsh

# Script: monitor_folder_update.sh
# Description: This script monitors changes in a specified directory and synchronizes them using rclone.
# Author: Alex Derkach
# Website: alexdx.ca
# Version: 1.03
# Date: 2024-02-03

echo "_____________________________________"
echo "| __         ***********            |"   
echo "| | \   ******* v1.03 *******   /\  |"
echo "| |_/ *****              ***** /__\ |"
echo "|   ** ______________________ **    |"
echo "|  **  |         ___        |  **   |"
echo "| **   |    /\   |  \ \   / |   **  |" 
echo "| **   |   /  \  |   \ \ /  |   **  |"
echo "| **   |  /----\ |   / / \  |   **  |"
echo "|  **  | /      \|__/ /   \ |  **   |"
echo "|   ** |____________________| **    |"
echo "|     *****               ***** __  |"
echo "|  /\   ****   Monitor  *****   | \ |"
echo "| /__\  Folder Updates Script   |_/ |"      
echo "|___________________________________|"

source_path="$(dirname "$(readlink -f "$0")")"
destination_path="server:"
rclone_ignore="${source_path}/.rcloneignore"
fswatch_ignore="${source_path}/.fswatchignore"

# Function to perform initial sync
sync_files() {
    rclone sync "${source_path}" "${destination_path}" --size-only --progress --exclude-from "${rclone_ignore}" --delete-excluded
}

# Function to sync an updated file
sync_changed_files() {
    rclone copy "${source_path}" "${destination_path}" --max-age 1m --no-traverse --progress --exclude-from "${rclone_ignore}"
}

# Sync folders before watching for updates
echo "[ $(date +"%Y-%m-%d %H:%M:%S") ] Plugin auto-update started"
echo "[ $(date +"%Y-%m-%d %H:%M:%S") ] Initial sync"
sync_files

# Monitor changes using fswatch
fswatch --event Created --event Updated --event Removed --event Renamed --recursive --latency 1 --filter-from="${fswatch_ignore}" "${source_path}" | while IFS= read -r event; do
    echo "[ $(date +"%Y-%m-%d %H:%M:%S") ] Changes detected: ${event}"

    changed_file=$(echo "${event}")
    
    # Check if the file or directory exists
    if [ ! -e "${changed_file}" ]; then
        echo "[ $(date +"%Y-%m-%d %H:%M:%S") ] Syncing file removals and/or renames"
        sync_files
    else
        echo "[ $(date +"%Y-%m-%d %H:%M:%S") ] Syncing updated file: ${changed_file}"
        sync_changed_files
    fi
done