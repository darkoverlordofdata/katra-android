#+--------------------------------------------------------------------+
#| katra.coffee
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
# The Katra AST Framework
#

rte = if window? then window.rte else require("./rte.node")


GOSUB           = 1       # Stack frame identifier: Gosub..Return
FOR             = 2       # Stack frame identifier: For..Next

PHASE_SCAN      = 0       # Processed during scan
PHASE_EXEC      = 1       # Executable statements

MODE_REPL       = 0       # Console REPL mode
MODE_RUN        = 1       # Console RUN mode

BOM             = 65279   # MS Byte Order Marker

PRINTF = ///    # Printf style format parser
  (\%)          # pct - % escape
  ([-])?        # flag left justify
  ([+ ])?       # flag sign
  ([0])?        # flag padding
  (\d*)?        # field width
  (\.\d*)?      # decimal precision
  ([\%ds])      # output specifier
  ///g

_con  = null    # console object
_dat  = []      # data statements
_dbg  = false   # trace on/off
_dp   = 0       # data pointer
_eop  = false   # end of program flag
_fn   = {}      # user defined functions
_fs   = null    # file system object
_lin  = []      # sorted executable code
_mrk  = {}      # benchmarks
_ofs  = 0       # option base offset for DIM
_pc   = 0       # instruction counter
_prg  = {}      # unsorted code
_stk  = []      # execution stack
_use  = 'bnf'   # grammar to use
_var  = {}      # variables hash
_xrf  = {}      # line number in _prg[]

#
# Use optional grammar
#
_use  = process.argv[2] ? _use if process?
#
# Initialize the program memory
#
# @param  [Bool]  all if true, then clear code data also
# @return none
#
_init = ($all) ->
  _dat  = []
  _dp   = 0
  _eop  = false
  _fn   = {}
  _mrk  = {}
  _ofs  = 0
  _pc   = 0
  _prg  = {} if $all
  _stk  = []
  _var  = {}
  _xrf  = {}

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
      for $i in [_ofs...$dim1+1]
        $a[$i] = $init
    when 3
      for $i in [_ofs...$dim1+1]
        $a[$i] = []
        for $j in [_ofs...$dim2+1]
          $a[$i][$j] = $init
  return $a


#
# eval
#
# @param  [Object] node
# @return the calced result
#
_eval = ($node) ->

  # inner node
  # terminal node
  if $node.eval?
    $node.eval()

  else if $node.op?
    switch $node.op
      when '+' then _eval($node.left) + _eval($node.right)
      when '-' then _eval($node.left) - _eval($node.right)
      when '*' then _eval($node.left) * _eval($node.right)
      when '/' then _eval($node.left) / _eval($node.right)
      when '^' then Math.pow(_eval($node.left), _eval($node.right))

  # primitive value
  else $node

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
# printf style output
#
# @param  [String] fmt  printf style format string
# @param  [Array] list  list of args
# @return [String] the formatted output
#
_sprintf = ($fmt, $list) ->

  $count = 0
  #
  # format each print spec/value pair
  #
  _foreach = ($match, $pct, $just, $sign, $pad=' ', $width, $prec, $spec, $ofset, $string) ->

    $value = String($list[$count++])
    switch $spec
      #
      # %% = Escaped %
      #
      when '%'
        '%'
      #
      # String format
      #
      when 's'
        if $width?
          $width = parseInt($width, 10)
          if $value.length < $width
            if $just? # left
              return Array($width-$value.length+1).join($pad) + $value
            else      # right
              return $value + Array($width-$value.length+1).join($pad)
        $value
      #
      # Number format
      #
      when 'd'
        if $width?
          $width = parseInt($width, 10)
          if $value.length < $width
            if $just? # left
              return $value + Array($width-$value.length+1).join($pad)
            else      # right
              return Array($width-$value.length+1).join($pad) + $value
        $value


  $fmt.replace(PRINTF, _foreach)

#
# Construct a printf style format string from an IMAGE
#
# @param  [Array] image
# @return [Array] the printf style format string
#
_format = ($image = []) ->

  $out = ''
  $count = 1

  while $image.length > 0
    $head = $image.shift()
    if isNaN($head)
      switch $head
        when ','
          $count = 1
        when 'D'
          $out +=  if $count > 1 then '%'+ $count + 'd' else '%d'
          $count = 1
        when 'A'
          $out +=  if $count > 1 then '%'+ $count + 's' else '%s'
          $count = 1
        when 'X'
          $out += Array($count+1).join(' ')
          $count = 1
        when '('
          $out += Array($count+1).join(_format($image))
          $count = 1
        when ')'
          return $out
        else
          $out += $head[1...-1]
          $count = 1

    else
      $count = $head

  return $out

_pad = ($value, $len, $pad = ' ') ->

  $right = not isNaN($value)  # right justify numerics
  $value = String($value)     # ensure that we work with a string
  if $right
    if $value.length < $len
      Array($len-$value.length+1, $pad) + $value
    else
      $value.substr(0, $len)

  else
    if $value.length < $len
      $value + Array($len-$value.length+1, $pad)
    else
      $value.substr(0, $len)


#
# Set a benchmark
#
# Mark the time at name
#
# @param  [String]  name  name of the marker
# @return [Void]
#
_mark = ($name) ->
  _mrk[$name] = new Date()


#
# Elapsed Time
#
# Returns the time elapsed between two markers
#
# @param  [String]  point1   a particular marked point
# @param  [String]  point2   a particular marked point
# @return [Integer]
#
_elapsed_time = ($point1, $point2) ->

  return 0 if not _mrk[$point1]?

  _mrk[$point2] = new Date() if not _mrk[$point2]?
  _mrk[$point2] - _mrk[$point1]



#
# Abstract Operator class
#
class Operator

  #
  # Set Operator properties
  #
  # @param  [String]  left part to the left of the operator
  # @param  [String]  right part to the right of the operator
  # @return [Void]
  #
  constructor: (@left, @right) ->


#
# Abstract Built-In function class
#
class BuiltIn

  #
  # Set expression properties
  #
  # @param  [String]  $0  1st param
  # @param  [String]  $1  optional 2nd param
  # @param  [String]  $3  optional 3rd param
  # @return [Void]
  #
  constructor: (@$0, @$1, @$2) ->
  toString: -> "#{@constructor.name.toUpperCase()}(#{@$0})"

#
# Abstract Keyword class
#
class Keyword
  type: PHASE_EXEC
  eval: -> false

#
# Implement the abstract Console class
# by overriding the handler method
#
class Console extends rte.Console

  #
  # @property [Integer] mode - repl or program execution?
  #
  mode: MODE_REPL

  #
  # callback to handle the input
  #
  # @param  [String]  line  the line that was wntered
  # @return none
  #
  commandHandle: ($line) =>
    switch @mode

      #
      # Input statement
      #
      when MODE_RUN

        #$line = $line[0...-1]
        $line = $line.split('\n')[0]
        for $item in $line.split(",")
          @buffer.push if isNaN($item) then String($item) else Number($item)

        if @buffer.length < @vars.length
          @continuedPrompt = true
          return
        else
          _var[$name] = @buffer[$ix] for $name, $ix in @vars
          @continuedPrompt = false
          katra.command.run false
          return true

      #
      # Interacive (REPL) 
      #
      when MODE_REPL

        try
          katra[_use].parse($line)
        catch $e
          @debug $e

_con = new Console
_fs = new rte.FileSystem

#
# Module Katra
#
#
katra =

  parse: ($code) ->
    katra[_use].parse $code


  #
  # Basic commands for manipulating the code
  # Commands cannot occur in a program.
  #
  command:

    cls: () ->
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
        if _prg[$lineno]? then delete _prg[$lineno]

    #
    # Load a program from local storage
    #
    # @param [String] file  program filename
    # @return none
    #
    get: ($file) ->
      _init true
      _fs.readFile $file, ($err, $data) ->
        if $err? then _con.println $err
        else katra[_use].parse $data

    #
    # List line(s)
    #
    # @param [Number] start starting line number
    # @param [Number] end ending line number
    # @return none
    #
    list: ($start, $end = $start) ->
      $lines = []

      for $lineno, $statement of _prg
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
          _con.println $lineno+' '+ $code


    #
    # Delete a program from local storage
    #
    # @param [String] file  program filename
    # @return none
    #
    purge: ($file) ->
      _fs.delete $file, ($err) ->
        if $err? then _con.println $err


    #
    # Exit Katra
    #
    quit: () ->
      process?.exit()

    #
    # Run the program
    #
    # @param [Bool] wait  wait flag for i/o
    # @return none
    #
    run: ($wait) ->

      unless $wait?
        # Phase 1: Scan
        _init false
        _con.mode = MODE_RUN
        $wait = false
        _lin = []
        for $lineno, $statement of _prg
          _xrf[$lineno] = _lin.length
          while $lineno.length<5
            $lineno = '0'+$lineno
          _lin.push [$lineno, $statement]
          if $statement.code.type is PHASE_SCAN
            $statement.code.eval()
        _lin.sort()

      # Phase 2: Execute
      try
        until _eop or $wait

          [$lineno, $statement] = _lin[_pc++]
          $code = $statement.code

          if $statement.code.type is PHASE_EXEC
            _con.debug $lineno+' '+$code.toString() if _dbg
            $wait = $code.eval()

          _eop = true if _pc >= _lin.length
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

      for $lineno, $statement of _prg
        $lines.push [$lineno, $statement.code]

      $lines.sort()
      for [$lineno, $code] in $lines
        $text += $lineno+' '+$code+'\n'

      _fs.writeFile $file, $text[0...-1], ($err) ->
        if $err? then _con.println $err


    #
    # Scratch memory
    #
    scr: () ->
      _init true

    trace: ($flag) ->
      _dbg = $flag



  #
  # BNF Utility Functions
  #
  bnf:

    #
    # parse
    #
    # @param  [String] code basic code to parse
    # @return true if successful, else false
    #
    parse: ($code) ->

      kc = if window? then window.kc else require("./kc.bnf")

      #
      # skip over a byte order marker
      #
      $code = $code.slice(1) if $code.charCodeAt(0) is BOM

      #
      # normalize CR/LF
      #
      $code = ($code + '\n')    # make sure there is an ending LF
      .replace(/\r/g,  '\n')    # replace CR's with LF's
      .replace(/\n+/g, '\n')    # remove duplicate LF's
      .split('\n')              # and split into lines

      #
      # BASIC is a square peg
      # BNF is a round hole.
      # To make it fit, we sand the edges off the square peg:
      #
      for $line, $index in $code

        #
        #   1 replace IF ...= with IF ...==
        #
        if /\d+\s+IF\s/i.test($line) or /^\s*IF\s/i.test($line)
          $code[$index] = $line
          .replace(/\=/g,     '==')
          .replace(/\<\=\=/g, '<=')
          .replace(/\>\=\=/g, '>=')

        #
        #   2 insert missing semicolons in PRINT statements
        #
        if /\d+\s+PRINT\s/i.test($line) or /^\s*PRINT\s/i.test($line)
          $code[$index] = $line
          .replace(/(\"[^"]*\")([^;,])/ig,  "$1;$2")
          .replace(/([^;,])(\"[^"]*\")/ig,  "$1;$2")
          .replace(/(PRINT\s+)\;/i,         "$1")


      kc.parse $code.join('\n')


  #
  # PEG Utility Functions
  #
  peg:

    #
    # eval
    #
    # @param  [Object] node
    # @return the calced result
    # used by parser expression grammars
    #
    eval: _eval

    #
    # parse
    #
    # @param  [String] code basic code to parse
    # @return true if successful, else false
    #
    parse: ($code) ->
      kc = if window? then window.kc else require("./kc.peg")
      kc.parse $code

    #
    # Merge items into a clean list
    # used by parser expression grammars
    #
    # @param head  first item in the list
    # @param tail  the rest of the list
    # @return a clean list
    #
    merge: ($head, $tail, $item=0) ->
      #
      # put head at the begining of the new list
      #
      list = [$head]
      #
      # add selected item from each sublist in tail
      #
      list.push $each[$item] for $each in $tail
      #
      # the merged list
      #
      list
    #
    #
    # Expression
    #
    # folds a linear list into a binary tree
    # used by parser expression grammars
    #
    # @param head  first item in the list
    # @param tail  list of operator/operand tuples
    # @return a tree
    #
    expression: ($head, $tail = []) ->
        $node = $head
        for $each in $tail
          $node =
            type    : 2
            op      : $each[0]
            left    : $node
            right   : $each[1]

        $node


    #
    # Set statement properties
    #
    # @param [Number] lineno  the statement label
    # @param [Object] code  the executable part
    # @return none
    #
    statement:  ($code, $lineno) ->

      if $lineno?
        _prg[$lineno] =
          lineno: $lineno
          code: $code
      else
        $code?.eval?()


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
    constructor: ($code, $lineno) ->

      if $lineno?
        _prg[$lineno] =
          lineno: $lineno
          code: $code
      else
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
    eval: -> ''
    toString: -> ';'

  Comma:
    eval: -> '    '
    toString: -> ','

  #
  # Constant
  #
  Const: class Const
    
    #
    # Create a new Constant
    #
    # @param  value
    #
    constructor: (@value) ->
      @is_string = if 'string' is typeof @value then true else false
      if @is_string
        if @value.charAt(0) is '"'
          @value = @value[1..-2]

    #
    # Get the constant value
    #
    value: -> @value
      
    #
    # Get the constant value
    #
    eval: -> @value
      
    #
    # @return the string representaion
    #
    toString: ->
      if @is_string then "\"#{@value}\"" else "#{@value}"
        
  #
  # Variable
  #
  Var: class Var

    #
    # Create a new Variable reference
    #
    # @param  name  the variable name
    # @param  delim array delimiter (optional)
    # @param  dims  array imdex (optional)
    #
    constructor: (@name, $delim, $dims) ->
      @is_string = /\$$/.test(@name)
      if $delim?
        @is_array = true
        @dims = _flatten($dims)
        @dim1 = @dims[0]
        @dim2 = @dims[1]
      else @is_array = false

    #
    # Set the variable value
    #
    let: ($value) ->
      if @is_string
        if @dim2?

          $start = @dim1.eval()-1
          $end = @dim2.eval()
          if $end < $start
            throw 'Invalid String index: '+@toString()
          $len = $end-$start
          $value = $value.substr(0,$len)
          # $value = $value+' ' while $value.length < $len
          $value = _pad($value, $len)

          $str = _var[@name]
          _var[@name] = $str.substr(0,$start)+$value+$str.substr($end)

        else if @dim1?
          $start = @dim1.eval()-1
          $str = _var[@name]
          _var[@name] = $str.substr(0,$start)+$value+$str.substr($start+$value.length)

        else
          $len = _var[@name].length
          if $value.length < $len
            $value += Array($len-$value.length+1).join(' ')
          _var[@name] = $value

      else if @dim2?
        $dim1 = @dim1.eval()
        $dim2 = @dim2.eval()
        _var[@name][$dim1][$dim2] = $value

      else if @dim1?
        $dim1 = @dim1.eval()
        _var[@name][$dim1] = $value

      else
        _var[@name] = $value

    #
    # Get the variable value
    #
    eval: () ->

      if @is_string
        if @dim2?

          $start = @dim1.eval()-1
          $end = @dim2.eval()
          if $end < $start
            throw 'Invalid String index: '+@toString()
          _var[@name].slice($start, $end)

        else if @dim1?
          $start = @dim1.eval()-1
          _var[@name].slice($start)

        else
          _var[@name]

      else if @dim2?
        $dim1 = @dim1.eval()
        $dim2 = @dim2.eval()
        _var[@name][$dim1][$dim2]

      else if @dim1?
        $dim1 = @dim1.eval()
        _var[@name][$dim1]

      else
        _var[@name]

    #
    # @return the string representaion
    #
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
  Base: class Base extends Keyword

    #
    # Set the option base
    #
    # @param  base  index offset 0 or 1
    #
    constructor: (@base) ->

    #
    # Execute 
    #
    eval: ->
      _ofs = @base
      return false
      
    #
    # @return the string representaion
    #
    toString: ->
      "BASE #{@base}"

  #
  # Data v1, v2, ... vN
  #
  Data: class Data extends Keyword
    type: PHASE_SCAN # Execute during scan phase
    constructor: ($data) ->
      @data = _flatten($data)
    eval: ->
      if _dat is null then _dat = []
      _dat = _dat.concat @data
      return false
    #
    # @return the string representaion
    #
    toString: ->
      "DATA #{@data.join(', ')}"

  #
  # Def FNA(P) = X
  #
  Def: class Def extends Keyword
    type: PHASE_SCAN # Execute during scan phase
    constructor: (@name, @par, @body) ->
    eval: ->

      _fn[@name] = ($par) =>

        $tmp = _var[@par]   # variable goes out of scope,
        _var[@par] = $par   # occluded by the local param
        $ret = @body.eval() # while we execute the function body
        _var[@par] = $tmp   # variable returns to scope
        $ret

      return false
    #
    # @return the string representaion
    #
    toString: ->
      "DEF #{@name}(#{@par}) = #{@body}"

  #
  # Dim A(1)
  # Dim A(1,1)
  # Dim A$(1)
  #
  Dim: class Dim extends Keyword
    type: PHASE_SCAN # Execute during scan phase
    constructor: ($vars) ->
      @vars = _flatten($vars)
    eval: ->
      for $var in @vars
        if /\$$/.test($var.name)
          #
          # String
          #
          _var[$var.name] = Array($var.dims[0]+1).join(' ')
        else
          #
          # Numeric
          #
          _var[$var.name] = _dim(0, $var.dims...)

      return false
    #
    # @return the string representaion
    #
    toString: ->
      "DIM #{@vars.join(', ')}"

  #
  # End
  #
  End: class End extends Keyword
    eval: ->
      _eop = true
      return false
    #
    # @return the string representaion
    #
    toString: ->
      "END"

  #
  # For VAR = start To end
  # For VAR = start To end Step n
  #
  For: class For extends Keyword
    constructor: (@var, @start, @end, @step=new Const(1)) ->
    eval: ->
      _var[@var] = @start.eval()
      _stk.push {
        id:		FOR
        pc:		_pc
        name: @var
        end:	@end
        step:	@step
      }
      return false
    #
    # @return the string representaion
    #
    toString: ->
      if @step is 1
        "FOR #{@var} = #{@start} TO #{@end}"
      else
        "FOR #{@var} = #{@start} TO #{@end} STEP #{@step}"

  #
  # Goto line
  # Goto line1, line2, ... lineN Of X
  #
  Goto: class Goto extends Keyword
    constructor: (@lineno, $of) ->
      @of = _flatten($of)
    eval: ->
      if @of.length>0
        $index = @lineno.eval()-1
        if @of[$index]?
          _pc = _xrf[@of[$index]]

      else
        _pc = _xrf[@lineno]
      return false
    #
    # @return the string representaion
    #
    toString: ->
      if @of?
        "GOTO #{@lineno} OF #{@of.join(',')}"
      else
        "GOTO #{@lineno}"

  #
  # Gosub line
  #
  Gosub: class Gosub extends Keyword
    constructor: (@lineno) ->
    eval: ->
      _stk.push {
        id:		GOSUB
        pc:		_pc
      }
      _pc = _xrf[@lineno]
      return false
    #
    # @return the string representaion
    #
    toString: ->
      "GOSUB #{@lineno}"

  #
  # If <Cond> Then line
  #
  If: class If extends Keyword
    constructor: (@cond, @lineno) ->
    eval: ->
      if @cond.eval()
        _pc = _xrf[@lineno]
      return false
    #
    # @return the string representaion
    #
    toString: ->
      "IF #{@cond} THEN #{@lineno}"

  #
  # Image
  #
  Image: class Image extends Keyword
    constructor: ($format = []) ->
      @source = _flatten($format)
      @format = _format(@source)
    eval: ->
      return false
    #
    # @return the string representaion
    #
    toString: ->
      "IMAGE #{@source.join('')}"

  #
  # Input var1, var2, ... varN
  # Input "Prompt", var1, var2, ... varN
  #
  Input: class Input extends Keyword
    constructor: ($vars, @prompt) ->
      @vars = _flatten($vars)
    eval: ->
      _con.input(@prompt, @vars)
      return true

    #
    # @return the string representaion
    #
    toString: ->
      if @prompt?
        "INPUT #{@prompt}, #{@vars.join(',')}"
      else
        "INPUT #{@vars.join(',')}"

  #
  # Let VAR= <VAR= > value
  #
  Let: class Let extends Keyword
    constructor: ($vars, @value) ->
      @vars = []
      for $var in _flatten($vars)
        if 'string' is typeof $var
          @vars.push new Var($var)
        else
          @vars.push $var
    eval: ->
      $value = _eval(@value)
      for $var in @vars
        $var.let $value
      return false
    #
    # @return the string representaion
    #
    toString: ->
      $s = ''
      for $var in @vars
        $s += $var + ' = '
      "LET #{$s}#{@value}"

  #
  # Mat VAR = value
  #
  Mat: class Mat extends Keyword
    constructor: (@var, @value) ->
    eval: ->
      $value = @value.eval()

      if _var[@var]?
        $i = _var[@var].length
        $j = _var[@var][_ofs].length
        _var[@var] = _dim($value, $i, $j)
      else
        _var[@var] = _dim($value, 10)
      return false

    #
    # @return the string representaion
    #
    toString: ->
      "MAT #{@var} = #{@value}"

  #
  # Next VAR
  #
  Next: class Next extends Keyword
    constructor: (@var) ->
    eval: ->
      $frame = _stk[_stk.length-1]
      if $frame.id isnt FOR
        throw "Next without for"

      $name = @var.name
      if $frame.name isnt $name
        throw "Mismatched For/Next #{$name}"

      $step = if $frame.step.eval? then $frame.step.eval() else $frame.step
      $counter = @var.eval() + $step
      @var.let $counter

      if $step < 0
        if $counter < $frame.end.eval()
          _stk.pop()
        else
          _pc = $frame.pc
      else
        if $counter > $frame.end.eval()
          _stk.pop()
        else
          _pc = $frame.pc
      return false
    #
    # @return the string representaion
    #
    toString: ->
      "NEXT #{@var}"

  #
  # Print item1, item2, ... itemN
  #
  Print: class Print extends Keyword
    constructor: ($items...) ->
      @items = _flatten([$items])
    eval: ->
      $str = ''
      for $item in @items
        $str += $item.eval()
      if $item in [katra.Semic, katra.Comma]
        _con.print $str
      else
        _con.println $str
      return false
    #
    # @return the string representaion
    #
    toString: ->
      $str = ''
      for $item in @items
        $str += $item.toString()
      "PRINT #{$str}"

  #
  # Print Using line;item1, item2, ... itemN
  #
  Using: class Using extends Keyword
    constructor: (@lineno, $items...) ->
      @items = _flatten($items)
    eval: ->

      $i = _xrf[@lineno]
      [$lineno, $statement] =  _lin[$i]
      $args = []
      for $item in @items
        $args.push $item.eval()

      if $item in [katra.Semic, katra.Comma]
        _con.print _sprintf($statement.code.format, $args)
      else
        _con.println _sprintf($statement.code.format, $args)
      return false
    #
    # @return the string representaion
    #
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
  Randomize: class Randomize extends Keyword
    constructor: ->
    eval: ->
      return false
    #
    # @return the string representaion
    #
    toString: ->
      "RANDOMIZE"

  #
  # Read var1, var2, ... varN
  #
  Read: class Read extends Keyword
    constructor: ($vars) ->
      @vars = _flatten($vars)
    eval: ->
      for $var in @vars
        if _dp < _dat.length
          $var.let _dat[_dp++].value
        else
          $var.let undefined

      return false
    #
    # @return the string representaion
    #
    toString: ->
      "READ #{@vars.join(',')}"

  #
  # Restore
  #
  Restore: class Restore extends Keyword
    eval: ->
      _dp = 0
      return false
    #
    # @return the string representaion
    #
    toString: ->
      "RESTORE"
  #
  # Return
  #
  Return: class Return extends Keyword
    constructor: ->
    eval: ->
      $frame = _stk.pop()
      while $frame.id isnt GOSUB
        $frame = _stk.pop()
      _pc = $frame.pc
      return false
    #
    # @return the string representaion
    #
    toString: ->
      "RETURN"

  #
  # Rem ...
  #
  Rem: class Rem extends Keyword
    constructor: ($text) ->
      @text = $text.replace(/^REM/i, '')
    eval: -> return false
    #
    # @return the string representaion
    #
    toString: ->
      "REM#{@text}"

  #
  # Stop
  #
  Stop: class Stop extends Keyword
    constructor: ->
    eval: ->
      _eop = true
      return false
    #
    # @return the string representaion
    #
    toString: ->
      "STOP"

  #
  # Basic Operators:
  # used by BNF grammars
  #

  #
  # +
  #
  Add: class Add extends Operator
    eval: -> @left.eval() + @right.eval()
    toString: -> "#{@left} + #{@right}"
  #
  # -
  #
  Sub: class Sub extends Operator
    eval: -> @left.eval() - @right.eval()
    toString: -> "#{@left} - #{@right}"
  #
  # *
  #
  Mul: class Mul extends Operator
    eval: -> @left.eval() * @right.eval()
    toString: -> "#{@left} * #{@right}"
  #
  # /
  #
  Div: class Div extends Operator
    eval: -> @left.eval() / @right.eval()
    toString: -> "#{@left} / #{@right}"
  #
  # ^
  #
  Pow: class Pow extends Operator
    eval: -> Math.pow(@left.eval(), @right.eval())
    toString: -> "#{@left} ^ #{@right}"
  #
  # OR
  #
  OR: class OR extends Operator
    eval: -> @left.eval() or @right.eval()
    toString: -> "#{@left} OR #{@right}"
  #
  # AND
  #
  AND: class AND extends Operator
    eval: -> @left.eval() and @right.eval()
    toString: -> "#{@left} AND #{@right}"
  #
  # NOT
  #
  NOT: class NOT extends Operator
    eval: -> not @left.eval()
    toString: -> "NOT #{@left}"
  #
  # <
  #
  LT: class LT extends Operator
    eval: -> @left.eval() < @right.eval()
    toString: -> "#{@left} < #{@right}"
  #
  # >
  #
  GT: class GT extends Operator
    eval: -> @left.eval() > @right.eval()
    toString: -> "#{@left} > #{@right}"
  #
  # <=
  #
  LE: class LE extends Operator
    eval: -> @left.eval() <= @right.eval()
    toString: -> "#{@left} <= #{@right}"
  #
  # >=
  #
  GE: class GE extends Operator
    eval: -> @left.eval() >= @right.eval()
    toString: -> "#{@left} >= #{@right}"
  #
  # ==
  #
  EQ: class EQ extends Operator
    eval: -> if @left.eval() is @right.eval() then true else false
    toString: -> "#{@left} = #{@right}"
  #
  # !=
  #
  NE: class NE extends Operator
    eval: -> if @left.eval() isnt @right.eval() then true else false
    toString: -> "#{@left} <> #{@right}"




  #
  # User Defined Functions
  #
  FN: class FN
    constructor: (@name, @parm) ->
    eval:     -> _fn[@name](@parm.eval())
    toString: -> "#{@name}(#{@parm})"

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
    eval: -> Math.random() #@$0.eval())
  SGN: class SGN extends BuiltIn
    eval: ->
      $0 = @$0.eval
      if $0 < 0 then -1 else if $0 > 0 then 1 else 0
  SIN: class SIN extends BuiltIn
    eval: -> Math.sin(@$0.eval())
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


if window? then window.katra = katra else module.exports = katra
