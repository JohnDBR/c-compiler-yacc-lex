#!/bin/bash
echo "-------------------------------------------------"
echo "Borrando archivos...!"
sudo rm -rf lex.yy.c y.tab.h y.tab.c salida.txt
echo "-------------------------------------------------"
echo "Generando archivo lex.yy.c!"
lex code_lex.l
echo "-------------------------------------------------"
echo "Generando archivo y.tab.c Y y.tab.h"
bison -d -y code_yacc.y 
echo "-------------------------------------------------"
echo "Generando archivo RR.out"
gcc lex.yy.c y.tab.c -o RR.out
echo "-------------------------------------------------"
echo "Corriendo archivo RR.out con el archivo de prueba!"
./RR.out /home/john/Documents/LaboratorioCompiladores/c-compiler-yacc-lex/TXTs/prueba2.c
 #prove.txt
 #archivoDePrueba.txt 
echo "-------------------------------------------------"
echo "Imprimiendo archivo de entrada"
echo " "
cat salida.txt
