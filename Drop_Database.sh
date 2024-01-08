#!/bin/bash
shopt -s extglob
# Function to check if a valid database name


ls -F | grep / | awk '{ sub("/$", ""); print }'
read -p "Enter the name of the database you want to drop : " DB_Name

check_Database_name_exist() {
   until ([[ -d "$DB_Name" ]])  
   do echo " The name is does not exist"
       read -p " please Re_enter name: " DB_Name
   done
        
             
}


# Function to check if a valid database name
check_valid_Database_name() {
    while ([[ ! "$DB_Name" =~ ^[A-Za-z_][A-Za-z0-9_]*$ || "$DB_Name" = *' '* || "$DB_Name" = '_' ]]) 
    do echo -e "Invalid Database Name " # names must start with a letter or underscore \nand contain only letters, numbers, underscores & no spaces allowed."
      read -p "Re_enter name:"  DB_Name
    done
    read -p "Are you sure you want to delete the database '$DB_Name'? (y/n): " confirm
        case "$confirm" in
            y|Y)
                rm -r "$DB_Name"
                if [ $? -eq 0 ]; then
                    echo "Database '$DB_Name' dropped successfully."
                else
                    echo "An error occurred while dropping the database."
                fi
                ;;
            n|N)
                echo "Deletion canceled. Database '$DB_Name' was not deleted."
                ;;
            *)
                echo "Invalid input. Please enter 'y' or 'n'."
                ;;
        esac
   
    
      
}



# Call the functions
check_Database_name_exist
check_valid_Database_name
source ~/DBMS/Main_Menu.sh

