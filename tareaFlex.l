%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

void yyerror(char *);


%}

%option noyywrap

/* TOKENS */
DIGITS          [0-9]
DIGITO          {DIGITS}+
LETRA           [a-z]
LETRAMAYUS      [A-Z]
IDENTIFICADOR   {LETRAMAYUS}{DIGITS}
INICIO          "inicio"
FIN             "fin"
LEER            "leer"
ESCRIBIR        "escribir"
SI              "si"
ENTONCES        "entonces"
ALPHA           [a-zA-Z0-9 _.?¿]+

%%
{INICIO}        {yylval.reserved = yytext; return INICIO;}    
{FIN}           {yylval.reserved = yytext; return FIN;}
{LEER}          {yylval.reserved = yytext; return LEER;}
{ESCRIBIR}      {yylval.reserved = yytext; return ESCRIBIR;}
{SI}            {yylval.reserved = yytext; return SI;}
{ENTONCES}      {yylval.reserved = yytext; return ENTONCES;}
{DIGITO}        { yylval.number=atoi(yytext); return DIGITO; }
{IDENTIFICADOR} {yylval.cad = strdup(yytext); return IDENTIFICADOR; }
{ALPHA}         { yylval.cad = strdup(yytext); return CADENA;}
[=]             { yylval.simbol = strdup(yytext); return ASSIGN; }
[<|>|==]        { yylval.simbol = strdup(yytext);  return COMPARISON; }
[+|-|*|/]		{ yylval.simbol = strdup(yytext); return ARITHMETIC; }
[;]		        { yylval.simbol = strdup(yytext); return SEMICOLON; }
[(|)]           { yylval.simbol = strdup(yytext); return PRTS; }
["]             { yylval.simbol = strdup(yytext); return QUOTES; }

[ \n]+    ;
.               {printf(" <<ERROR LEXICO >>", yytext);}

%%

