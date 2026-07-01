%token BINNUM HEXNUM DECNUM SYMNUM IDENT STAGE
%token IF ELSE THROW DbgThrow REPEAT FROM FOR STEP
%token NOT INT OR XOR AND
%%

takumi
	: statements
	;

statements
	: 
	| statements statement
	;

statement
	: STAGE
	| IF '(' expression ')' block_or_statement
	| IF '(' expression ')' block_or_statement ELSE block_or_statement
	| variable '=' expression ';'
	| IDENT '(' opt_arguments ')' ';'
	| THROW '(' IDENT ')' ';'
        | DbgThrow '(' IDENT ')' ';'
        | REPEAT IDENT FROM constant FOR constant block_or_statement
        | REPEAT IDENT FROM constant FOR constant STEP constant
          block_or_statement
	;

block_or_statement
	: statement
	| block
	;

block
	: '{' statements '}'
	;

variable
	: IDENT
	| IDENT '[' expression ']'
	| IDENT '[' expression FOR expression ']'
	;

expression
	: nested_expression
	| nested_expression operator2 nested_expression
	| operator1 nested_expression
	;

nested_expression
	: constant
	| variable
	| IDENT '(' opt_arguments ')'
	| '(' expression ')'
	;

constant
	: DECNUM
	| HEXNUM
	| BINNUM
	| SYMNUM
	;

opt_arguments
	:
	| arguments
	;

arguments
	: argument
	| arguments ',' argument
	;

argument
	: expression
	;

operator1
	: '~'
	| '-'
	| NOT
	| INT
	;

operator2
	: '+'
	| '-'
	| '*'
	| '&'
	| '|'
	| '^'
	| AND
	| OR
	| XOR
	| ">>"
	| "<<"
	| ">="
	| "<="
	| "=="
	| "!="
	| '<'
	| '>'
	;

%%

