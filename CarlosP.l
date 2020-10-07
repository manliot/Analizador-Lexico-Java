%{
#include <stdio.h>
int yylineno;
int err = 0;
#define IF 1
#define ELSE 2
#define FOR 3
#define WHILE 4
#define DOUBLE 5
#define INT 6
#define STRING 7
#define NEW 8
#define PUBLIC 9
#define CLASS 10
#define STATIC 11
#define VOID 12
#define OPMUL 13
#define OPSUM 14
#define OPSUST 15
#define OPDIV 16
#define OPASING 17
#define OPMOD 18
#define SUMSUM 19
#define SUSTSUST 20
#define SUMASING 21
#define SUSTASING 22
#define MULASING 23
#define DIVASING 24
#define LLAVEA 25
#define LLAVEC 26
#define PUNTOYCOMA 27
#define PARENTESISA 28
#define PARENTESISC 29
#define CORCHETEA 30
#define CORCHETEC 31
#define OPRIGUAL 32
#define OPRMENORIGUAL 33
#define OPERMAYORIGUAL 34
#define OPERDIFERENTE 35
#define OPERMAYOR 36
#define OPERMENOR 37
#define OPERDIFERENTEX 38
#define OPLY 39
#define OPLO 40
#define OPLNO 41
#define ID 42
#define ENTERO 43
#define PALABRA 44
#define FLOTANTE 45
#define PUNTO 46
#define COMA 47
%}
letraMin [a-z]
letraMa [A-Z]
digito [0-9]
%%
"if"			return IF;
"else"			return ELSE;
"for"			return FOR;
"while"			return WHILE;
"double"		return DOUBLE;
"int"			return INT;
"String"		return STRING;
"new"			return NEW;
"public"		return PUBLIC;
"class"			return CLASS;
"static"		return STATIC;
"void"			return VOID;
"*"			return OPMUL;
"+"			return OPSUM;
"-"			return OPSUST;
"/"			return OPDIV;
"="			return OPASING;
"%"			return OPMOD;
"++"			return SUMSUM;
"--"			return SUSTSUST;
"+="			return SUMASING;
"-="			return SUSTASING;
"*="			return MULASING;
"/="			return DIVASING;
"{"			return LLAVEA;
"}"			return LLAVEC;
";"			return PUNTOYCOMA;
"("			return PARENTESISA;
")"			return PARENTESISC;
"["			return CORCHETEA;
"]"			return CORCHETEC;
"=="			return OPRIGUAL;
"<="			return OPRMENORIGUAL;
">="			return OPERMAYORIGUAL;
"<>"			return OPERDIFERENTE;
">"			return OPERMAYOR;
"<"			return OPERMENOR;
"!="			return OPERDIFERENTEX;
"&&"			return OPLY;
"||"			return OPLO;
"!"			return OPLNO;
"."			return PUNTO;
","			return COMA;
({letraMin})({letraMin}|{letraMa}|{digito}|_)*	return ID;
"-"?[1-9][0-9]*			return ENTERO;
["][a-zA-Z0-9 ]*["]		return PALABRA;
"-"?[0-9]+"."[0-9]+(e[+|-][1-9])*	return FLOTANTE;	
\n			yylineno++;
\t			;
\r			;
[ ]			;
.			err++;printf("\tERROR LEXICO-->");
%%
char *const names[]={NULL,"IF","ELSE","FOR","WHILE","DOUBLE","INT","STRING","NEW","PUBLIC","CLASS","STATIC","VOID","op-mult","op-sum","op-sust","op-div","op-asing","op-mod","suma-suma","resta-resta","suma-asig","resta-asig","mul-asig","div-asig","llave-a","llave-c", "punto-y-coma","parent-a","parent-c","corchete-a","corchete-c","igual","menor-igual","mayor-igual","diferente","mayor","menor","diferenteX","op-y","op-o","op-no","id","entero","palabra","flotante","punto","coma"};
int yywrap(){
	return 1;
}

int main ()
{	
	
	int error=0;
	int ntoken,vtoken;
	ntoken = yylex();
	int antes=-1;
	while (ntoken){
		if(yylineno>antes){
			printf("\n\n\n");
		}				
		printf("Linea: %d \t Token: %s \t Lexema: %s \n",yylineno,names[ntoken],yytext);		
		antes=yylineno;
		/*	q=names[ntoken];
		if( strcmp(q,'ID')==0){
			for(j=1;i<strlen(str1);j++){
				strcpy(str1[0],yytext);
				char c = str1[0];
				if (c==str[j]){
					check=false;
					break;
				}
				if (check==false){
					strtcpy(str1[i],yytext);
					i++;
				}
				check=true;
			}

		}
*/		ntoken=yylex();
	}
	printf("\n\nNúmero de errores: %d \n\n",err);
	return 0;
}

