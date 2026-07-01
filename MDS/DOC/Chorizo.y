%token identifier
%token constant
%token string_constant
%%

chorizo_specification
	:
	  opcode_field_section
	  storage_section
	  cpu_state_section
	  instructions_section
	  commands_section
	;


opcode_field_section 
	: "Opcode" "Fields" '{' opcode_definition_list '}'
	| /* BD3: make this section optional */
	;

opcode_definition_list
	: opcode_definition 
	| opcode_definition_list opcode_definition
	;

opcode_definition
	: identifier constant ';'
	| identifier constant "fixed" ';'
	;


storage_section
	: "Storage" '{' storage_type_definition_list '}'
	| /* BD3: make this section optional */
	;

storage_type_definition_list
	: storage_type_or_extern_definition 
	| opcode_definition_list storage_type_or_extern_definition
	;

storage_type_or_extern_definition
	: extern_definition_list
	| storage_type_definition
	;

extern_definition_list
	: "extern" identifier_list ';'
	;

identifier_list
	: identifier
	| identifier_list ',' identifier
	;

storage_type_definition
	: storage_type method_list ";;"
	| storage_type "default" method_list ";;"
	;

storage_type
	: identifier
	| identifier '(' "@i" ')'
	;

method_list
	: method
	| method_list method
	;

method
	: "Read" C_expression ';'
	| "Write" C_expression ';'
	| "Write" "value" C_expression ';'
	| "GenRead" C_expression ';'
	| "GenWrite" C_expression ';'
	;


cpu_state_section
	: "CPU" "state" '{' variable_definition_list '}'
	| /* BD3: make this section optional */
	;

variable_definition_list
	: variable_or_extern_definition 
	| variable_definition_list variable_or_extern_definition
	;

variable_or_extern_definition
	: extern_definition_list
	| same_type_variable_definition_list
	;

same_type_variable_definition_list
	: storage_type type complex_identifier_list ';'
	| type complex_identifier_list ';'
	;

type
	: "char"
	| "uchar"
	| "short"
	| "ushort"
	| "int"
	| "uint"
	| "float"
	| "double"
	;

complex_identifier_list
	: complex_identifier
	| complex_identifier_list ',' complex_identifier
	;

complex_identifier
	: identifier
	| identifier '(' C_expression ')'
	| identifier '[' C_expression ']'
	| identifier '[' C_expression ']' '(' C_expression ')'
	;	


instructions_section
	: "Instructions" '{' instruction_list '}'
	| /* BD3: make this section optional */
	;

instruction_list
	: instruction 
	| instruction_list instruction
	;

instruction
	: identifier attribute_list debug_list definition extracodes ";;"
	;

attribute_list
	: "default" simple_attribute_list
	| simple_attribute_list
	;

simple_attribute_list
	: attribute
	| simple_attribute_list attribute
	;

attribute
	: attribute_name constant
	;

attribute_name
	: "jitinfo"
	| "pipeinfo"
	;

debug_list
	:
	| "debug" literal_list ';'
	;

literal_list
	: literal_definition
	| literal_list literal_definition
	;

literal_definition
	: string_constant
	| "literal" string_constant
	;

definition
	: "coded" "as" opcode_use_list ';' C_statement
	;

opcode_use_list
	: opcode_use
	| opcode_use_list '+' opcode_use
	;

opcode_use
	: identifier '=' constant
	| identifier '~' identifier
	;

extracodes
	: extracode
	| extracodes extracode
	;

extracode
	: "emulcode" C_statement
	| "jitcode" C_statement
	| "override" "jit" C_statement
	| "override" "emulator" C_statement
	;


C_expression
	: assignment_expr
	| C_expression ',' assignment_expr
	;

assignment_expr
	: conditional_expr
	| unary_expr '=' assignment_expr
	| unary_expr "*=" assignment_expr
	| unary_expr "/=" assignment_expr
	| unary_expr "%=" assignment_expr
	| unary_expr "+=" assignment_expr
	| unary_expr "-=" assignment_expr
	| unary_expr "<<=" assignment_expr
	| unary_expr ">>=" assignment_expr
	| unary_expr "^=" assignment_expr
	| unary_expr "|=" assignment_expr
	| unary_expr "&=" assignment_expr
	;

conditional_expr
	: logical_or_expr
	| logical_or_expr '?' logical_or_expr ':' conditional_expr
	;

logical_or_expr
	: logical_and_expr
	| logical_or_expr "||" logical_and_expr
	;

logical_and_expr
	: inclusive_or_expr
	| logical_and_expr "&&" inclusive_or_expr
	;

inclusive_or_expr
	: exclusive_or_expr
	| inclusive_or_expr '|' exclusive_or_expr
	;

exclusive_or_expr
	: and_expr
	| exclusive_or_expr '^' and_expr
	;

and_expr
	: equality_expr
	| and_expr '&' equality_expr
	;

equality_expr
	: relational_expr
	| equality_expr "==" relational_expr
	| equality_expr "!=" relational_expr
	;

relational_expr
	: shift_expr
	| relational_expr '<' shift_expr
	| relational_expr '>' shift_expr
	| relational_expr "<=" shift_expr
	| relational_expr ">=" shift_expr
	;

shift_expr
	: additive_expr
	| shift_expr "<<" additive_expr
	| shift_expr ">>" additive_expr
	;

additive_expr
	: multiplicative_expr
	| additive_expr '+' multiplicative_expr
	| additive_expr '-' multiplicative_expr
	;

multiplicative_expr
	: cast_expr
	| multiplicative_expr '*' cast_expr
	| multiplicative_expr '/' cast_expr
	| multiplicative_expr '%' cast_expr
	;

cast_expr
	: unary_expr
	| '(' "char" ')' cast_expr
	| '(' "uchar" ')' cast_expr
	| '(' "short" ')' cast_expr
	| '(' "ushort" ')' cast_expr
	| '(' "int" ')' cast_expr
	| '(' "uint" ')' cast_expr
	| '(' "float" ')' cast_expr
	| '(' "double" ')' cast_expr
	;

unary_expr
	: postfix_expr
	| "++" unary_expr
	| "--" unary_expr
	| '&' cast_expr
	| '*' cast_expr
	| '+' cast_expr
	| '-' cast_expr
	| '~' cast_expr
	| '!' cast_expr
	;

argument_expr_list
	: assignment_expr
	| argument_expr_list ',' assignment_expr
	;

postfix_expr
	: primary_expr
	| postfix_expr '[' C_expression ']'
	| postfix_expr '(' ')'
	| postfix_expr '(' argument_expr_list ')'
	| postfix_expr "++"
	| postfix_expr "--"
	;

primary_expr
	: identifier
	| constant
	| "@p"
	| "@n"
	| "@i"
	| "@v"
	| "@a"
	| "@s"
	| '(' C_expression ')'
	;


C_statement
	: compound_statement
	| expression_statement
	| selection_statement
	| jump_statement
	| labeled_statement 
	;

labeled_statement
	: identifier ':' C_statement
	;

compound_statement
	: '{' '}'
	| '{' variable_definition_list '}'
	| '{' statement_list '}'
	| '{' variable_definition_list statement_list '}'
	;

statement_list
	: C_statement
	| statement_list C_statement
	;

expression_statement
	: ';'
	| C_expression ';'
	;


selection_statement
	: "if" '(' C_expression ')' C_statement
	| "if" '(' C_expression ')' C_statement "else" C_statement
	;

jump_statement
	: "return" ';'
	| "return" C_expression ';'
	| "goto" identifier ';'
	;


commands_section
	: "Commands"  command_list
	| /* BD3: make this section optional */
	;

command_list
	: command 
	| command_list command
	;

command
	: return_command
	| printinstructions_command
	| printjitfunctions_command
	| printindextable_command
	| printfunctiontable_command
	| printjitfunctiontable_command
	| printstatictables_command
	| printglobal_command
	| debugglobal_command
	;

return_command
	: "return"
	;

printinstructions_command
	: "PrintInstructions" prologue_epilogue_list file ';'
	;

prologue_epilogue_list
	: 
	| prologue_epilogue
	| prologue_epilogue_list prologue_epilogue
	;

prologue_epilogue
	: "prologue" C_statement 
	| "epilogue" C_statement
	;

file
	: string_constant
	;

printjitfunctions_command
	: "PrintJitFunctions" '(' storage_list ';' storage_list ')' 
			prologue_epilogue_list file ';'
	;

storage_list
	:
	| storage_name
	| storage_list ',' storage_name 
	;

storage_name
	: identifier
	;

printindextable_command
	: "PrintIndexTable" file ';'
	;

printfunctiontable_command
	: "PrintFunctionTable" file ';'
	;

printjitfunctiontable_command
	: "PrintJitFunctionTable" file ';'
	;

printstatictables_command
	: "PrintStaticTables" file ';'
	;

printglobal_command
	: "PrintGlobal" file ';'
	;

debugglobal_command
	: "DebugGlobal" file ';'
	;

%%

