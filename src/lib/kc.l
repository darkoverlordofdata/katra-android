/*
#+--------------------------------------------------------------------+
# kc.l
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
#   Katrac JISON Lexer
#
#       Maps patterns to tokens
#
*/

/*
#   Define some RegExp patterns
#
*/
Char                    [.\n]
Digit                   [0-9]
Letter                  [A-Za-z]
AlphaNum                [A-Za-z0-9]

Identifier              {Letter}{AlphaNum}?
Var                     {Identifier}[$%]?
Integer                 {Digit}+
Number                  {Digit}*"."{Digit}+
String                  \"[^"]*\"
Filename                \'[A-Za-z][A-Za-z0-9\/_-]+\'
FuncID                  [Ff][Nn]{Letter}




%%
/*
#+--------------------------------------------------------------------+
# Match                 Token
#+--------------------------------------------------------------------+
#
#   Delimeters & Operators
#
*/
\n                      return 'NEWLINE';
[\t ]+                  /* skip whitespace */;
"*"                     return '*';
"/"                     return '/';
"-"                     return '-';
"+"                     return '+';
"^"                     return '^';
"=="                    return 'EQ';
"="                     return '=';
"<>"                    return 'NE';
"<="                    return 'LE';
">="                    return 'GE';
"<"                     return '<';
">"                     return '>';
"AND"                   return 'AND';
"OR"                    return 'OR';
"NOT"                   return 'NOT';
"and"                   return 'AND';
"or"                    return 'OR';
"not"                   return 'NOT';
"("                     return '(';
")"                     return ')';
"["                     return '[';
"]"                     return ']';
","                     return ',';
":"                     return ':';
";"                     return ';';
/*
#
#   Built-Ins
#
*/
"ABS"                   return 'ABS';
"ATN"                   return 'ATN';
"COS"                   return 'COS';
"EXP"                   return 'EXP';
"INT"                   return 'INT';
"LOG"                   return 'LOG';
"RND"                   return 'RND';
"SGN"                   return 'SGN';
"SIN"                   return 'SIN';
"SQR"                   return 'SQR';
"SUBSTR"                return 'SUBSTR';
"TAB"                   return 'TAB';
"TAN"                   return 'TAN';
"TIM"                   return 'TIM';

"abs"                   return 'ABS';
"atn"                   return 'ATN';
"cos"                   return 'COS';
"exp"                   return 'EXP';
"int"                   return 'INT';
"log"                   return 'LOG';
"rnd"                   return 'RND';
"sgn"                   return 'SGN';
"sin"                   return 'SIN';
"sqr"                   return 'SQR';
"substr"                return 'SUBSTR';
"tab"                   return 'TAB';
"tan"                   return 'TAN';
"tim"                   return 'TIM';

/*
#
#   Basic Keywords
#
*/
"CLS"                   return 'CLS';
"DEL"                   return 'DEL';
"GET"                   return 'GET';
"LIST"                  return 'LIST';
"RUN"                   return 'RUN';
"SAVE"                  return 'SAVE';
"SCR"                   return 'SCR';
"BASE"                  return 'BASE';
"DATA"                  return 'DATA';
"DEF"                   return 'DEF';
"DIM"                   return 'DIM';
"END"                   return 'END';
/*
"FND"                   return 'FND';
*/
"FOR"                   return 'FOR';
"GO"                    return 'GO';
"GOSUB"                 return 'GOSUB';
"GOTO"                  return 'GOTO';
"IF"                    return 'IF';
"IMAGE"                 return 'IMAGE';
"INPUT"                 return 'INPUT';
"LET"                   return 'LET';
"MAT"                   return 'MAT'
"NEXT"                  return 'NEXT';
"OF"                    return 'OF';
"OFF"                   return 'OFF';
"ON"                    return 'ON';
"PRINT"                 return 'PRINT';
"PURGE"                 return 'PURGE';
"QUIT"                  return 'QUIT';
"RANDOMIZE"             return 'RANDOMIZE';
"REM".*                 return 'REM';
"READ"                  return 'READ';
"RESTORE"               return 'RESTORE';
"RETURN"                return 'RETURN'
"STEP"                  return 'STEP';
"STOP"                  return 'STOP';
"THEN"                  return 'THEN';
"TO"                    return 'TO';
"TRACE"                 return 'TRACE'
"USING"                 return 'USING';
"ZER"                   return 'ZER';

"cls"                   return 'CLS';
"del"                   return 'DEL';
"get"                   return 'GET';
"list"                  return 'LIST';
"run"                   return 'RUN';
"save"                  return 'SAVE';
"scr"                   return 'SCR';
"base"                  return 'BASE';
"data"                  return 'DATA';
"def"                   return 'DEF';
"dim"                   return 'DIM';
"end"                   return 'END';
/*
"fnd"                   return 'FND';
*/
"for"                   return 'FOR';
"go"                    return 'GO';
"gosub"                 return 'GOSUB';
"goto"                  return 'GOTO';
"if"                    return 'IF';
"image"                 return 'IMAGE';
"input"                 return 'INPUT';
"let"                   return 'LET';
"mat"                   return 'MAT'
"next"                  return 'NEXT';
"of"                    return 'OF';
"off"                   return 'OFF';
"on"                    return 'ON';
"print"                 return 'PRINT';
"purge"                 return 'PURGE';
"quit"                  return 'QUIT';
"randomize"             return 'RANDOMIZE';
"rem".*                 return 'REM';
"read"                  return 'READ';
"return"                return 'RETURN';
"restore"               return 'RESTORE';
"step"                  return 'STEP';
"stop"                  return 'STOP';
"then"                  return 'THEN';
"to"                    return 'TO';
"trace"                 return 'TRACE';
"using"                 return 'USING';
"zer"                   return 'ZER';

/*
#
#   Identifiers
#
#       - these must be at end of the list
#
*/
{Number}                return 'NUMBER';
{Integer}               return 'INTEGER';
{String}                return 'STRING';
{Filename}              return 'FILE';
{FuncID}                return 'FND';
{Var}                   return 'VAR';


/*
#
#   That's All, Folks!
#
*/
<<EOF>>                 return 'EOF';
.                       return 'INVALID';
