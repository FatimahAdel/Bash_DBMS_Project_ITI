#! /usr/bin/bash
shopt -s extglob

read -p "Enter the name of the new Database to be Created: " DB_Name


check_Database_name_exist() {
   while ([[ -d "$DB_Name" ]])  
   do echo " The name is already exist"
       read -p " please Re_enter name: " DB_Name
   done
        
             
}


# Function to check if a valid database name
check_valid_Database_name() {
    while ([[ ! "$DB_Name" =~ ^[A-Za-z_][A-Za-z0-9_]*$ || "$DB_Name" = *' '* || "$DB_Name" = '_' ]]) 
    do echo -e "Invalid Database Name " # names must start with a letter or underscore \nand contain only letters, numbers, underscores & no spaces allowed."
      read -p "Re_enter name:"  DB_Name
    done
    
      
}



# Call the functions
check_Database_name_exist
check_valid_Database_name


	mkdir "./$DB_Name"
        # Check the exit status of the last command
	if [ $? -eq 0 ]; then
	    echo " "
            echo -e "$DB_Name Created Successfully."
	    echo " "
        else
            echo -e "An Error occurred While Creating the Database."
        fi


source ~/DBMS/Main_Menu.sh 
