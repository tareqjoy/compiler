%{
	#include <stdio.h>
    #include <math.h>
    #include <string.h>

	void yyerror(char *);
	int yylex(void);

    char varname [1000][25];

    float fSym [1000];
    int iSym[1000];
    char cSym[1000];
    char sSym[1000][256];
    int type[1000];

    const int I=0,F=1,C=2,S=3,X=4;

    int dectyp; //for variable decleration

    int dectyp2=0; //for function

    int totalVar=0,xcv[50]={0},path=0; //for if structure

    int iexpr_val; //for switch

    char v1[25], v2[25], v4[25],v5[25]; // for loop
    int v3,v6, op,op2; //for loop

    #define var 180
    #define pi  3.1416

    void createVariable(char str[], void* val, int t){
        int temp=0;

        while(temp<totalVar){
            if(!strcmp(varname[temp], str)){
                printf("Error: '%s' already declared!\n", str);
                return;
            }
            temp++;
        }

        strcpy(varname[totalVar],str);
        if(val!=NULL) {
            if(t==I) {
                iSym[totalVar]=*(int *) val;
            } else if(t==F) {
                fSym[totalVar]=*(float *) val;
            } else if(t==C) {
                cSym[totalVar]=*(char *) val;
            } else {
                strcpy(sSym[totalVar],(char *) val);
            }
        } else{
            iSym[totalVar]=0;
            fSym[totalVar]=0;
            cSym[totalVar]='\0';
            strcpy(sSym[totalVar],"\0");
        }
        printf("Message: '%s' created successfully.\n", str);
        type[totalVar]=t;
        totalVar++;
    }

    void setVariable(char str[], void* val){
        int temp=0;
        while(temp<totalVar){
            if(!strcmp(varname[temp], str)){
                    if(val!=NULL){
                        iSym[temp]=*(int *) val;
                        fSym[temp]=*(float *) val;
                        cSym[temp]=*(char *) val;
                        strcpy(sSym[temp],(char *) val);
                       
                        printf("Message: Value of variable '%s' updated.\n", str);
                    } else{
                        printf("Error: Value of variable '%s' can't be set NULL.\n", str);
                    }
                return;
            }
            temp++;
        }
        printf("Error: Variable '%s' not declared!\n", str);
        return;

    }

    int getIntVariable(char str[]){
        int temp=0;
        while( temp<totalVar){
            if(!strcmp(varname[temp], str)){
                return iSym[temp];
            }
            temp++;
        }
        printf("Error: Variable '%s' not declared!\n", str);
        return 0;
    }

    float getFloatVariable(char str[]){
        int temp=0;
        while( temp<totalVar){
            if(!strcmp(varname[temp], str)){
                return fSym[temp];
            }
            temp++;
        }
        printf("Error: Variable '%s' not declared!\n", str);
        return 0;
    }

    char getCharVariable(char str[]){
        int temp=0;
        while( temp<totalVar){
            if(!strcmp(varname[temp], str)){
                return cSym[temp];
            }
            temp++;
        }
        printf("Error: Variable '%s' not declared!\n", str);
        return 0;
    }

    const char * getStringVariable(char str[]){
        int temp=0;
        while( temp<totalVar){
            if(!strcmp(varname[temp], str)){
                return sSym[temp];
            }
            temp++;
        }
        printf("Error: Variable '%s' not declared!\n", str);
        return "\0";
    }

    void seeVariable(char str[]){
        int temp=0;
        while( temp<totalVar){
            if(!strcmp(varname[temp], str)){
                if(type[temp]==I){
                    printf("Message: Value of variable '%s': %d\n",str,iSym[temp]);
                }else if(type[temp]==F){
                    printf("Message: Value of variable '%s': %f\n",str,fSym[temp]);
                }else if(type[temp]==C){
                    printf("Message: Value of variable '%s': %c\n",str,cSym[temp]);
                }else{
                    printf("Message: Value of variable '%s': %s\n",str,sSym[temp]);
                }
                return;
            }
            temp++;
        }
        printf("Error: Variable %s not declared!\n", str);
        return;
    }
    int operate(){ //0=VGV 1=VLV 2=VGM 3=VLM 4=VEV 5=VEM
        if(op==0){
            return getIntVariable(v1)>getIntVariable(v2);
        } else if(op==1){
            return getIntVariable(v1)<getIntVariable(v2);
        } else if(op==2){
            return getIntVariable(v1)>v3;
        }else if(op==3){
            return getIntVariable(v1)<v3;
        }else if(op==4){
            return getIntVariable(v1)==getIntVariable(v2);
        }else if(op==5){
            return getIntVariable(v1)==v3;
        }
    }
    void secondOperate(){ //0=VVAI 1=VVSI 2=VVII 3=VVDI
        if(op2==0){
            int temp1=getIntVariable(v5)+v6;
            setVariable(v4,&temp1);
        } else if(op2==1){
            int temp1=getIntVariable(v5)-v6;
            setVariable(v4,&temp1);
        }else if(op2==2){
            int temp1=getIntVariable(v5)*v6;
            setVariable(v4,&temp1);
        }else if(op2==3){
            int temp1=getIntVariable(v5)/v6;
            setVariable(v4,&temp1);
        }
    }
%}

%union
{
    char string[25];
    int integer;
    char charVal;
    float floatVal;
    struct allTypes{
        char charVal;
        int integerVal;
        float floatVal;
        char stringVal[256];
        int type;
    } genericData;
}

%token <string> VARIABLE
%token <integer> INTEGER
%token <floatVal> FLOAT
%token <charVal> CHARACTER
%token <string> STRING
%token ADD TYPE_INT TYPE_CHAR TYPE_FLOAT TYPE_STRING SUBSTRACT MINUS INTO DEVIDE POWER MOD IF ELSE ELSEIF START END EQUAL GREATER LESS NEWLINE FACTORIAL SINE COSINE TANGENT LOGARITHM CHECK WITH OUTPUT FOR RETURN

%type <genericData> expression

%left EQUAL GREATER LESS
%left ISLESS ISGREATER ISLESSEQU ISGREATEREQU
%left LOGARITHM
%left SINE COSINE TANGENT
%left ADD SUBSTRACT MINUS
%left INTO DEVIDE
%left MOD
%left FACTORIAL
%left POWER
%left '(' ')'


%nonassoc IFX
%nonassoc ELSE


%%
program: program statement '#' '\n'
            {
                 printf("Message: A statement.\n");
            }
    
	| /* NULL */
 	;
statement:  variable_decleration 
         | expression 
         | VARIABLE '=' expression
                    {
                        if(xcv[path]==0){
                            if($3.type==I){
                                setVariable($1,&$3.integerVal);
                            } else if($3.type==F){
                                setVariable($1,&$3.floatVal);
                            }else if($3.type==C){
                                setVariable($1,&$3.charVal);
                            }else{
                                setVariable($1,&$3.stringVal);
                            }
                        }
                    }
    | if_else
    | OUTPUT '[' STRING ']' {
        if(xcv[path]==0){
            printf("%s\n",$3);
        }    
    }
    | check_stmt
    | loop_stmt
    | function
    | '\n' statement
;
variable_decleration: data_type var var_loop
;

var_loop:  ',' var var_loop | /* NULL */ 
;
var: VARIABLE 
                    {
                        createVariable($1,NULL,dectyp);
                    }
            | VARIABLE '=' INTEGER
                    {
                        createVariable($1,&$3,dectyp);
                    }
            | VARIABLE '=' FLOAT
                    {
                        createVariable($1,&$3,dectyp);
                    }
            | VARIABLE '=' CHARACTER
                    {
                        createVariable($1,&$3,dectyp);
                    }
            | VARIABLE '=' STRING
                    {
                        createVariable($1,&$3,dectyp);
                    }
;
data_type: TYPE_INT {dectyp=I;}
            | TYPE_FLOAT {dectyp=F;}
            | TYPE_CHAR {dectyp=C;}
            | TYPE_STRING {dectyp=S;}
;
expression:  INTEGER { $$.integerVal = $1 ; $$.type=0;}
            | VARIABLE
                    {
                        seeVariable($1);
                        $$.integerVal=getIntVariable($1);
                        $$.floatVal=getFloatVariable($1);
                        $$.charVal=getCharVariable($1);
                        strcpy($$.stringVal,getStringVariable($1));
                    }
            | FLOAT { $$.floatVal = $1 ;  $$.type=1;}
            | CHARACTER { $$.charVal = $1 ;  $$.type=2;}
            | STRING { strcat($$.stringVal, $1) ;  $$.type=3;}
            | SINE '[' expression ']' 
                    {
                        $$.type=$3.type;
                        $$.integerVal = ceil(sin((float)$3.integerVal * pi / var));
                        $$.floatVal = sin($3.floatVal * pi / var);
                        $$.charVal = sin($3.charVal * pi / var);
                        if($3.type==3){
                            printf("Error: Wrong operation.\n");
                        }
                    }
            | COSINE '[' expression ']' 
                    {
                        $$.type=$3.type;
                        $$.integerVal = ceil(cos((float)$3.integerVal * pi / var));
                        $$.floatVal = cos($3.floatVal * pi / var);
                        $$.charVal = cos($3.charVal * pi / var);
                        if($3.type==3){
                            printf("Error: Wrong operation.\n");
                        }
                    }
            | TANGENT '[' expression ']' 
                    {
                        $$.type=$3.type;
                        $$.integerVal = tan((float)$3.integerVal * pi / var);
                        $$.floatVal = tan($3.floatVal * pi / var);
                        $$.charVal = tan($3.charVal * pi / var);
                        if($3.type==3){
                            printf("Error: Wrong operation.\n");
                        }
                    }
            | LOGARITHM '[' expression ']' 
                    {
                        $$.type=$3.type;
                        $$.integerVal = log($3.integerVal);
                        $$.floatVal = log($3.floatVal);
                        $$.charVal = log($3.charVal);
                        if($3.type==3){
                            printf("Error: Wrong operation.\n");
                        }
                    }
            | MINUS expression
                    {
                            $$.type=$2.type;
                            $$.integerVal = - $2.integerVal;
                            $$.floatVal = - $2.floatVal ;
                            $$.charVal = - $2.charVal;
                            if($2.type==3){
                                printf("Error: Wrong operation.\n");
                            }
                    }
            | expression ADD expression
                    {
                        if($1.type == $3.type){
                            $$.type=$1.type;
                            $$.integerVal =  $1.integerVal + $3.integerVal;
                            $$.floatVal =  $1.floatVal + $3.floatVal;
                            $$.charVal =  $1.charVal + $3.charVal;
                            strcpy($$.stringVal, strcat($1.stringVal, $3.stringVal));
                        } else {
                            printf("Error: Data type mismatched.\n");
                        }
                    }
            | expression SUBSTRACT expression
                    {
                        if($1.type == $3.type){
                            $$.type=$1.type;
                            $$.integerVal =  $1.integerVal - $3.integerVal;
                            $$.floatVal =  $1.floatVal - $3.floatVal;
                            $$.charVal =  $1.charVal - $3.charVal;
                            if($1.type==3){
                                printf("Error: Wrong operation.\n");
                            }
                        } else {
                            printf("Error: Data type mismatched.\n");
                        }
                    }
            | expression INTO expression
                    {
                        if($1.type == $3.type){
                            $$.type=$1.type;
                            $$.integerVal =  $1.integerVal * $3.integerVal;
                            $$.floatVal =  $1.floatVal * $3.floatVal;
                            $$.charVal =  $1.charVal * $3.charVal;
                            if($1.type==3){
                                printf("Error: Wrong operation.\n");
                            }
                        } else {
                            printf("Error: Data type mismatched.\n");
                        }
                    }
            | expression MOD expression
                    {
                        if($1.type == $3.type && $1.type==0 ){
                            
                            if($3.integerVal ==0){
                                printf("Error: Wrong operation.\n");
                            } else{
                                $$.type=$1.type;
                                $$.integerVal =  $1.integerVal % $3.integerVal;
                            }
                        } else {
                            printf("Error: Wrong operation.\n");
                        }
                    }
            | expression DEVIDE expression
                    {
                        if($1.type == $3.type){
                            if($1.type==0){
                                if($3.integerVal!=0){
                                    $$.type=$1.type;
                                    $$.integerVal =  $1.integerVal / $3.integerVal;
                                } else{
                                    printf("Error: Wrong operation.\n");
                                }
                            }
                            if($1.type==1){
                                if($3.floatVal!=0){
                                    $$.type=$1.type;
                                    $$.floatVal =  $1.floatVal / $3.floatVal;
                                } else{
                                    printf("Error: Wrong operation.\n");
                                }
                            }
                             if($1.type==2){
                                if($3.charVal!=0){
                                    $$.type=$1.type;
                                    $$.charVal =  $1.charVal / $3.charVal;
                                } else{
                                    printf("Error: Wrong operation.\n");
                                }
                            }
                            if($1.type==3){
                                printf("Error: Wrong operation.\n");
                            }
                        } else {
                            printf("Error: Data type mismatched.\n");
                        }
                    }
            | expression FACTORIAL
                    {
                        if($1.type==0){
                            $$.type=$1.type;
                            int mult=1 ,i;
						    for(i=$1.integerVal;i>0;i--)
						    {
						    	mult=mult*i;
						    }
						    $$.integerVal=mult;
                        } else{
                            printf("Error: Wrong operation.\n");
                        }
                            
                    }
            | expression POWER expression
                    {
                        if($1.type == $3.type){
                            $$.type=$1.type;
                            $$.integerVal = ceil(pow($1.integerVal, $3.integerVal));
                            $$.floatVal =  ceil(pow($1.floatVal, $3.floatVal));
                            $$.charVal =  ceil(pow($1.charVal , $3.charVal));
                            if($1.type==3){
                                printf("Error: Wrong operation.\n");
                            }
                        } else {
                            printf("Error: Data type mismatched.\n");
                        }
                    }
            | '(' expression ')' 
                    {
                        $$ = $2;
                    }
            | expression EQUAL expression
                    {
                        if($1.type == $3.type){
                            $$.type=0;
                            if($1.type==0){
                                $$.integerVal = ($1.integerVal == $3.integerVal);
                            } else if($1.type==1){
                                $$.integerVal = ($1.floatVal == $3.floatVal);
                            } else if($1.type==2){
                                $$.integerVal = ($1.charVal == $3.charVal);
                            } else{
                                $$.integerVal = !strcmp($1.stringVal, $3.stringVal);
                            }  
                        } else {
                            printf("Error: Data type mismatched.\n");
                        }
                    }
            | expression GREATER expression
                    {
                        if($1.type == $3.type){
                            $$.type=0;
                            if($1.type==0){
                                $$.integerVal = ($1.integerVal > $3.integerVal);
                            } else if($1.type==1){
                                $$.integerVal = ($1.floatVal > $3.floatVal);
                            } else if($1.type==2){
                                $$.integerVal = ($1.charVal > $3.charVal);
                            } else{
                                printf("Error: Wrong operation.\n");
                            }  
                        } else {
                            printf("Error: Data type mismatched.\n");
                        }
                    }
            | expression LESS expression
                    { 
                        if($1.type == $3.type){
                            $$.type=0;
                            if($1.type==0){
                                $$.integerVal = ($1.integerVal < $3.integerVal);
                            } else if($1.type==1){
                                $$.integerVal = ($1.floatVal < $3.floatVal);
                            } else if($1.type==2){
                                $$.integerVal = ($1.charVal < $3.charVal);
                            } else{
                                printf("Error: Wrong operation.\n");
                            }  
                        } else {
                            printf("Error: Data type mismatched.\n");
                        }
                    }

;
if_else: IF expression
                {
                    path++;
                    if($2.integerVal && xcv[path-1]==0){
                        xcv[path]=0;
                        
                    } else if(xcv[path]!=-1){
                        xcv[path]=1;
                    }
                } 
                '\n' START '\n' statement_loop else_if_loop %prec IFX
                {
                    xcv[path]=0;
                    path--;  
                }
            
;

else_if_loop: ELSEIF expression
                {
                    if($2.integerVal && xcv[path-1]==0){
                        xcv[path]=0;
                    } else if(xcv[path]!=-1){
                        xcv[path]=1;
                    }
                } 
                '\n' START '\n' statement_loop  else_if_loop 
            | ELSE
            {
                    if(xcv[path]==1  && xcv[path-1]==0){
                        xcv[path]=0;
                    }
            } 
            '\n' START '\n' statement_loop
            |   {
                
                }
;

statement_loop: statement '#' '\n' statement_loop
            |  END '\n' {
                    if(xcv[path]==0 && path!=0){
                        xcv[path]=-1;
                    }
                }
;

check_stmt: CHECK WITH '[' expression 
                {
                    iexpr_val=$4.integerVal;
                    path++;
                } 
                ']' '\n' START '\n' case_loop
                {
                    xcv[path]=0;
                    path--;
                }
;
case_loop:  '[' expression
                {
                   
                    if(iexpr_val==$2.integerVal){
                        xcv[path]=0;
                    } else{
                        xcv[path]=1;
                    }
                } 
                ']' '\n' START '\n' statement_loop case_loop
            | '[' ']' '\n' START
                {
                    if(xcv[path]==1){
                        xcv[path]=0;
                    }
                } 
                '\n' statement_loop END '\n'
            |  END '\n'
;
loop_stmt: FOR VARIABLE '=' INTEGER ',' condition ',' update_condition '\n' START '\n' statement_loop{
             
                if(!xcv[path]){
                    setVariable($2,&$4);
                    int p=0;
                    for(; operate(); secondOperate()){
                      printf("Message: Looping %d\n",p);
                        p++;
                    }
                }
                
            }

;
condition: VARIABLE GREATER VARIABLE {strcpy(v1,$1); strcpy(v2,$3); op=0;}
        | VARIABLE LESS VARIABLE {strcpy(v1,$1); strcpy(v2,$3); op=1;}
        | VARIABLE GREATER INTEGER {strcpy(v1,$1); v3=$3; op=2;}
        | VARIABLE LESS INTEGER {strcpy(v1,$1); v3=$3; op=3;}
        | VARIABLE EQUAL VARIABLE {strcpy(v1,$1); strcpy(v2,$3); op=4;}
        | VARIABLE EQUAL INTEGER {strcpy(v1,$1); v3=$3; op=5;}
    ;
update_condition: VARIABLE '=' VARIABLE ADD INTEGER
        {
            strcpy(v4,$1);
            strcpy(v5,$3);
            v6=$5;
            op2=0;
        }
        | VARIABLE '=' VARIABLE SUBSTRACT INTEGER
        {
            strcpy(v4,$1);
            strcpy(v5,$3);
            v6=$5;
            op2=1;
        }
        | VARIABLE '=' VARIABLE INTO INTEGER
        {
            strcpy(v4,$1);
            strcpy(v5,$3);
            v6=$5;
            op2=2;
        }
        | VARIABLE '=' VARIABLE DEVIDE INTEGER
        {
            strcpy(v4,$1);
            strcpy(v5,$3);
            v6=$5;
            op2=3;
        }
;
function: data_type VARIABLE  '[' params ']' '\n' START '\n' function_statement_loop 
            {
                if(dectyp2==0){
                createVariable($2, NULL, X);
                }
            }
;
params: data_type VARIABLE params_loop
        |
;
params_loop: ',' data_type VARIABLE params_loop
        |
;
function_statement_loop: statement '#' '\n' function_statement_loop
            | RETURN INTEGER '\n'  END '\n' {
                    if(dectyp!=I){
                        dectyp2=1;
                        printf("Error: Return type mismatched!\n");
                    } else{
                        dectyp2=0;
                    }
                }
            | RETURN FLOAT '\n'  END '\n' {
                    if(dectyp!=F){
                        dectyp2=1;
                        printf("Error: Return type mismatched!\n");
                    } else{
                        dectyp2=0;
                    }
                }
            | RETURN CHARACTER '\n'  END '\n' {
                    if(dectyp!=C){
                        dectyp2=1;
                        printf("Error: Return type mismatched!\n");
                    } else{
                        dectyp2=0;
                    }
                }
            | RETURN STRING '\n'  END '\n' {
                    if(dectyp!=S){
                        dectyp2=1;
                        printf("Error: Return type mismatched!\n");
                    } else{
                        dectyp2=0;
                    }
                }
;
%%

void yyerror(char *s)
{
	fprintf(stderr, "%s\n", s);
}

int main(void)
{
    freopen("in2.txt","r",stdin);
//    freopen("out.txt","w",stdout);
    int i;
    for(i=0; i<1000; i++){
            type[i]=-1;
    }
	yyparse();
}