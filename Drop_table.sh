#!/bin/bash
shopt -s extglob
# Function to check if a valid database name

echo "================= All Table In dbname ==============="	
ls -I "*.meta" 

read -p "Enter the name of the database you want to drop : " Table_name

check_Table_name_exist() {
   until ([[ -f "$Table_name" ]] && [[ -f "$Table_name.meta" ]]) 
   do echo " The name is does not exist"
       read -p " please Re_enter name: " Table_name
   done
        
             
}


# Function to check if a valid database name
check_valid_Table_name() {
    while ([[ ! "$Table_name" =~ ^[A-Za-z_][A-Za-z0-9_]*$ || "$Table_name" = *' '* || "$Table_name" = '_' ]]) 
    do echo -e "Invalid Database Name " # names must start with a letter or underscore \nand contain only letters, numbers, underscores & no spaces allowed."
      read -p "Re_enter name:"  Table_name
    done
    read -p "Are you sure you want to delete the database '$Table_name'? (y/n): " confirm
        case "$confirm" in
            y|Y)
                rm -r "$Table_name"
		rm -r "$Table_name.meta" 
                if [ $? -eq 0 ]; then
                    echo "Database '$Table_name' dropped successfully."
                else
                    echo "An error occurred while dropping the database."
                fi
                ;;
            n|N)
                echo "Deletion canceled. Database '$Table_name' was not deleted."
                ;;
            *)
                echo "Invalid input. Please enter 'y' or 'n'."
                ;;
        esac
   
    
      
}



# Call the functions
check_Table_name_exist
check_valid_Table_name







source ~/DBMS/Main_Menu.sh  

