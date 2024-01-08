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
PS3="choose option : "

while true; do
options=("select_All" "select by Column" "select Column" "Return To Main Menu");
echo "Which select option do you want to choose or Return to Table Menu ?"
select option in "${options[@]}"
do
    case $option in
        "select_All") 
	echo "========================================================================"
	cat "$tableMeta" | awk 'BEGIN{ RS = "\n"; FS = ":" } {print $1}' | awk 'BEGIN{ORS="\t"} {print $0}'
	echo -e "\n========================================================================"
	cat "$tableData" | awk -F: 'BEGIN{OFS="\t"} {for(i = 1; i <= NF; i++) $i=$i}  1'   #1 		"triggers the default action to print the entire line
	break 
#awk '{  field_width = 10  # Set the desired field width  num_fields = NF   # Get the number of fields in the current record    for (i = 1; i <= num_fields; i++) {    printf "%-*s", field_width, $i  # Use printf with the "-" flag to left-align the field  }    printf "\n"  # Print a newline after each record}' file.txt

;;
         "select by Column") source ~/DBMS/select_by_column.sh ;;
	 "select Column") source ~/DBMS/select_column.sh ;;
	"Return To Main Menu") source ~/DBMS/Main_Menu.sh ;;
	*) echo "Invalid option $REPLY" ;;
     esac

done
done
