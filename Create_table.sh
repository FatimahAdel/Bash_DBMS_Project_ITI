#! /usr/bin/bash
read -p " PLease enter the name of Table To be created: " Table_name

# Function to check if table name exists
check_table_name_exist() {
   while ([[ -f "$Table_name" ]])  
   do echo " The name is already exist"
       read -p " please Re_enter name: " Table_name
   done
        
             
}


# Function to check if a valid table name
check_valid_table_name() {
    while ([[ ! "$Table_name" =~ ^[A-Za-z_][A-Za-z0-9_]*$ || "$Table_name" = *' '* || "$Table_name" = '_' ]]) 
    do echo -e "Invalid Table Name, names must start with a letter or underscore \nand contain only letters, numbers, underscores & no spaces allowed."
      read -p "Re_enter name:"  Table_name
    done
    
      
}



# Call the functions
check_table_name_exist
check_valid_table_name
      touch ./"$Table_name"
        if [ $? -eq 0 ]; then
            echo -e "$Table_name table Created Successfully."
        else
            echo -e "An Error occurred While Creating the Table."
        fi

read -p "please enter the number_of_fields : " fields_number



#echo $PK:"Int" >> "$Table_name"".meta"

num=1
while [ $num -le $fields_number ];
do read -p "please enter the name of column $num : " column_name
#Check Datatype 
PS3="[$column_name] DataType : "
            echo -e "Select Choice 1 or 2 : "
            select choice in "String" "Int"
            do
                case $REPLY in
                    1)  if ! [[ $pkFlag ]]; then
                        while [ true ]; do
                        read -rp "Is it Primary-Key (PK): (y/n)" pk;
                          case "$pk" in
                           "y" | "Y" ) 
                           echo "$column_name:$choice:PK">>"$Table_name"".meta"
                                pkFlag=1;
                                break;;
                           "n" | "N" ) 
                           echo "$column_name:$choice:no">>"$Table_name"".meta"
                                break;;
                                   * ) echo "Invalid option $REPLY";;
                          esac
                       done
                       else
                             echo "$column_name:$choice:no">>"$Table_name"".meta"         
                        fi
                       
                        
                        #fields_number=$(( fields_number - 1))
                        break;;
                    2)  if ! [[ $pkFlag ]]; then
                        while [ true ]; do
                        read -rp "Is it Primary-Key (PK): (y/n)" pk;
                          case "$pk" in
                           "y" | "Y" ) 
                           echo "$column_name:$choice:PK">>"$Table_name"".meta"
                                pkFlag=1;
                                break;;
                           "n" | "N" ) 
                           echo "$column_name:$choice:PK">>"$Table_name"".meta"
                                break;;
                                   * ) echo "Invalid option $REPLY";;
                          esac
                       done
                       else
                                       echo "$column_name:$choice:no">>"$Table_name"".meta"
                        fi
                        
                        
                        #fields_number=$(( fields_number - 1))
                        break;;
                    *)  
                        echo   "----------------------------------------------------------------------"
                        echo "------------------------------wrong choise----------------------------"
                        echo "----------------------------------------------------------------------"
                esac
            done
 
((num+=1))
done
echo "Table $Table_name Created Successfully " 
echo ""

source ~/DBMS/Main_Menu.sh 
