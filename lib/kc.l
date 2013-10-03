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
Letter                  [A-Z]
AlphaNum                [A-Z0-9]

Identifier              {Letter}{AlphaNum}?
Var                     {Identifier}[$%]?
Integer                 {Digit}+
Number                  {Digit}*"."{Digit}+
String                  \"[^"]*\"
Filename                \'[A-Za-z][A-Za-z0-9_-]+\'

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
"FND"                   return 'FND';
"FOR"                   return 'FOR';
"GOSUB"                 return 'GOSUB';
"GOTO"                  return 'GOTO';
"IF"                    return 'IF';
"IMAGE"                 return 'IMAGE';
"INPUT"                 return 'INPUT';
"LET"                   return 'LET';
"MAT"                   return 'MAT'
"NEXT"                  return 'NEXT';
"OF"                    return 'OF';
"PRINT"                 return 'PRINT';
"PURGE"                 return 'PURGE';
"RANDOMIZE"             return 'RANDOMIZE';
"REM".*                 return 'REM';
"READ"                  return 'READ';
"RETURN"                return 'RETURN'
"STOP"                  return 'STOP';
"THEN"                  return 'THEN';
"TO"                    return 'TO';
"USING"                 return 'USING';
"ZER"                   return 'ZER';
"CON"                   return 'CON';
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
{Var}                   return 'VAR';

/*
#
#   That's All, Folks!
#
*/
<<EOF>>                 return 'EOF';
.                       return 'INVALID';
