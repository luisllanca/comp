flex -l tareaFlex.l
bison -dy tareaBison.y
gcc -o main y.tab.c lex.yy.c
main.exe