#!/bin/bash

DATA_FILE="./journal_data.csv"

initialize_data_file() {
    touch "${DATA_FILE}"
    echo "id,title,date,content" > "${DATA_FILE}"
}

create_entry() {
    clear
    echo "---------------------"
    echo "Create New Entry"
    echo "---------------------"

    echo "Enter title for the new entry: "
    read title

    echo "Enter content for the new entry (press Ctrl+D when done): "
    content=$(cat)

    entry_id=$(date +"%Y%m%d%H%M%S")
    entry_date=$(date +"%Y-%m-%d %H:%M:%S")

    echo "${entry_id},${title},${entry_date},${content}" >> "${DATA_FILE}"

    echo "Entry created successfully!"
    read -p "Press Enter to continue..."
}

list_entries() {
    clear
    echo "---------------------"
    echo "List of Entries"
    echo "---------------------"

    column -t -s ',' "${DATA_FILE}"
    read -p "Press Enter to continue..."
}

search_entries() {
    clear
    echo "---------------------"
    echo "Search Entries"
    echo "---------------------"

    echo "Enter keyword to search: "
    read keyword

    grep -i "${keyword}" "${DATA_FILE}" | column -t -s ','
    read -p "Press Enter to continue..."
}
delete_entry() {
    clear
    echo "---------------------"
    echo "Delete Entry"
    echo "---------------------"

    echo "Enter the ID of the entry to delete: "
    read entry_id

    if grep -q "^${entry_id}," "${DATA_FILE}"; then
        grep -v "^${entry_id}," "${DATA_FILE}" > "${DATA_FILE}.tmp"
        mv "${DATA_FILE}.tmp" "${DATA_FILE}"
        echo "Entry deleted successfully!"
    else
        echo "Entry not found!"
    fi

    read -p "Press Enter to continue..."
}
edit_entry() {
    clear
    echo "---------------------"
    echo "Edit Entry"
    echo "---------------------"

    echo "Enter the ID of the entry you want to edit: "
    read entry_id

    # Check if the entry with the given ID exists in the data file
    if grep -q "^${entry_id}," "${DATA_FILE}"; then
        # Prompt user for new title and content
        echo "Enter new title: "
        read new_title

        echo "Enter new content (press Ctrl+D when done): "
        new_content=$(cat)

        # Create a temporary file with the updated entry
        grep -v "^${entry_id}," "${DATA_FILE}" > "${DATA_FILE}.tmp"
        echo "${entry_id},${new_title},$(date +"%Y-%m-%d %H:%M:%S"),${new_content}" >> "${DATA_FILE}.tmp"
        mv "${DATA_FILE}.tmp" "${DATA_FILE}"

        echo "Entry edited successfully!"
    else
        echo "Entry not found!"
    fi

    read -p "Press Enter to continue..."
}
tag_entry() {
    clear
    echo "---------------------"
    echo "Tag Entry"
    echo "---------------------"

    echo "Enter the ID of the entry you want to tag: "
    read entry_id

    # Check if the entry with the given ID exists in the data file
    if grep -q "^${entry_id}," "${DATA_FILE}"; then
        # Prompt user for tags
        echo "Enter tags (comma-separated): "
        read tags

        # Update tags in the data file
        sed -i "/^${entry_id},/s/,[^,]*$/,$tags/" "${DATA_FILE}"

        echo "Tags added successfully!"
    else
        echo "Entry not found!"
    fi

    read -p "Press Enter to continue..."
}

while true; do
    clear
    echo "---------------------"
    echo "Linux Terminal Journal"
    echo "---------------------"
    echo "1. Create New Entry"
    echo "2. Edit Entry"
    echo "3. List Entries"
    echo "4. Search Entries"
    echo "5. Delete Entries"
    echo "6. Tag Entries"
    echo "7. Exit"
    echo "---------------------"
    echo "Enter your choice: "
    read choice

    case $choice in
        1) create_entry ;;
        2) edit_entry ;;
        3) tag_entry ;;
        4) list_entries ;;
        5) search_entries ;;
        6) delete_entry ;;
        7) exit ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
done
