#!/bin/bash

clear -x
echo "================= All Tables In This Database ================"
ls -F | grep -v / | ls -I "*.meta" 

read -p " PLease enter the name of Table To insert in : " Table_name

# Function to check if table name exists
check_table_name_exist() {
   until ([[ -e "$Table_name" ]])  
   do 
       read -p " this name dose not exist please Re_enter name or 'q' to exit: " Table_name
       if [[ $Table_name == "q" ]]; then 
         source ~/DBMS/Main_Menu.sh
       fi
   done
        
             
}

# Function to check if a valid table name
check_valid_table_name() {
    while ([[ ! "$Table_name" =~ ^[A-Za-z_][A-Za-z0-9_]*$ || "$Table_name" = *' '* || "$Table_name" = '_' ]]) 
    do echo -e "Invalid Table Name, names must start with a letter or underscore \nand contain only letters, numbers, underscores & no spaces allowed."
      read -p "Re_enter name or 'q' to exit : "  Table_name
       if [[ $Table_name == "q" ]]; then 
         source ~/DBMS/Main_Menu.sh
       fi
    done
    
      
}

# Call the functions
check_table_name_exist
check_valid_table_name

# Specify table data and metadata file paths
tableData=./"$Table_name"
tableMeta=./"$Table_name"".meta"

# Initialize newRecord variable
newRecord=""

# Read columns info from tableName.metadata into array
columns=($(cut -d: -f1 "$tableMeta"))
dataTypes=($(cut -d: -f2 "$tableMeta"))
PKs=($(cut -d: -f3 "$tableMeta"))

# Function to validate column value
validateValue() {
    # Validate the new value type
    if [[ $dataType == "Int" ]]; then
        regex='^[0-9]*$'
        prompt="$name (integer, press Enter to skip): "
    elif [[ $dataType == "String" ]]; then
        regex='^[a-zA-Z]*$'
        prompt="$name (string, press Enter to skip): "
    fi

    while true; do
        read -rp "$prompt" value
        if [[ -z "$value" || $value =~ $regex ]]; then
            break
        else
            echo "Invalid input. $prompt"
        fi
    done

    # Validate if PK
    if [[ $PK == "PK" && ! -z "$value" ]]; then
        # Get all column data from tableData
        read -d '' -r -a dataLines < "$tableData"

        # Loop over column data to check PK if unique
        for record in "${dataLines[@]}"; do
            IFS=':' read -r -a fields <<< "$record" # fields(row)
            if [[ ${fields[i]} == $value ]]; then
                echo "Invalid $name is a primary key and must be unique."
                validateValue
            fi
        done
    fi
}

# Iterate over columns and read values from the user
for i in "${!columns[@]}"; do
    name=${columns[i]}
    dataType=${dataTypes[i]}
    PK=${PKs[i]}

    # Read new column value from the user
    validateValue

    # Construct newRecord
    if [[ $i == 0 ]]; then
        newRecord=$value
    else
        newRecord+=":$value"
    fi
done

# Check if newRecord is not empty and store it in the tableData file
if [[ ! -z "$newRecord" ]]; then
    if echo "$newRecord" >> "$tableData"; then
        echo ""
        echo "Record stored successfully."
    else
        echo "ERROR: Failed to store record."
    fi
else
    echo "Record skipped (no values provided)."
fi

echo "------------------------"
options=("Insert Another Record" "Return To The Main Menu")

select option in "${options[@]}"; do
    case $option in
        "Insert Another Record") source ~/DBMS/Insert.sh ;;
        "Return To The Main Menu") source ~/DBMS/Main_Menu.sh ;;
        *) echo "Invalid option $REPLY" ;;
    esac
done



