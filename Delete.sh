#!/bin/bash

clear -x
echo "================= All Tables In This Database ================"
ls -F | grep -v / | ls -I "*.meta"
read -p " PLease enter the name of Table To Delete Record From : " Table_name

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



# which column you want to delete records by
columns_name=(); #array of coulmns names
dataTypes=(); #array of coulmns dataTypes
PKs=(); # array of primay keyes

# get column names and dataTypes
read -d '\n' -r -a lines < "$tableMeta"
for i in "${!lines[@]}" # each line of the Meta table
do
  IFS=':' read -r -a column <<< "${lines[i]}"; # get parts of that particular line

  name=${column[0]};
  dataType=${column[1]};
  PK=${column[2]};

  columns_name+=($name)
  dataTypes+=($dataType);
  PKs+=($PK);
done


echo "Which column do you want to Delete records by?";
# show columnNames as options
while [ true ]; do
   PS3="Choose an option please : "
  select column in ${columns_name[@]};
  do
      if [[ "\?" =~ "${column}" ]]; then # valid option
            echo "OPS!! You need to select one of the displayed options"
          continue 2;
      fi

      colInd=($REPLY)
      colname="${columns_name[$((colInd-1))]}"
      colDataType="${dataTypes[$((colInd-1))]}"
      colPK="${PKs[$((colInd-1))]}"

    #read new value from user
    read -rp "Enter $colname value for record that you want to delete :  " value;

    # validate the new value type
    if [[ $colDataType == "Int" ]]; then
        while ! [[ $value =~ ^[0-9]+$ ]]; do
          echo "";
            echo "$colname must be a number.";
            echo ""
            read -rp "Enter $colname: " value;
        done
    elif [[ $colDataType == "String" ]]; then
        while ! [[ $value =~ ^[a-zA-Z]+$ ]]; do
          echo "";
            echo "$colname must be a string.";
            echo ""
            read -rp "Enter $colname: " value;
        done
    fi

    read -d '' -r -a dataLines < "$tableData"  # all table
    #loop over column data to check pk if unique
    for j in "${!dataLines[@]}";
    do
        IFS=':' read -r -a record <<< "${dataLines[$j]}"; # record(row)

        if [[ ${record[$((colInd-1))]} == $value ]]; then
         break 3;
        fi
    done
    echo "No Matched Records, press Enter to choose record again";
  done
done

echo "$(awk -v i="$colInd" -v v=$value -F':' 'BEGIN{OFS=FS}{if ($i != v) print $0;}' $tableData)" 1> $tableData
echo " Deleted Done successfully ";

echo "================================================================";
options=("Delete Another Record" "Return To The Main Menu");

select option in "${options[@]}"
do
    case $option in
        "Delete Another Record") source ~/DBMS/Delete.sh ;;
        "Return To The Main Menu") source ~/DBMS/Main_Menu.sh ;;
        *) echo "Invalid option $REPLY";;
    esac
done
