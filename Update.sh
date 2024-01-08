#!/bin/bash

clear -x
echo "================= All Tables In This Database ================"
ls -F | grep -v / | ls -I "*.meta" 

read -p " PLease enter the name of Table To Update : " Table_name

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






PS3="Choose option : "
columns=()
dataTypes=()
PKs=()

read -d '\n' -r -a lines < "$tableMeta"

function readTableMeta() {
    for i in "${!lines[@]}"; do
        IFS=':' read -r -a column <<< "${lines[i]}"
        name=${column[0]}
        dataType=${column[1]}
        PK=${column[2]}
        columns+=("$name")
        dataTypes+=("$dataType")
        PKs+=("$PK")
    done
}

function selectRecords() {
    local colIndex="$1"
    local colname="${columns[$((colIndex-1))]}"
    local colDataType="${dataTypes[$((colIndex-1))]}"
    local colPK="${PKs[$((colIndex-1))]}"
    


    # validate the new value type
            while true; do
             read -rp "Enter $colname: " value

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

function updateColumn() {
    local updateColIndex="$1"
    local colname="${columns[$((updateColIndex-1))]}"
    local colDataType="${dataTypes[$((updateColIndex-1))]}"
    local colPK="${PKs[$((updateColIndex-1))]}"

    function validateValue() {
        # validate the new value type
            while true; do
                read -rp "Enter $colname: " updateColValue
                if [[ $colDataType == "Int" && ! "$updateColValue" =~ ^[0-9]+$ ]]; then
                    echo -e "\n$colname must be a number."
                elif [[ $colDataType == "String" && ! "$updateColValue" =~ ^[a-zA-Z]+$ ]]; then
                    echo -e "\n$colname must be a string."
                else
                    break
                fi
            done

        # validate if PK
        if [[ $colPK == "PK" ]]; then
            # get all column data from tableData
            read -d '' -r -a dataLines < "$tableData"  # all table
            # loop over column data to check PK if unique
            for j in "${!dataLines[@]}"; do
                IFS=':' read -r -a record <<< "${dataLines[$j]}"  # record(row)
                if [[ ${record[$((updateColIndex-1))]} == $updateColValue ]]; then
                    echo "$colname is a primary key and must be unique."
                    echo ""
                   
                    validateValue
                fi
            done
        fi
    }

    # read new column value from user
  #read -rp "Enter $colname: " updateColValue
    validateValue

echo "$(awk -v i="$colIndex" -v ui="$updateColIndex" -v v=$value -v nv=$updateColValue -F':' 'BEGIN{OFS=FS}{if ($i == v) $ui=nv; print $0;}' $tableData)" 1> $tableData


    echo " Update done successfully !"
}

readTableMeta

echo "Which column do you want to update records by?"
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

queryColumnName=$colname

echo "Which column do you want to update?"
while true; do
    select column in "${columns[@]}"; do
        if [[ ![0-9]*$ =~ "${column}" ]]; then
            echo "You need to choose one of the options"
            continue 2
        fi

        let updateColIndex=($REPLY)
        updateColumn "$updateColIndex"

        break 2
    done
done

echo "------------------------"
options=("Update Another Record" "Return To The Main Menu")

select option in "${options[@]}"; do
    case $option in
        "Update Another Record") source ~/DBMS/Update.sh ;;
        "Return To The Main Menu") source ~/DBMS/Main_Menu.sh ;;
        *) echo "Invalid option $REPLY" ;;
    esac
done
