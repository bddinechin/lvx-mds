%token INTNUM SYMNUM IDENT PROXY
%token SEQ IF EFFECT STORE COMMIT WRITE BIND THROW MACRO SKIP CANCEL LOAD ACCESS READ PROBE AGGL AGGB
%token UNDEF PROPERTY CONST METHOD APPLY F2I SX ZX SAT SATU CLZ CLS CTZ CBS SWAP ROR ROL
%token SELECT ADD SUB MUL DIV REM MOD SHR SHL AND IOR XOR MIN MAX NOT ABS NEG B2I
%token TRUE FALSE TEST NE EQ GT LE GE LT ANDL IORL XORL NOTL I2B I2F
%token FOR INDEX RANGE
%%

Behavior
	: Command
	;

Command
	: '(' SEQ Commands ')'
	| '(' IF Boolean Command Command ')'
	| '(' THROW '.' Stage '.' Ident Arguments ')'
	| '(' EFFECT '.' Stage '.' Ident Arguments ')'
	| '(' STORE '.' Stage Location BitField ')'
	| '(' STORE '.' Stage Location BitField Mask ')'
	| '(' COMMIT '.' Stage '.' Proxy Integer ')'
	| '(' COMMIT '.' Stage '.' Proxy Integer Mask ')'
	| '(' WRITE '.' Section '.' Variable Integer ')'
	| '(' WRITE '.' Variable Integer ')'
	| '(' BIND '.' Variables Tuple ')'
	| '(' MACRO '.' Ident ')'
        | '(' FOR '.' Variable Sequence Commands ')'
	| '(' SKIP Arguments ')'
	| '(' CANCEL ')'
	;

Commands
	: Command
	| Commands Command
	;

Arguments
	: /* empty */
	| Arguments Integer
	| Arguments Boolean
	;

/* A tuple-valued call, and the only place one may appear: BIND destructures it into
   ordinary Variables at the binding site, so a tuple is never a first-class value and
   nothing downstream needs a tuple type.  Both lists take two or more, so a one-tuple
   cannot be spelled -- that is a WRITE of an APPLY -- and neither list can be confused
   with the single-valued forms above.  */

Tuple
	: '(' APPLY '.' Widths '.' Ident Arguments Abstract ')'
	;

Widths
	: Width ',' Width
	| Widths ',' Width
	;

Variables
	: Variable ',' Variable
	| Variables ',' Variable
	;

Location
	: '(' AGGL '.' Storage Address Extent ')'
	| '(' AGGB '.' Storage Address Extent ')'
	;

Address
	: Integer
	;

Extent
	: Integer
	;

Mask
	: Integer
	;

Integer
	: '(' UNDEF Abstract ')'
	| '(' METHOD '.' Proxy Abstract ')'
	| '(' CONST '.' Constant Abstract ')'
	| '(' READ '.' Variable Abstract ')'
	| '(' READ '.' Section '.' Variable Abstract ')'
	| '(' INDEX '.' Variable Abstract ')'
	| '(' ACCESS '.' Stage '.' Proxy Abstract ')'
	| '(' PROPERTY '.' Ident '.' Proxy Abstract ')'
	| '(' APPLY '.' Width '.' Ident Arguments Abstract ')'
	| '(' F2I '.' Width BitField Abstract ')'
	| '(' SX '.' Width Integer Abstract ')'
	| '(' ZX '.' Width Integer Abstract ')'
	| '(' SAT '.' Width Integer Abstract ')'
	| '(' SATU '.' Width Integer Abstract ')'
	| '(' CLZ '.' Width Integer Abstract ')'
	| '(' CLS '.' Width Integer Abstract ')'
	| '(' CTZ '.' Width Integer Abstract ')'
	| '(' CBS '.' Width Integer Abstract ')'
	| '(' SWAP '.' Width Integer Abstract ')'
	| '(' ROR '.' Width Integer Integer Abstract ')'
	| '(' ROL '.' Width Integer Integer Abstract ')'
	| '(' SELECT Boolean Integer Integer Abstract ')'
	| '(' ADD Integer Integer Abstract ')'
	| '(' SUB Integer Integer Abstract ')'
	| '(' MUL Integer Integer Abstract ')'
	| '(' DIV Integer Integer Abstract ')'
	| '(' REM Integer Integer Abstract ')'
	| '(' MOD Integer Integer Abstract ')'
	| '(' SHR Integer Integer Abstract ')'
	| '(' SHL Integer Integer Abstract ')'
	| '(' AND Integer Integer Abstract ')'
	| '(' IOR Integer Integer Abstract ')'
	| '(' XOR Integer Integer Abstract ')'
	| '(' MIN Integer Integer Abstract ')'
	| '(' MAX Integer Integer Abstract ')'
	| '(' NOT Integer Abstract ')'
	| '(' NEG Integer Abstract ')'
	| '(' ABS Integer Abstract ')'
	| '(' B2I Boolean Abstract ')'
	;

Boolean
	: '(' TRUE Abstract ')'
	| '(' FALSE Abstract ')'
	| '(' TEST '.' Ident Arguments Abstract ')'
	| '(' NE Integer Integer Abstract ')'
	| '(' EQ Integer Integer Abstract ')'
	| '(' GT Integer Integer Abstract ')'
	| '(' LE Integer Integer Abstract ')'
	| '(' GE Integer Integer Abstract ')'
	| '(' LT Integer Integer Abstract ')'
	| '(' ANDL Boolean Boolean Abstract ')'
	| '(' IORL Boolean Boolean Abstract ')'
	| '(' XORL Boolean Boolean Abstract ')'
	| '(' PROBE '.' Stage Location Abstract ')'
	| '(' NOTL Boolean Abstract ')'
	| '(' I2B Integer Abstract ')'
	;

BitField
	: '(' LOAD '.' Stage Location ')'
	| '(' I2F '.' Width Integer ')'
	;

Abstract
	: /* empty */
	| "(*" Attributes "*)"
	;

Attributes
	: Attribute
	| Attributes ',' Attribute
	;

Attribute
	: IDENT ':' IDENT
	| IDENT ':' Constant
	;

Constant
	: SYMNUM
	| INTNUM
	| Section
	;

Section
	: INTNUM '[' INTNUM ']'
	| INTNUM '[' Integer ']'
	;

Sequence
	: '(' RANGE '.' INTNUM ')'
	| '(' RANGE '.' INTNUM '.' INTNUM ')'
	| '(' RANGE '.' INTNUM '.' INTNUM '.' INTNUM ')'
	;

Storage
	: Ident
	;

Variable
	: Ident
	;

Proxy
	: PROXY
	;

Stage
	: INTNUM
	| Ident
	;

Width
	: INTNUM
	;

Ident
	: IDENT
	;

%%

