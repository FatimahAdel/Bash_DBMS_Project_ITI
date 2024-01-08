#!/bin/bash

clear -x
echo "================= All Tables In This Database ================"
ls -F | grep -v / | ls -I "*.meta" 

read -p " PLease enter the name of Table To Select From : " Table_name

# Function to check if table name exists
check_table_name_exist() {
   until ([[ -e "$Table_name" ]])  
   do 
       read -p " this name dose not exist please Re_enter name or 'q' to exit: " Table_name
       if [[ $Table_name == "q" ]]; then 
         . ./Connect_to_Database.sh
       fi
   done
        
             
}

# Function to check if a valid table name
check_valid_table_name() {
    while ([[ ! "$Table_name" =~ ^[A-Za-z_][A-Za-z0-9_]*$ || "$Table_name" = *' '* || "$Table_name" = '_' ]]) 
    do echo -e "Invalid Table Name, names must start with a letter or underscore \nand contain only letters, numbers, underscores & no spaces allowed."
      read -p "Re_enter name or 'q' to exit : "  Table_name
       if [[ $Table_name == "q" ]]; then 
         . ./Connect_to_Database.sh
       fi
    done
    
      
}

# Call the functions
check_table_name_exist
check_valid_table_name


# Specify table data and metadata file paths
tableData=./"$Table_name"
tableMeta=./"$Table_name"".meta"
PS3="Choose option : "
columns=()

read -d '\n' -r -a lines < "$tableMeta"

function readTableMeta() {
     for i in "${!lines[@]}"; do
        IFS=':' read -r -a column <<< "${lines[i]}"
        name=${column[0]}
        
        columns+=("$name")
        
    done
}

readTableMeta

echo "Which column do you want to select records?"

select column in "${columns[@]}"; do
    if [[ -n "$column" ]]; then
        echo "Selected column: $column"
        let colIndex=($REPLY)
        awk -v i="$colIndex" -F':' '{ print $i }' "$tableData"
        break
    else
        echo "Invalid option, please choose again."
    fi
done

echo " "
options=("select Another column" "Return To The Select Menu" "Return To The Main Menu")

select option in "${options[@]}"
do
case $option in
	"select Another column") source ~/DBMS/select_column.sh ;;
        "Return To The select Menu") source ~/DBMS/select.sh ;;
        "Return To The Main Menu") source ~/DBMS/Main_Menu.sh ;;
         *) echo "Invalid option $REPLY" ;;
    esac
done
