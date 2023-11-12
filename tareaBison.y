%{
    #include <stdio.h>
    #include <string.h>

    int yylex(void);
    void yyerror(char *s);
    extern FILE *yyin;

    struct SymbolTable {
        char* name;
        int value;
    };

    struct SymbolTable symbolTable[100];
    int symbolCount = 0;

%}

%union {
    char* cad;
    int number;
    char* reserved;
    char* simbol;

}

%token <reserved> INICIO
%token <reserved> FIN 
%token <reserved> LEER 
%token <reserved> ESCRIBIR 
%token <reserved> SI
%token <reserved> ENTONCES 

%token <cad> IDENTIFICADOR
%token <cad> CADENA
%token <number> DIGITO

%token <simbol> ASSIGN
%token <simbol> COMPARISON
%token <simbol> ARITHMETIC
%token <simbol> SEMICOLON
%token <simbol> PRTS
%token <simbol> QUOTES
%type <number> expression operation 

%left '+' '-'
%left '*' '/'
%left NEG

%start EPRIMA

%%
        EPRIMA: INICIO SENTENCES FIN 
        { printf("mensaje completado\n"); }
        ;

        SENTENCES: E SENTENCES | /* epsilon */

        E:  
            ESCRIBIR PRTS QUOTES CADENA QUOTES PRTS SEMICOLON
            {
                if (strcmp($2, "(") == 0 && strcmp($6, ")") == 0) {
                    printf("  %s\n", $4);
                }
            }
        
            | IDENTIFICADOR ASSIGN expression SEMICOLON
            {
                /* Asignar dentro de la tabla */
                symbolTable[symbolCount].name = strdup($1);
                symbolTable[symbolCount].value = $3;
                symbolCount++;
            }
            | LEER PRTS IDENTIFICADOR PRTS SEMICOLON
            {
                if (strcmp($2, "(") == 0 && strcmp($4, ")") == 0) {
                    int i;
                     for (i = 0; i < symbolCount; i++) {
                        if (strcmp(symbolTable[i].name, $3) == 0) {
                            printf("    %d\n", symbolTable[i].value);
                            break;  
                        }
                    }
                }   
            }   
            ;

        expression:
            IDENTIFICADOR 
            {
                int i;
                for (i = 0; i < symbolCount; i++) {
                    if (strcmp(symbolTable[i].name, $1) == 0) {
                        $$ = symbolTable[i].value;
                        break;  
                    }
                }
            }
            | DIGITO { $$ = $1; }
            | expression ARITHMETIC operation
            { 
                /* operaciones aritmeticas + - * / */

                if (strcmp($2, "+") == 0) {
                    $$ = $1 + $3;
                } else if (strcmp($2, "-") == 0) {
                    $$ = $1 - $3;
                } else if (strcmp($2, "*") == 0) {
                    $$ = $1 * $3;
                } else if (strcmp($2, "/") == 0) {
                    $$ = $1 / $3;
                } 
            }
            ;

        operation:
            IDENTIFICADOR 
            {
                int i;
                for (i = 0; i < symbolCount; i++) {
                    if (strcmp(symbolTable[i].name, $1) == 0) {
                        $$ = symbolTable[i].value;
                        break;  
                    }
                }
            }
            | DIGITO { $$ = $1; }
            | PRTS expression PRTS  
            {
                $$ = $2; 
            }
            ;
%%

int main() {
    return(yyparse());
}

void yyerror(char *s) {
    printf("Error: %s\n", s);
}

int yywrap(){
    return 1;
}
