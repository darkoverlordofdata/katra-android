/*
#+--------------------------------------------------------------------+
# kc.y
#+--------------------------------------------------------------------+
# Copyright DarkOverlordOfData (c) 2013
#+--------------------------------------------------------------------+
#
# This file is a part of Katra
#
# Katra is free software; you can copy, modify, and distribute
# it under the terms of the MIT License
#
#+--------------------------------------------------------------------+
#
#   Katra JISON Grammar
#
#       Maps grammar rules to the runtime ast
#
#
#   To use:
#
#       <script type='text/javascript' src='/js/rte.browser.js'></script>
#       <script type='text/javascript' src='/js/kc.bnf.js'></script>
#
*/
%{

    ast = typeof window !== "undefined" && window !== null ? window.katra : ast = require('./katra');
    cmd = ast.command;
    bnf = ast.bnf;


%}


%left OR
%left AND
%left '=' EQ NE '<' '>' LE GE
%left NOT
%left '+' '-'
%left '*' '/'
%left '^'
%left UMINUS

%left ','
%left ';'
%left ':'

%token INTEGER NUMBER STRING
%token DEL GET LIST RUN SAVE SCR
%token BASE DATA DEF DIM FND IMAGE
%token END FOR GOSUB GOTO IF NEXT OF RETURN STEP STOP THEN TO
%token INPUT LET MAT PRINT RANDOMIZE READ USING
%token REM
%token ABS ATN COS EXP INT LOG RND SGN SIN SQR SUBSTR TAB TAN TIM
%token '(' ')'
%token '[' ']'

%options case-insensitive

%start Program
%%
/*
#+--------------------------------------------------------------------+
#     Rule                                  Action
#+--------------------------------------------------------------------+
#
#   Program structure
#
*/
Program
    : Command NEWLINE EOF       -> new ast.Statement($1)
    | GET FILE                  { cmd.get($2); return true;}
    | Lines EOF
    ;


Lines
    : Lines Line NEWLINE
    | Line NEWLINE
    | NEWLINE
    ;

Line
    : Statement                     -> new ast.Statement($1)
    | INTEGER Statement             -> new ast.Statement($2, $1)
    ;

/*
#
#   Commands - only available using REPL
#
*/
Command
    : CLS                               -> cmd.cls()
    | DEL INTEGER ',' INTEGER           -> cmd.del($2, $4)
    | DEL INTEGER                       -> cmd.del($2)
    | DEL                               -> cmd.del()
    | INTEGER                           -> cmd.del($1)
    | LIST INTEGER ',' INTEGER          -> cmd.list($2, $4)
    | LIST INTEGER                      -> cmd.list($2)
    | LIST                              -> cmd.list()
    | PURGE FILE                        -> cmd.purge($2)
    | QUIT                              -> cmd.quit()
    | RUN                               -> cmd.run()
    | SAVE FILE                         -> cmd.save($2)
    | SCR                               -> cmd.scr()
    | TRACE ON                          -> cmd.trace(true)
    | TRACE OFF                         -> cmd.trace(false)
    ;

/*
#
#   Each statement in a program
#
*/
Statement
    : BASE '(' INTEGER ')'              -> new ast.Base($3)
    | DATA ConstantList                 -> new ast.Data($2)
    | DEF FND '(' VAR ')' '=' Expression
                                        -> new ast.Def($2, $4, $7)
    | DIM DimList                       -> new ast.Dim($2)
    | END                               -> new ast.End()
    | FOR VAR '=' Expression TO Expression STEP Expression
                                        -> new ast.For($2, $4, $6, $8)
    | FOR VAR '=' Expression TO Expression
                                        -> new ast.For($2, $4, $6)
    | GO TO INTEGER                     -> new ast.Goto($3)
    | GOTO INTEGER                      -> new ast.Goto($2)
    | GOTO Expression OF IntegerList    -> new ast.Goto($2, $4)
    | GOSUB INTEGER                     -> new ast.Gosub($2)
    | IF Expression THEN INTEGER        -> new ast.If($2, $4)
    | IMAGE ImageList                   -> new ast.Image($2)
    | INPUT VarList                     -> new ast.Input($2)
    | INPUT STRING ',' VarList          -> new ast.Input($4, $2)
    | LET LetList Expression            -> new ast.Let($2, $3)
    | LetList Expression                -> new ast.Let($1, $2)
    | MAT VAR '=' ZER                   -> new ast.Mat(new ast.Var($2), ast.Zer)
    | MAT VAR '=' CON                   -> new ast.Mat(new ast.Var($2), ast.Con)
    | NEXT VAR                          -> new ast.Next(new ast.Var($2))
    | PRINT PrintList PrintSep          -> new ast.Print($2, $3)
    | PRINT PrintList                   -> new ast.Print($2)
    | PRINT                             -> new ast.Print(new ast.Const(''))
    | PRINT USING INTEGER ';' VarList   -> new ast.Using($3, $5)
    | PRINT USING INTEGER               -> new ast.Using($3)
    | RANDOMIZE                         -> new ast.Randomize()
    | READ VarList                      -> new ast.Read($2)
    | RESTORE                           -> new ast.Restore()
    | RETURN                            -> new ast.Return()
    | REM                               -> new ast.Rem($1)
    | STOP                              -> new ast.Stop()
    ;

/*
#
#   Expressions
#
*/
Expression
    : Expression OR  Expression             -> new ast.OR($1, $3)
    | Expression AND Expression             -> new ast.AND($1, $3)
    | NOT Expression                        -> new ast.NOT($2)
    | Expression EQ  Expression             -> new ast.EQ($1, $3)
    | Expression NE  Expression             -> new ast.NE($1, $3)
    | Expression '>' Expression             -> new ast.GT($1, $3)
    | Expression GE  Expression             -> new ast.GE($1, $3)
    | Expression '<' Expression             -> new ast.LT($1, $3)
    | Expression LE  Expression             -> new ast.LE($1, $3)
    | Expression '+' Expression             -> new ast.Add($1, $3)
    | Expression '-' Expression             -> new ast.Sub($1, $3)
    | Expression '*' Expression             -> new ast.Mul($1, $3)
    | Expression '/' Expression             -> new ast.Div($1, $3)
    | Expression '^' Expression             -> new ast.Pow($1, $3)
    | '-' Expression %prec UMINUS           -> -$2
    | '(' Expression ')'                    -> $2
    | VAR                                   -> new ast.Var($1)
    | VAR '[' ExpressionList ']'            -> new ast.Var($1, $2, $3)
    | FND '(' Expression ')'                -> new ast.FN($1, $3)
    | ABS '(' Expression ')'                -> new ast.ABS($3)
    | ATN '(' Expression ')'                -> new ast.ATN($3)
    | COS '(' Expression ')'                -> new ast.COS($3)
    | EXP '(' Expression ')'                -> new ast.EXP($3)
    | INT '(' Expression ')'                -> new ast.INT($3)
    | LEN '(' Expression ')'                -> new ast.LEN($3)
    | LIN '(' Expression ')'                -> new ast.LIN($3)
    | LOG '(' Expression ')'                -> new ast.LOG($3)
    | RND '(' Expression ')'                -> new ast.RND($3)
    | SGN '(' Expression ')'                -> new ast.SGN($3)
    | SIN '(' Expression ')'                -> new ast.SIN($3)
    | SPA '(' Expression ')'                -> new ast.SPA($3)
    | SQR '(' Expression ')'                -> new ast.SQR($3)
    | SUBSTR '(' Expression ',' Expression ',' Expression ')'
                                            -> new ast.SUBSTR($3, $5, $7)
    | TAB '(' Expression ')'                -> new ast.TAB($3)
    | TAN '(' Expression ')'                -> new ast.TAN($3)
    | TIM '(' Expression ')'                -> new ast.TIM($3)
    | Constant                              -> $1
    ;

Constant
    : INTEGER                                   -> new ast.Const(parseInt($1, 10))
    | STRING                                    -> new ast.Const($1)
    | NUMBER                                    -> new ast.Const(Number($1))
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
    : VAR '[' IntegerList ']'                   -> new ast.Var($1, $2, $3)
    | VAR '(' IntegerList ')'                   -> new ast.Var($1, $2, $3)
    ;

/*
#
#   Simple lists
#
*/
LetList
    : VAR '='                                   -> [$1]
    | VAR '[' ExpressionList ']' '='            -> [new ast.Var($1, $2, $3)]
    | LetList VAR '='                           -> [$1, $2]
    | LetList VAR '[' ExpressionList ']' '='    -> [$1, new ast.Var($2, $3, $4)]
    ;

ConstantList
    : Constant                                  -> [$1]
    | ConstantList ',' Constant                 -> [$1, $3]
    ;

IntegerList
    : INTEGER                                   -> [parseInt($1, 10)]
    | IntegerList ',' INTEGER                   -> [$1, parseInt($3, 10)]
    ;

ExpressionList
    : Expression                                -> [$1]
    | ExpressionList ',' Expression             -> [$1, $3]
    ;

VarList
    : VarItem                                   -> [$1]
    | VarList ',' VarItem                       -> [$1, $3]
    ;

VarItem
    : VAR                                       -> new ast.Var($1)
    | VAR '[' ExpressionList ']'                -> new ast.Var($1, $2, $3)
    ;

PrintList
    : Expression                                -> [$1]
    | PrintList PrintSep Expression             -> [$1, $2, $3]
    ;

PrintSep
    : ';'                                       -> ast.Semic
    | ','                                       -> ast.Comma
    ;

/*
#
#   Image lists
#
*/
ImageList
    : ImageItem                                 -> [$1]
    | ImageList ',' ImageItem                   -> [$1, $2, $3]
    ;

ImageItem
    : STRING                                    -> $1
    | ImageMask                                 -> $1
    ;

ImageMask
    : ImageMaskItem                             -> [$1]
    | INTEGER '(' ImageList ')'                 -> [parseInt($1, 10), $2, $3, $4]
    ;

ImageMaskItem
    : VAR                                       -> [$1]
    | INTEGER VAR                               -> [parseInt($1, 10), $2]
    ;


