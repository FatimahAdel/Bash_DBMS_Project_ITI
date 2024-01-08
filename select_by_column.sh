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




PS3="Choose column : "
columns=()
dataTypes=()


read -d '\n' -r -a lines < "$tableMeta"

function readTableMeta() {
    for i in "${!lines[@]}"; do
        IFS=':' read -r -a column <<< "${lines[i]}"
        name=${column[0]}
        dataType=${column[1]}
        columns+=("$name")
        dataTypes+=("$dataType")
        
    done
}

function selectRecords() {
    local colIndex="$1"
    local colname="${columns[$((colIndex-1))]}"
    local colDataType="${dataTypes[$((colIndex-1))]}"

    


    # validate the new value type
            while true; do
             read -rp "select * from $tableData where $colname = " value

                if [[ $colDataType == "Int" && ! "$value" =~ ^[0-9]+$ ]]; then
                    echo -e "\n$colname must be a number."
                elif [[ $colDataType == "String" && ! "$value" =~ ^[a-zA-Z]+$ ]]; then
                    echo -e "\n$colname must be a string."
                else
                    break
                fi
            done

    # loop over column data to check PK if unique
    read -d '' -r -a dataLines < "$tableData"  # all table
    for j in "${!dataLines[@]}"; do
        IFS=':' read -r -a record <<< "${dataLines[$j]}"  # record(row)
        if [[ ${record[$((colIndex-1))]} == $value ]]; then
            echo "Matched Records"
            break 3 ;
        fi
    done
    echo "No Matched Records, please select again : "
}



readTableMeta

echo "Which column do you want to select records by?"
while true; do
    select column in "${columns[@]}"; do
        if [[ ![0-9]*$ =~ "${column}" ]]; then
            echo "You need to choose one of the options"
            continue 2
        fi

        let colIndex=($REPLY)
        selectRecords "$colIndex"

        break
       
    done

done

echo "====================================================================="
cat "$tableMeta" | awk 'BEGIN{ RS = "\n"; FS = ":" } {print $1}' | awk 'BEGIN{ORS="\t"} {print $0}'
echo -e "\n====================================================================="
#awk -v i="$colIndex" -v v="$value" -v separator="	" -F':' '{ if ($i == v) printf "%s%s", $0, separator;}' "$tableData"
#awk -v i="$colIndex" -v v=$value -F':'  '{ if ($i == v) print $0;}' $tableData > separator | cat ./separator| awk 'BEGIN{OFS = "\t"; FS = ":" } {print $0}' 
awk -v i="$colIndex" -v v="$value" -v OFS="	" -F':' '{ if ($i == v) print $0;}' "$tableData"
echo " "



options=("select Another Record" "Return To The Select Menu" "Return To The Main Menu")
select option in "${options[@]}" 
do
   case $option in
	"select Another Record") source ~/DBMS/select_by_column.sh ;;
        "Return To The Select Menu") source ~/DBMS/select.sh  ;;
        "Return To The Main Menu") source ~/DBMS/Main_Menu.sh  ;;
         *) echo "Invalid option $REPLY" ;;
    esac
done
