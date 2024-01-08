#!/bin/bash


cd ~/DBMS  
options=("Create Database" "List Databases" "Connect To Databases" "Drop Database" "Quit")
echo "============================================================="
echo -e " Hello! , Welcome To Our Database Managment System Project "
echo "============================================================="
echo ""
PS3=" Select one of the option : "
select option in "${options[@]}"
do
    case $option in
        "Create Database") source ~/DBMS/Create_Database.sh 
;;
         "List Databases") source ~/DBMS/List_Databases.sh      
;;
         "Connect To Databases")source ~/DBMS/Connect_to_Database.sh
;;
         "Drop Database") source ~/DBMS/Drop_Database.sh
;;
         "Quit") exit
;;
         *) echo "Invalid Option $REPLY"
;;
     esac

done
echo " "
