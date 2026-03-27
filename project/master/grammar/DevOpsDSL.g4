grammar DevOpsDSL;

// ===== PARSER RULES =====

program: statement* EOF;

statement
    : nodeCommand
    | groupCommand
    | deployCommand
    | rule
    | parallelBlock
    ;

nodeCommand
    : ID '.' 'run' '(' STRING ')'
    ;

groupCommand
    : ID '.' 'update' '(' ')'
    ;

deployCommand
    : 'deploy' ID 'to' ID
    ;

rule
    : condition ARROW action
    ;

condition
    : ID '.' ID comparator NUMBER
    ;

action
    : ID '(' ')'
    | ID '.' 'run' '(' STRING ')'
    ;

parallelBlock
    : 'parallel' '{' statement+ '}'
    ;

// ===== LEXER RULES =====

ARROW: '->';

comparator
    : '>' | '<' | '==' | '>=' | '<='
    ;

ID: [a-zA-Z_][a-zA-Z0-9_]*;
STRING: '"' .*? '"';
NUMBER: [0-9]+;

WS: [ \t\r\n]+ -> skip;