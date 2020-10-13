%{
   #include <stdio.h>
   #include <stdlib.h>
   #include <string.h>  
   int yylinea;
   int err=0;
   FILE* fichero; 
   int buscar(char *const yytext,char *const ids[],int i);
   #define IF          1;
   #define ELSE        2; 
   #define FOR         3;
   #define WHILE       4;
   #define DOUBLE      5;
   #define INT         6;
   #define STRING      7;
   #define NEW         8;
   #define PUBLIC      9;
   #define CLASS      10;
   #define STATIC     11;
   #define VOID       12;
   #define OP_MULT    13;
   #define OP_SUM     14;
   #define OP_SUST    15;
   #define OP_DIV     16;
   #define OP_ASIG    17;
   #define OP_MOD     18;
   #define PLUSPLUS   19;
   #define MENMEN     20;
   #define MASIGUA    21;
   #define MENOSIGUA  22;
   #define PORIGUA    23;
   #define DIVIGUA    24;
   #define LLAVE_A    25;
   #define LLAVE_C    26;
   #define PUNTOYCOM  27;
   #define PARENT_A   28;
   #define PARENT_C   29;
   #define CORCHET_A  30;
   #define CORCHET_C  31;
   #define CTE_ENT    32;
   #define CTE_REAL   33;
   #define CTE_CAD    34;
   #define ID         35;
   #define OP_IGUAL   36;
   #define OP_MENIGUA 37;
   #define OP_MAYIGUA 38;
   #define DIFERENTE  39;
   #define MAYOR      40;
   #define MENOR      41;
   #define OP_Y       42;
   #define OP_O       43;
   #define OP_NO      44;
   #define CHAR       45;
   #define COMENTARIO 46;
   #define ERROR      47;
   #define ARREGLO    48; 
%}
digito [0-9]
letra [a-zA-Z]
variable ({letra})({letra}|{digito})* 
entero "-"?({digito})+ 
symbolList ("("|")"|"{"|"}"|";"|"["|"]")
palclave ("if"|"else"|"for"|"while"|"new"|"public"|"class"|"static"|"void"|"char")
operador ("*"|"/"|"-"|"+"|"="|"%"|"++"|"--"|"+="|"-="|"*="|"/="|"=="|"<="|">="|"<>"|">"|"<"|"!="|"&&"|"||"|"!")
types ("int"|"String"|"double")
noSymbol [^*/\-+=%{}\[\];()><!|& \n\t]
%%
"//".*                                                                   return COMENTARIO;
"/*".*[\n]*.*"*/"                                                        return COMENTARIO;
"if"      return IF;
"else"    return ELSE;
"for"     return FOR;
"while"   return WHILE;
"double"  return DOUBLE;
"int"     return INT;
"String"  return STRING;
"new"     return NEW;
"public"  return PUBLIC;            
"class"   return CLASS;          
"static"  return STATIC;
"void"    return VOID;
"char"    return CHAR;
"*"       return OP_MULT;
"+"       return OP_SUM;
"-"       return OP_SUST;
"/"       return OP_DIV;
"="       return OP_ASIG;
"%"       return OP_MOD;
"++"      return PLUSPLUS;
"--"      return MENMEN;
"+="      return MASIGUA;
"-="      return MENOSIGUA;
"*="      return PORIGUA;
"/="      return DIVIGUA;
"{"		    return LLAVE_A;
"}"		    return LLAVE_C;
";"		    return PUNTOYCOM;
"("		    return PARENT_A;
")"		    return PARENT_C;
"["		    return CORCHET_A;
"]"		    return CORCHET_C;
{entero}                                                                 return CTE_ENT;
"-"?({digito})+"."({digito})+(e([-|+])[1-9]+)?                           return CTE_REAL;
("\"")([^\n\"]*([.])*)*("\"")                                            return CTE_CAD;
{variable}                                                               return ID;
{variable}"["{variable}|{digito}+"]"("["{variable}|{digito}+"]")?        return ARREGLO;
"=="		 return OP_IGUAL;
"<="		 return OP_MENIGUA;
">="		 return OP_MAYIGUA;
"<>"		 return DIFERENTE;
">"		   return MAYOR;
"<"		   return MENOR;
"!="		 return DIFERENTE;
"&&"		 return OP_Y;
"||"		 return OP_O;
"!"		   return OP_NO;
\n       yylinea++;
\t			;
\r			;
[ ]			;
({noSymbol}|^)+{variable}                             {err++;return ERROR};
{variable}({noSymbol}|^)+({letra}|{digito})*          {err++;return ERROR};
.[.]* {err++;return ERROR}
%%
char *const nombres[]={"ERROR","IF","ELSE","FOR","WHILE","DOUBLE","INT","STRING","NEW","PUBLIC","CLASS","STATIC","VOID",
"Op-mult","Op-sum","Op-sust","Op-div","Op-asing","Op-mod","Op-masMas","Op-menosMenos","Op-sumAsig","Op-menAsig",
"Op-mulAsig","Op-divAsig","Llave-a","Llave-c", "Punto-coma","Parent-a","Parent-c","Corchete-a","Corchete-c","Cte-entera",
"Cte-real","Cte-cadena","Id","Igual","Op-Men-igual","Op-May-igual","Op-Diferente","Op-Mayor","Op-Menor","Op-y","Op-o",
"Op-no","CHAR","Comentario","Arreglo"};

int yywrap(){
	return 1;
}
int main(){
  fichero = fopen("salida.txt", "w");
  int token, i= 0, linea=0;
  token = yylex();
  char *ids[10000];
  char *errores[10000];
  int linErr[10000];    
  while(token){ 
    if(token == 47){
      errores[err]=strdup(yytext);
      linErr[err]=yylinea+1;
    }else{
      if(linea != yylinea){//guarda salto de linea cuando detecta otra linea
        fputs("\n", fichero);
      }
      if((token>=1 & token<=12) || token==45){//palabras clave
        fprintf(fichero,"%s ",nombres[token]);
      }else{
        fprintf(fichero,"%s= %s ",nombres[token],yytext);          
        if( token == 35){//ID
          if(buscar(yytext,ids,i)==0){         
            ids[i]=strdup(yytext);
            i++;          
          }      	                  
        }
      }
    }
    linea=yylinea;     
    token = yylex();    
  }
  fprintf(fichero,"\n \n \n \nTABLA DE IDENTIFICADORES \nHay %d identificadores \n",i);
  for (int j=0; j<i;j++){
    fprintf(fichero,"id= %s; ",ids[j]);        
  }

  fprintf(fichero,"\n \n \n \nListado de errores \nHay %d identificadores \n",err);
   for (int j=1; j<=err;j++){
    fprintf(fichero,"\t [linea %d] Error: No se pudo reconocer ►%s◄ como un componente lexico valido.\n",linErr[j],errores[j]);       
  }
  return 0;   
  fclose(fichero);
}
int buscar(char *const yytext,char *const ids[],int i){  
  for (int k=0; k<i; k++){    
    if (strcmp( strdup(yytext),ids[k])==0){
      return 1;
    }
  }
  return 0;
}

//arreglos de cualquier dim (ya defini los arreglos),  cadenas en asignacion
//mejorar expresion regular de los arreglos
//SIMBOLOS RAROS ENTRE VARIABLES
//simbolos raros seguidos
//simbolos entre numeros

//comentarios multilinea juntos



