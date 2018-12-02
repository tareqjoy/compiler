%{
	#include "b.tab.h"
	#include <stdlib.h>
	#include <string.h>

	void yyerror(char *);

%}


sLetter [a-z]
cLetter [A-Z]
number [0-9]
space [ ]
include "paste"
int "integer"
string "carray"
float "decimal"
char "character"
if "when"
elseIf "or"
else "nor"
while "while"
return "send"
ps "start"
pe "end"
eq "equal"
nt "not"
gr "greater"
ls "less"
nd "and"
or "or"
es "="
as "+"
ss "-"
ds "/"
ms "x"
xs "^"
mods "//"
fs "<"
fe ">"
eol "."
inc "++"
dec "--"
for "loop"
%%
{int} {
	return TYPE_INT;
}
{float} {
	return TYPE_FLOAT;
}
{char} {
	return TYPE_CHAR;
}
{string} {
	return TYPE_STRING;
}

"add" {
	return ADD;
}

"substract" {
	return SUBSTRACT;
}

"into" {
	return INTO;
}
"devide" {
	return DEVIDE;
}
"power" {
	return POWER;
}
"minus" {
	return MINUS;
}

"mod" {
	return MOD;
}

"factorial" {
	return FACTORIAL;
}

"equal" {
	return EQUAL;
}
"greater" {
	return GREATER;
}
"less" {
	return LESS;
}
"sine" {
	return SINE;
}
"cosine" {
	return COSINE;
}
"tangent" {
	return TANGENT;
}
"logarithm" {
	return LOGARITHM;
}

"check" {
	return CHECK;
}
"with" {
	return WITH;
}
"output" {
	return OUTPUT;
}

{if} {
	return IF;
}

{else} {
	return ELSE;
}
{elseIf} {
	return ELSEIF;
}

{ps} {
	return START;
}

{pe} {
	return END;
}
{for} {
	return FOR;
}
{return} {
	return RETURN;
}

({sLetter}|{cLetter})({sLetter}|{cLetter}|{number})* {
	
	strcpy(yylval.string,yytext);
	return VARIABLE;
	}
[`]({sLetter}|{cLetter})?[`] {
	yylval.charVal = yytext[1];
	if(yytext[1]=='`'){
		yylval.charVal='\0';
	}
	return CHARACTER;
}
[`]({sLetter}|{cLetter}|{number}|[.]|[?]|[!]|[#]|[*]|[(]|[)]|[+]|[-]|[ ])*[`] {
	strcpy(yylval.string, yytext);
	return STRING;
}
{number}*[.]{number}+ {
	yylval.floatVal = atof(yytext);
	return FLOAT;
}

{number}+ {
	yylval.integer = atoi(yytext);
	return INTEGER;
}

[-+()/=*#,\n]	{ return *yytext; }

[ \t]* 	; 	/* skip whitespace */

.	{ return *yytext; }

%%
int yywrap(){
	return 1;
}

