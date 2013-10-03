#+--------------------------------------------------------------------+
#| krt.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2013
#+--------------------------------------------------------------------+
#|
#| This file is a part of Katra
#|
#| Katra is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# krt - The Katra Runtime
#


V_INVALID       = -1    # Invalid syntax encountered
V_GENERIC       = 0     # Generic Basic
V_TSB2K         = 1     # HP 2000 Time Share Basic

GOSUB           = 1     # Stack frame identifier: Gosub..Return
FOR             = 2     # Stack frame identifier: For..Next

PHASE_SCAN      = 0     # Processed during scan
PHASE_EXEC      = 1     # Executable statements

MODE_REPL       = 0     # Console REPL mode
MODE_RUN        = 1     # Console RUN mode

BOM             = 65279 # MS Byte Order Marker


_bas = {}               # basic statements
_base = 0               # option base for DIM
_con = null             # console object
_dp = 0                 # data pointer
_dat = []               # data statements
_def = {}               # user defined functions
_eop = false            # end of program flag
_log = null             # log object
_pc = 0                 # instruction counter
_stack = []             # execution stack
_var = {}               # variables hash
_ver = V_GENERIC        # version of Basic - really, just a guess
_xrf = {}               # line number to Index in _bas[]

#
# Initialize the program memory
#
# @param  [Bool]  all if true, then clear code data also
# @return none
#
_init = ($all) ->
  _bas = {} if $all
  _base = 0
  _dat = []
  _def = {}
  _dp = 0
  _eop = false
  _pc = 0
  _stack = []
  _var = {}
  _ver = V_GENERIC
  _xrf = {}


#
# flatten a nested list
#
# @param  [Array] list  nested list
# @return [Array] the flattened list
#
_flatten = ($list) ->

  return [] unless $list?

  $a = []
  for $item in $list
    if Array.isArray($item)
      $a = $a.concat _flatten($item)
    else
      $a.push $item
  return $a

#
# allocate an array
#
# @param  [Mixed] init  value to initialize each cell
# @param  [Number]  dim1  size of the 1st dimension
# @param  [Number]  dim2  size of the 2nd dimension
# @return [Array] the new array
#
_dim = ($init, $dim1, $dim2) ->

  $a = []
  switch arguments.length
    when 2
      for $i in [_base...$dim1]
        $a[$i] = $init
    when 3
      for $i in [_base...$dim1]
        $a[$i] = []
        for $j in [_base...$dim2]
          $a[$i][$j] = $init
  return $a

class Log
  element: ''
  #
  # initialize a console
  #
  # @param  [String]  element DOM root element
  # @param  [String]  prompt  string to print
  # @return none
  #
  constructor: (@element) ->
    @console = $(@element)

  #
  # log an error
  #
  # @param  [String]  text  text to print
  # @return none
  #
  error: ($text) ->

    # reformat the error message
    [$title, $msg, $ofs, $err] = $text.split("\n")
    $detail = [$msg, $ofs, '', $err, ''].join("\n")

    # assume that the 1st number is the lineno
    if ($match = /\D*([0-9]+)\s/.exec($msg))?
      # remove everything prior to the lineno
      $dif = $match[0].length-$match[1].length-1
      $msg = $msg[$dif...]
      $ofs = $ofs[$dif...]
      $msg = $msg[0..$ofs.length]+'...'
      $detail = [$msg, $ofs, '', $err, ''].join('\n')

      # fix the lineno reference in the title
      $lineno = $match[1]
      if ($match = /\D*line ([0-9]+):$/.exec($title))?
        $title = $title.replace($match[1], $lineno)

    @console.append """
    <div class="alert alert-error">
    <span class="label label-info">
    <i class="icon-exclamation-sign icon-white"></i>#{$title}
    </span>
    <pre class="text-info">#{$detail}\n</pre>
    </div>
    """

    $('.tab-pane-log').tab 'show'


#
# wrapper for jquery.console
#
class Console

  mode: MODE_REPL
  element: ''
  console: null
  buffer: null
  vars: null
  #
  # jquery.console config:
  #
  animateScroll: true
  autofocus: true
  promptLabel: ''
  promptHistory: true
  welcomeMessage: ''

  #
  # initialize a console
  #
  # @param  [String]  element DOM root element
  # @param  [String]  prompt  string to print
  # @return none
  #
  constructor: (@element, $prompt = '> ') ->
    @promptLabel = $prompt
    @clear()

  #
  # callback to validate the input
  #
  # @param  [String]  line  the line that was entered
  # @return true if input is valid
  #
  commandValidate: ($line) =>
    if $line is "" then false else true

  #
  # callback to handle the input
  #
  # @param  [String]  line  the line that was wntered
  # @param  [String]  report  callback
  # @return none
  #
  commandHandle: ($line, $report) =>
    switch @mode

      when MODE_RUN

        @buffer.push $item for $item in $line.split(",")
        if @buffer.length < @vars.length
          @continuedPrompt = true
          return
        else
          _var[$name] = @buffer[$ix] for $name, $ix in @vars
          @continuedPrompt = false
          krt.run false
          return true

      when MODE_REPL

        try
          parse($line)
        catch $e
          return $e.toString()

  #
  # input from console
  #
  # @param  [String]  prompt  text to print
  # @param  [Array] vars  list of variables to input
  # @return true to trigger wait for io
  #
  input: ($prompt, $vars) ->
    @print $prompt if $prompt?
    @buffer = []
    @vars = $vars
    true

  #
  # print to console
  #
  # @param  [String]  text  text to print
  # @return none
  #
  print: ($text) ->
    @console.inner.append $text.replace(/\ /g, "&nbsp;")

  #
  # print with newline to console
  #
  # @param  [String]  text  text to print
  # @return none
  #
  println: ($text) ->
    @console.inner.append $text.replace(/\ /g, "&nbsp;")+"<br />"

  #
  # create a new console, erasing the previuos
  #
  # @return none
  #
  clear: ->
    $(@element).html ''
    @console = $(@element).console(@)
#
# This class enables you to mark points and calculate the time difference
#	between them.
#
class Benchmark
  #
  # @property [Object] Hash list of time markers
  #
  marker: null

  #
  # Initialize the marker array
  #
  constructor: ->

    Object.defineProperties @,
      marker : {enumerable: true, writeable: false, value: {}}


  #
  # Set a benchmark
  #
  # Mark the time at name
  #
  # @param  [String]  name  name of the marker
  # @return [Void]
  #
  mark : ($name) ->
    @marker[$name] = new Date()


  #
  # Elapsed Time
  #
  # Returns the time elapsed between two markers
  #
  # @param  [String]  point1   a particular marked point
  # @param  [String]  point2   a particular marked point
  # @return [Mixed]
  #
  elapsedTime : ($point1, $point2) ->

    return 0 if not @marker[$point1]?

    @marker[$point2] = new Date() if not @marker[$point2]?
    @marker[$point2] - @marker[$point1]




#
# Expression base class
#
class Expression

  #
  # Set expression properties
  #
  # @param  [String]  lhs part to the left of the operator
  # @param  [String]  rhs part to the right of the operator
  # @return none
  #
  constructor: (@lhs, @rhs) ->

#
# Built-In base class
#
class BuiltIn

  #
  # Set expression properties
  #
  # @param  [String]  $0  1st param
  # @param  [String]  $1  optional 2nd param
  # @param  [String]  $3  optional 3rd param
  # @return none
  #
  constructor: (@$0, @$1, @$2) ->
  toString: -> "#{@constructor.name.toUpperCase()}(#{@$0})"

#
# Command base class
#
class Command
  type: PHASE_EXEC
  eval: ->

#
# KRT - the kATRA rUNtIME
#
window.krt =

  #
  # Initialize the repl console
  #
  # @param [String] element the root html document node
  # @return none
  #
  repl: ($console, $log) ->
    _con = new Console($console)
    _log = new Log($log)

  #
  # Parse a program
  #
  # @param [String] code  the code to parse
  # @return none
  #
  parse: ($code) ->
    if $code?
      try
        parse($code[0..-2])
      catch $e
        _log.error $e.message

  #
  # Clear screen
  #
  # @return none
  #
  cls: ->
    _con.clear()

  #
  # Delete line(s)
  #
  # @param [Number] start starting line number
  # @param [Number] end ending line number
  # @return none
  #
  del: ($start, $end = $start) ->
    for $lineno in [$start...$end]
      if _bas[$lineno]? then delete _bas[$lineno]

  #
  # Load a program from local storage
  #
  # @param [String] file  program filename
  # @return none
  #
  get: ($file) ->
    _init true
    $text = localStorage[$file[1...-1]] || ''
    parse($text)

  #
  # Delete a program from local storage
  #
  # @param [String] file  program filename
  # @return none
  #
  purge: ($file) ->
    if localStorage[$file[1...-1]]? then delete localStorage[$file[1...-1]]


  #
  # List line(s)
  #
  # @param [Number] start starting line number
  # @param [Number] end ending line number
  # @return none
  #
  list: ($start, $end = $start) ->
    $lines = []

    for $lineno, $statement of _bas
      while $lineno.length<5
        $lineno = '0'+$lineno
      $lines.push [$lineno, $statement]

    $lines.sort()
    for [$lineno, $statement] in $lines
      $lineno = $statement.lineno
      $code = $statement.code
      if $start?
        if $lineno >= $start and $lineno <= $end
          _con.println $lineno+' '+$code
      else
        _con.println $lineno+' '+$code

  #
  # Run the program
  #
  # @param [Bool] wait  wait flag for i/o
  # @return none
  #
  run: ($wait) ->

    unless $wait?
      _init false
      _con.mode = MODE_RUN

    # Phase 1: Scan
    $wait = false
    $lines = []
    for $lineno, $statement of _bas
      _xrf[$lineno] = $lines.length
      $lines.push $statement
      if $statement.code.type is PHASE_SCAN
        $statement.code.eval()

    # Phase 2: Execute
    $lines.sort()
    try
      until _eop or $wait
        $code = $lines[_pc++].code
        $wait = $code.eval() if $code.type is PHASE_EXEC
        _eop = true if _pc >= $lines.length
    catch $e
      _con.println $e
      $wait = false

    unless $wait
      _con.mode = MODE_REPL
      _con.println 'DONE'


  #
  # Save the program
  #
  # @param [String] file  program filename
  # @return none
  #
  save: ($file) ->
    $lines = []
    $text = ''

    for $lineno, $statement of _bas
      $lines.push [$lineno, $statement.code]

    $lines.sort()
    for [$lineno, $code] in $lines
      $text += $lineno+' '+$code+'\n'
    localStorage[$file[1...-1]] = $text[0...-1]


  #
  # Delete the program from memory
  #
  # @return none
  #
  scr: ->
    _init true
    _con.clear()

  #
  # Compile to js
  #
  # @return none
  #
  compile: ->
    $src = []
    for $lineno, $code of _bas
      $src.push $code.compile()
    $src.join('\n')

  #
  # A single Basic statement
  #
  Statement: class Statement

    #
    # Set statement properties
    #
    # @param [Number] lineno  the statement label
    # @param [Object] code  the executable part
    # @return none
    #
    constructor: ($lineno, $code) ->

      if $code?
        if $lineno>0
          @lineno = $lineno
          @code = $code
          _bas[@lineno] = @
      else
        [$lineno, $code] = [null, $lineno]
        $code?.eval?()

  #
  # ZER
  #
  Zer:
    eval: -> 0
    toString: -> 'ZER'

  #
  # CON
  #
  Con:
    eval: -> 1
    toString: -> 'CON'

  Semic:
    eval: -> '&nbsp;&nbsp;&nbsp;&nbsp;'
    toString: -> ';'

  Comma:
    eval: -> '&nbsp;'
    toString: -> ','

  NullSep:
    eval: -> ''
    toString: -> ''
#
  # Constant
  #
  Const: class Const
    constructor: (@value) ->
      @is_string = if 'string' is typeof @value then true else false
      if @is_string
        if @value.charAt(0) is '"'
          @value = @value[1..-2]

    value: -> @value
    eval: -> @value
    toString: ->
      if @is_string then "\"#{@value}\"" else "#{@value}"
  #
  # Variable
  #
  Var: class Var
    constructor: (@name, $delim, $dims) ->
      if $delim?
        _ver = switch $delim
          when '(' then V_GENERIC
          when '[' then V_TSB2K
          else V_INVALID
        @is_array = true
        @dims = _flatten($dims)
        @dim1 = @dims[0]
        @dim2 = @dims[1]
      else @is_array = false

    let: ($value) ->
      if @dim2?
        _var[@name][@dim1][@dim2] = $value
      else if @dim1?
        _var[@name][@dim1] = $value
      else
        _var[@name] = $value

    eval: () ->
      if @dim2?
        _var[@name][@dim1][@dim2]
      else if @dim1?
        _var[@name][@dim1]
      else
        _var[@name]

    toString: ->
      if @is_array
        "#{@name}[#{@dims.join(',')}]"
      else @name

  #
  # Basic Command Keywords:
  #

  #
  # Base n
  #
  Base: class Base extends Command
    constructor: (@base) ->
    eval: ->
      _base = @base
      return false
    toString: ->
      "BASE #{@base}"

  #
  # Data v1, v2, ... vN
  #
  Data: class Data extends Command
    type: PHASE_SCAN # Execute during scan phase
    constructor: (@data) ->
    eval: ->
      if _dat is null then _dat = []
      _dat = _dat.concat @data
      return false
    toString: ->
      "DATA #{@data.join(', ')}"

  #
  # Def FNA(P) = X
  #
  Def: class Def extends Command
    type: PHASE_SCAN # Execute during scan phase
    constructor: (@name, @par, @body) ->
    eval: ->
      if _def is null then _def = {}
      _def[@name] = Function(@par, @body)
      return false
    toString: ->
      "DEF FN#{@name}(#{@par}) = #{@body}"

  #
  # Dim A(1)
  # Dim A(1,1)
  # Dim A$(1)
  #
  Dim: class Dim extends Command
    type: PHASE_SCAN # Execute during scan phase
    constructor: (@vars) ->
    eval: ->
      for $var in @vars
        _var[$var.name] = _dim(0, $var.dims...)
      return false
    toString: ->
      "DIM #{@vars.join(', ')}"

  #
  # End
  #
  End: class End extends Command
    eval: -> _eop = false
    toString: ->
      "END"

  #
  # For VAR = start To end
  # For VAR = start To end Step n
  #
  For: class For extends Command
    constructor: (@var, @start, @end, @step=1) ->
    eval: ->
      _var[@var] = @start.eval()
      _stack.push {
        id:		FOR
        pc:		_pc
        name: @var
        end:	@end.eval()
        step:	@step.eval()
      }
      return false
    toString: ->
      if @step is 1
        "FOR #{@var} = #{@start} TO #{@end}"
      else
        "FOR #{@var} = #{@start} TO #{@end} STEP #{@step}"

  #
  # Goto line
  # Goto line1, line2, ... lineN Of X
  #
  Goto: class Goto extends Command
    constructor: (@lineno, @of) ->
    eval: ->
      _pc = _xrf[@lineno]
      return false
    toString: ->
      if @of?
        "GOTO #{@lineno} OF #{@of.join(',')}"
      else
        "GOTO #{@lineno}"

  #
  # Gosub line
  #
  Gosub: class Gosub extends Command
    constructor: (@lineno) ->
    eval: ->
      _stack.push {
        id:		GOSUB
        pc:		_pc
      }
      _pc = _xrf[@lineno]
      return false
    toString: ->
      "GOSUB #{@lineno}"

  #
  # If <Cond> Then line
  #
  If: class If extends Command
    constructor: (@cond, @lineno) ->
    eval: ->
      if @cond.eval()
        _pc = _xrf[@lineno]
      return false
    toString: ->
      "IF #{@cond} THEN #{@lineno}"

  #
  # Image
  #
  Image: class Image extends Command
    constructor: ($list = []) ->
      @list = _flatten($list)
    eval: ->
      return false
    toString: ->
      "IMAGE #{@list.join('')}"

  #
  # Input var1, var2, ... varN
  # Input "Prompt", var1, var2, ... varN
  #
  Input: class Input extends Command
    constructor: ($vars, @prompt) ->
      @vars = _flatten($vars)
    eval: ->
      _con.input(@prompt, @vars)

    toString: ->
      if @prompt?
        "INPUT #{@prompt}, #{@vars.join(',')}"
      else
        "INPUT #{@vars.join(',')}"

  #
  # Let VAR = <VAR => value
  #
  Let: class Let extends Command
    constructor: ($vars, @value) ->
      @vars = []
      for $var in _flatten($vars)
        if 'string' is typeof $var
          @vars.push new Var($var)
        else
          @vars.push $var
    eval: ->
      $value = @value.eval()
      for $var in @vars
        $var.let $value
      return false
    toString: ->
      $s = ''
      for $var in @vars
        $s += $var + ' = '
      "LET #{$s}#{@value}"

  #
  # Mat VAR = value
  #
  Mat: class Mat extends Command
    constructor: (@var, @value) ->
    eval: ->
      $value = @value.eval()

      if _var[@var]?
        $i = $a.length
        $j = $a[_base].length
      else
        $i = $j = 9
      _var[@var] = _dim($value, $i, $j)
      return false

    toString: ->
      "MAT #{@var} = #{@value}"

  #
  # Next VAR
  #
  Next: class Next extends Command
    constructor: (@var) ->
    eval: ->
      return false
    toString: ->
      "NEXT #{@var}"

  #
  # Print item1, item2, ... itemN
  #
  Print: class Print extends Command
    constructor: ($items) ->
      @items = _flatten($items)
    eval: ->
      $str = ''
      for $item in @items
        $str += $item.eval()
      _con.println $str
      return false
    toString: ->
      $str = ''
      for $item in @items
        $str += $item.toString()
      "PRINT #{$str}"

  #
  # Print Using line;item1, item2, ... itemN
  #
  Using: class Using extends Command
    constructor: (@lineno, @items = []) ->
    eval: ->
      return false
    toString: ->
      if @items.length is 0
        "PRINT USING #{@lineno}"
      else
        $str = ''
        for $item in @items
          $str += $item.toString()+','
        $str = $str[0...-1]
        "PRINT USING #{@lineno};#{$str}"

  #
  # Randomize
  #
  Randomize: class Randomize extends Command
    constructor: ->
    eval: ->
      return false
    toString: ->
      "RANDOMIZE"

  #
  # Read var1, var2, ... varN
  #
  Read: class Read extends Command
    constructor: (@vars) ->
    eval: ->
      return false
    toString: ->
      "READ #{@vars.join(',')}"

  #
  # Return
  #
  Return: class Return extends Command
    constructor: ->
    eval: ->
      return false
    toString: ->
      "RETURN"

  #
  # Rem ...
  #
  Rem: class Rem extends Command
    constructor: (@text) ->
    eval: -> return false
    toString: ->
      "#{@text}"

  #
  # Stop
  #
  Stop: class Stop extends Command
    constructor: ->
    eval: -> return false
    toString: ->
      "STOP"


  #
  # Basic Operators:
  #

  #
  # +
  #
  Add: class Add extends Expression
    eval: -> @lhs.eval() + @rhs.eval()
    toString: -> "#{@lhs} + #{@rhs}"
  #
  # -
  #
  Sub: class Sub extends Expression
    eval: -> @lhs.eval() - @rhs.eval()
    toString: -> "#{@lhs} - #{@rhs}"
  #
  # *
  #
  Mul: class Mul extends Expression
    eval: -> @lhs.eval() * @rhs.eval()
    toString: -> "#{@lhs} * #{@rhs}"
  #
  # /
  #
  Div: class Div extends Expression
    eval: -> @lhs.eval() / @rhs.eval()
    toString: -> "#{@lhs} / #{@rhs}"
  #
  # ^
  #
  Pow: class Pow extends Expression
    eval: -> Math.pow(@lhs.eval(), @rhs.eval())
    toString: -> "#{@lhs} ^ #{@rhs}"
  #
  # OR
  #
  OR: class OR extends Expression
    eval: -> @lhs.eval() or @rhs.eval()
    toString: -> "#{@lhs} OR #{@rhs}"
  #
  # AND
  #
  AND: class AND extends Expression
    eval: -> @lhs.eval() and @rhs.eval()
    toString: -> "#{@lhs} AND #{@rhs}"
  #
  # NOT
  #
  NOT: class NOT extends Expression
    eval: -> not @lhs.eval()
    toString: -> "NOT #{@lhs}"
  #
  # <
  #
  LT: class LT extends Expression
    eval: -> @lhs.eval() < @rhs.eval()
    toString: -> "#{@lhs} < #{@rhs}"
  #
  # >
  #
  GT: class GT extends Expression
    eval: -> @lhs.eval() > @rhs.eval()
    toString: -> "#{@lhs} > #{@rhs}"
  #
  # <=
  #
  LE: class LE extends Expression
    eval: -> @lhs.eval() <= @rhs.eval()
    toString: -> "#{@lhs} <= #{@rhs}"
  #
  # >=
  #
  GE: class GE extends Expression
    eval: -> @lhs.eval() >= @rhs.eval()
    toString: -> "#{@lhs} >= #{@rhs}"
  #
  # ==
  #
  EQ: class EQ extends Expression
    eval: -> if @lhs.eval() is @rhs.eval() then true else false
    toString: -> "#{@lhs} = #{@rhs}"
  #
  # !=
  #
  NE: class NE extends Expression
    eval: -> if @lhs.eval() isnt @rhs.eval() then true else false
    toString: -> "#{@lhs} <> #{@rhs}"


  #
  # Basic Builtin Functions
  #
  ABS: class ABS extends BuiltIn
    eval: -> Math.abs(@$0.eval())
  ATN: class ATN extends BuiltIn
    eval: -> Math.atn(@$0.eval())
  COS: class COS extends BuiltIn
    eval: -> Math.cos(@$0.eval())
  EXP: class EXP extends BuiltIn
    eval: -> Math.exp(@$0.eval())
  INT: class INT extends BuiltIn
    eval: -> Math.floor(@$0.eval())
  LEN: class LEN extends BuiltIn
    eval: -> @$0.length
  LIN: class LIN extends BuiltIn
    eval: -> '\n'
  LOG: class LOG extends BuiltIn
    eval: -> Math.log(@$0.eval())
  RND: class RND extends BuiltIn
    eval: -> Math.random(@$0.eval())
  SGN: class SGN extends BuiltIn
    eval: ->
      $0 = @$0.eval
      if $0 < 0 then -1 else if $0 > 0 then 1 else 0
  SIN: class SIN extends BuiltIn
    eval: -> Math.sun(@$0.eval())
  SPA: class SPA extends BuiltIn
    eval: -> Array(@$0.eval()).join(" ")
  SQR: class SQR extends BuiltIn
    eval: -> Math.sqrt(@$0.eval())
  SUBSTR: class SUBSTR extends BuiltIn
    eval: -> @$0.eval().substr(@$1.eval(), @$2.eval())
    toString: -> "SUBSTR(#{@$0}, #{@$1}, #{@$2})"
  TAB: class TAB extends BuiltIn
    eval: -> Array(@$0.eval()).join("    ")
  TAN: class TAN extends BuiltIn
    eval: -> Math.tan(@$0.eval())
  TIM: class TIM extends BuiltIn
    eval: ->
      if @$0.eval() is 0 then (new Date()).getMinutes() else (new Date()).getSeconds()


parse = ($code) ->

  # skip over the bom
  $code = $code.slice(1) if $code.charCodeAt(0) is BOM

  # remove CR's, and split into lines
  $code = $code.replace(/\r/g, '').split('\n')

  for $line, $index in $code

    #
    #   1 replace IF ...= with IF ...==
    #
    if /\d+\s+IF\s/.test($line) or /^\s*IF\s/.test($line)
      $code[$index] = $line
        .replace(/\=/g,     '==')
        .replace(/\<\=\=/g, '<=')
        .replace(/\>\=\=/g, '>=')

    #
    #   2 replace PRINT "..."X with PRINT "...":X
    #
    if /\d+\s+PRINT\s/.test($line) or /^\s*PRINT\s/.test($line)
      $code[$index] = $line
        .replace(/(\"[^"]*\")([^;,])/g, "$1:$2")
        .replace(/([^;,])(\"[^"]*\")/g, "$1:$2")
        .replace(/(PRINT\s+)\:/, "$1")

#  console.log '==================================================='
#  console.log $code.join('\n')
#  console.log '==================================================='

  kc.parse $code.join('\n')