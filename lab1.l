%{
	#define LE 0
	#define LT 1
	#define EQ 2
	#define NE 3
	#define GT 4
	#define GE 5
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	int installNum();
	int installID();
	static int cnt = 0;
	static struct Node* head = NULL;
	struct Node{
		int idx;
		char name[10];
		struct Node* next;	
	};
	static int cnt2 = 0;
	int NumAry[1000];
	int yylval;
	
%}

delim [\t\n]
ws {delim}+
letter [A-Za-z]
digit [0-9]
id {letter}({letter}|{digit})*
number {digit}+(\.{digit}+)?(E[+-]?{digit}+)?

%%

{ws}	 {/* */}
if		 {printf("<IF>");}
then	 {printf("<THEN>");}
else	 {printf("<ELSE>");}
{id}	 {yylval = installID(); printf("<%s , %d>", yytext,  yylval);}
{number} {yylval = installNum(); printf("<%s, %d>", yytext,  yylval);}
"<"		 {yylval = LT; printf("<RELOP, LT");}
"<="	 {yylval = LE; printf("<RELOP, LE>");}
"="		 {yylval = EQ; printf("<RELOP, EQ>");}
"<>"	 {yylval = NE; printf("<RELOP, NE>");}
">"		 {yylval = GT; printf("<RELOP, GT>");}
">="	 {yylval = GE; printf("<RELOP, GE>");}

%%

int installID(){
	if(head == NULL){
		struct Node* newNode = (struct Node*)malloc(sizeof(struct Node));
		cnt++;
		newNode->idx = cnt;
		strcpy(newNode->name, yytext);
		newNode->next = NULL;
		head = newNode;
		return cnt;
	}
	else{
		int index = 1;
		struct Node* prev = head;
		struct Node* temp = head;
		while(temp != NULL){
			if(strcmp(temp->name, yytext) == 0){
				return temp->idx;
			}
			index++;
			prev = temp;
			temp = temp->next;
		}
		struct Node* newNode = (struct Node*)malloc(sizeof(struct Node));
		cnt++;
		newNode->idx = cnt;
		strcpy(newNode->name, yytext);
		newNode->next = NULL;
		prev->next = newNode;		
		return newNode->idx;
	}	
}

int installNum(){
	int i = 0;
	for(; i < cnt2; i++){
		if(NumAry[i] == *(yytext)){
			return i;
		}
	}
	NumAry[++cnt2] = *(yytext);
	return cnt2;
}

int yywrap(void){

}

int main(void){
	yylex();
	return 0;
}