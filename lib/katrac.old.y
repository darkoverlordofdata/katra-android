/*
#+--------------------------------------------------------------------+
# katrac.y
#+--------------------------------------------------------------------+
# Copyright DarkOverlordOfData (c) 2013
#+--------------------------------------------------------------------+
#
# This file is a part of Katrac
#
# Katrac is free software; you can copy, modify, and distribute
# it under the terms of the MIT License
#
#+--------------------------------------------------------------------+
#
#   Katrac JISON Gtammer
#
#       Maps grammer rules to the runtime ast
#
#
#   To generate katrac.js:
#
#       jison katrac.y katrac.l
#
#   The file katrac.y references the Ast object in krt.coffee
#   To use:
#
#       <script type='text/javascript' src='/js/katrac.js'></script>
#       <script type='text/coffeescript' src='/js/krt.coffee'></script>
#
*/


%left OR
%left AND
%left '=' NE '<' '>' LE GE
%left NOT
%left '+' '-'
%left '*' '/'
%left '^'
%left UMINUS
%nonassoc ','
%nonassoc ';'

%token INTEGER NUMBER STRING
%token DEL GET LIST RUN SAVE SCR
%token BASE DATA DEF DIM FND IMAGE
%token END FOR GOSUB GOTO IF NEXT OF RETURN STOP THEN TO
%token INPUT LET MAT PRINT RANDOMIZE READ USING
%token REM
%token ABS ATN COS EXP INT LOG RND SGN SIN SQR SUBSTR TAB TAN TIM
%token '(' ')'
%token '[' ']'
%token ':'

%options case-insensitive

%start Program
%%
/*
#+--------------------------------------------------------------------+
#     Rule                                  AST
#+--------------------------------------------------------------------+
#
#   Program structure
#
*/
Program
    : Program Line EOF
    | Program Line NEWLINE
    | Line EOF
    | Line NEWLINE
    ;

Line
    : INTEGER Statement             -> new krt.Statement($1, $2)
    | Statement                     -> new krt.Statement($1)
    | Command                       -> new krt.Statement($1)
    ;

/*
#
#   REPL> only commands
#
*/
Command
    : CLS                               -> krt.cls()
    | DEL                               -> krt.del()
    | DEL INTEGER                       -> krt.del($2)
    | DEL INTEGER ',' INTEGER           -> krt.del($2, $4)
    | INTEGER                           -> krt.del($1)
    | GET FILE                          -> krt.get($2)
    | LIST                              -> krt.list()
    | LIST INTEGER                      -> krt.list($2)
    | LIST INTEGER ',' INTEGER          -> krt.list($2, $4)
    | PURGE FILE                        -> krt.purge($2)
    | RUN                               -> krt.run()
    | SAVE FILE                         -> krt.save($2)
    | SCR                               -> krt.scr()
    ;

/*
#
#   Each statement in a program
#
*/
Statement
    : BASE '(' INTEGER ')'              -> new krt.Base($3)
    | DATA ConstantList                 -> new krt.Data($2)
    | DEF FND '(' VAR ')' '=' Expression
                                        -> new krt.Def($2, $4, $7)
    | DIM DimList                       -> new krt.Dim($2)
    | END                               -> new krt.End()
    | FOR VAR '=' Expression TO Expression
                                        -> new krt.For($2, $4, $6)
    | FOR VAR '=' Expression TO Expression STEP INTEGER
                                        -> new krt.For($2, $4, $6, $8)
    | GOTO INTEGER                      -> new krt.Goto($2)
    | GOTO Expression OF IntegerList    -> new krt.Goto($2, $4)
    | GOSUB INTEGER                     -> new krt.Gosub($2)
    | IF Condition THEN INTEGER         -> new krt.If($2, $4)
    | IMAGE ImageList                   -> new krt.Image($2)
    | INPUT VarList                     -> new krt.Input($2)
    | INPUT STRING ',' VarList          -> new krt.Input($4, $2)
    | LET LetList Expression            -> new krt.Let($2, $3)
    | LetList Expression                -> new krt.Let($1, $2)
    | MAT VAR '=' ZER                   -> new krt.Mat(new krt.Var($2), krt.Zer)
    | MAT VAR '=' CON                   -> new krt.Mat(new krt.Var($2), krt.Con)
    | NEXT VAR                          -> new krt.Next(new krt.Var($2))
    | PRINT                             -> new krt.Print()
    | PRINT PrintList                   -> new krt.Print($2)
    | PRINT PrintList PrintSep          -> new krt.Print($2, $3)
    | PRINT USING INTEGER SEMICOLON VarList
                                        -> new krt.Using($3, $5)
    | RANDOMIZE                         -> new krt.Randomize()
    | READ VarList                      -> new krt.Read($2)
    | RETURN                            -> new krt.Return()
    | REM                               -> new krt.Rem($1)
    | STOP                              -> new krt.Stop()
    ;

/*
#
#   Expressions
#
*/
Condition
    : CondAnd OR Expression                 -> new krt.Or($1, $3)
    | CondAnd                               -> $1
    ;

CondAnd
    : CondNot AND CondAnd                   -> new krt.And($1, $3)
    | CondNot                               -> $1
    ;

CondNot     
    : NOT CondCmp                           -> new krt.Not($2)
    | CondCmp                               -> $1
    ;

CondCmp 
    : Expression '=' CondCmp                -> new krt.EQ($1, $3)
    | Expression NE  CondCmp                -> new krt.NE($1, $3)
    | Expression '>' CondCmp                -> new krt.GT($1, $3)
    | Expression GE  CondCmp                -> new krt.GE($1, $3)
    | Expression '<' CondCmp                -> new krt.LT($1, $3)
    | Expression LE  CondCmp                -> new krt.LE($1, $3)
    | Expression                            -> $1
    ;

Expression     
    : ExpMul '+' Expression                 -> new krt.Add($1, $3)
    | ExpMul '-' Expression                 -> new krt.Sub($1, $3)
    | ExpMul                                -> $1
    ;

ExpMul    
    : ExpNeg '*' ExpMul                     -> new krt.Mul($1, $3)
    | ExpNeg '/' ExpMul                     -> new krt.Div($1, $3)
    | ExpNeg                                -> $1
    ;

ExpNeg
    : '-' ExpPow                            -> -$2
    | ExpPow                                -> $1
    ;

ExpPow
    : ExpPow '^' ExpSub                     -> new krt.Pow($1, $3)
    | ExpSub                                -> $1
    ;

ExpSub
    : '(' Expression ')'                    -> $2
    | Value                                 -> $1
    ;

Value
    : VAR                                   -> new krt.Var($1)
    | VAR '[' ExpressionList ']'            -> new krt.Var($1, $3)
    | FND '(' Expression ')'                -> new krt.Udf($1, $3)
    | ABS '(' Expression ')'                -> new krt.ABS($3)
    | ATN '(' Expression ')'                -> new krt.ATN($3)
    | COS '(' Expression ')'                -> new krt.COS($3)
    | EXP '(' Expression ')'                -> new krt.EXP($3)
    | INT '(' Expression ')'                -> new krt.INT($3)
    | LEN '(' Expression ')'                -> new krt.LEN($3)
    | LIN '(' Expression ')'                -> new krt.LIN($3)
    | LOG '(' Expression ')'                -> new krt.LOG($3)
    | RND '(' Expression ')'                -> new krt.RND($3)
    | SGN '(' Expression ')'                -> new krt.SGN($3)
    | SIN '(' Expression ')'                -> new krt.SIN($3)
    | SPA '(' Expression ')'                -> new krt.SPA($3)
    | SQR '(' Expression ')'                -> new krt.SQR($3)
    | SUBSTR '(' Expression ',' Expression ',' Expression ')'
                                            -> new krt.SUBSTR($3, $5, $7)
    | TAB '(' Expression ')'                -> new krt.TAB($3)
    | TAN '(' Expression ')'                -> new krt.TAN($3)
    | TIM '(' Expression ')'                -> new krt.TIM($3)
    | INTEGER                               -> new krt.Const(parseInt($1))
    | NUMBER                                -> new krt.Const(Number($1))
    | STRING                                -> new krt.Const($1)
    ;

Constant
    : INTEGER                               -> new krt.Const(parseInt($1))
    | STRING                                -> new krt.Const($1)
    | NUMBER                                -> new krt.Const(Number($1))
    ;

/*
#
#   Dim arrays
#
*/
DimList
    : Dim                                       -> [$1]
    | DimList ',' Dim                           -> [$1, $3]
    ;

Dim
    : VAR '[' IntegerList ']'                   -> new krt.Var($1, $2, $3)
    | VAR '(' IntegerList ')'                   -> new krt.Var($1, $2, $3)
    ;

/*
#
#   Simple lists
#
*/
LetList
    : VAR '='                                   -> [$1]
    | VAR '[' ExpressionList ']' '='            -> [new krt.Var($1, $2, $3)]
    | LetList VAR '='                           -> [$1, $2]
    | LetList VAR '[' ExpressionList ']' '='    -> [$1, new krt.Var($2, $3, $4)]
    ;

ConstantList
    : Constant                                  -> [$1]
    | ConstantList ',' Constant                 -> [$1, $3]
    ;

IntegerList
    : INTEGER                                   -> [$1]
    | IntegerList ',' INTEGER                   -> [$1, $3]
    ;

ExpressionList
    : Expression                                -> [$1]
    | ExpressionList ',' Expression             -> [$1, $3]
    ;

VarList
    : VAR                                       -> [$1]
    | VarList ',' VAR                           -> [$1, $3]
    ;

PrintList
    : Expression                                -> [$1]
    | PrintList PrintSep Expression             -> [$1, $2, $3]
    ;

PrintSep
    : '~'                                            -> ['']
    | ','                                       -> [$1]
    | ';'                                       -> [$1]
    ;

/*
#
#   Image lists
#
*/
ImageList
    : ImageItem
    | ImageList ',' ImageItem
    ;

ImageItem
    : STRING
    | ImageMask
    ;

ImageMask
    : ImageMaskItem
    | INTEGER '(' ImageList ')'
    ;

ImageMaskItem
    : 'A'
    | 'D'
    | 'X'
    | INTEGER 'A'
    | INTEGER 'D'
    | INTEGER 'X'
    ;


