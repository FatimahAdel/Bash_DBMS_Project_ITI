#!/usr/bin/bash
clear -x
echo "================= All Tables In This Database ================"
ls -F | grep -v / | ls -I "*.meta" 
source ~/DBMS/Main_Menu.sh
