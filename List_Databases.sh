#!/usr/bin/bash
echo "================= All Databases In the system ================"

ls -F | grep / | awk '{ sub("/$", ""); print }'

echo " "
echo " "

source ~/DBMS/Main_Menu.sh 
