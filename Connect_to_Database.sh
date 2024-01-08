#!/bin/bash

echo "================= All Databases In the system ================"

ls -F | grep / | awk '{ sub("/$", ""); print }'
echo " "
read -p "Please enter the name of Database to connect to : " DB_Name
#export DBNAME="$DB_Name"
# Function to check if a valid table name
check_valid_DB_name() {
    while ([[ ! "$DB_Name" =~ ^[A-Za-z_][A-Za-z0-9_]*$ || "$DB_Name" = *' '* ]]) 
    do echo -e "Invalid Table Name, names must start with a letter or underscore \nand contain only letters, numbers, underscores & no spaces allowed."
      read -p "Re_enter name or press 'q' to back to Main Menu"  DB_Name
      if [[ $DB_Name == "q" ]]; then 
       . ./Main_Menu.sh
      fi
    done
    
      
}

# Function to check if table name exists
check_DB_name_exist() {
   until ([[ -d "$DB_Name" ]])  
   do echo " The name is not exist"
      read -p "Re_enter name or press 'q' to back to Main Menu"  DB_Name
      if [[ $DB_Name == "q" ]]; then 
       . ./Main_Menu.sh
      fi
   done  
        
             
}

# Call the functions
check_valid_DB_name
check_DB_name_exist

cd "./$DB_Name"  #paths

options=("Create Table" "List Tables" "Drop Table" "Insert into Table" "Select from Table" "Delete from Table" "Update Table" "Main Menu" "Quit")

select option in "${options[@]}"
do
    case $option in
         "Create Table") source ~/DBMS/Create_table.sh

;;
         "List Tables") source ~/DBMS/List_table.sh

;;
         "Drop Table") source ~/DBMS/Drop_table.sh 
;;
         "Insert into Table") source ~/DBMS/Insert.sh 
;;
         "Select from Table") source ~/DBMS/select.sh 
;;
         "Delete from Table") source ~/DBMS/Delete.sh 
;;
         "Update Table") source ~/DBMS/Update.sh 
;;
         "Main Menu") source ~/DBMS/Main_Menu.sh 
;;
         "Quit") exit
;;
         *) echo "Invalid Option $REPLY"
;;
     esac

done
