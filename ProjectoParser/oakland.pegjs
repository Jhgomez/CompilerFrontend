{
  const createNode = (nodeType, properties) => {
    const types = {
      'struct': nodes.Struct,
      'function': nodes.Function,
      'parameter': nodes.Parameter,
      'type': nodes.Type,
      'break': nodes.Break,
      'continue': nodes.Continue,
      'return': nodes.Return,
      'setVar': nodes.SetVar,
      'setProperty': nodes.SetProperty,
      'getVar': nodes.GetVar,
      'getProperty': nodes.GetProperty,
      'functionCall': nodes.FunctionCall,
      'structInstance': nodes.StructInstance,
      'parenthesis': nodes.Parenthesis,
      'ternary': nodes.Ternary,
      'binary': nodes.Binary,
      'unary': nodes.Unary,
      'literal': nodes.Literal,
      'structArg': nodes.StructArg,
      'funArgs': nodes.FunArgs,
      'varDecl': nodes.VarDecl,
      'varDefinition': nodes.VarDefinition,
      'block': nodes.Block,
      'forEach': nodes.ForEach,
      'for': nodes.For,
      'while': nodes.While,
      'switch': nodes.Switch,
      'if': nodes.If,
      'typeof': nodes.TypeOf,
      'arrayDef': nodes.ArrayDef,
      'arrayInit': nodes.ArrayInit,
      // '': nodes.,
      // '': nodes.,      
      // '': nodes.,
      // '': nodes.,
      // '': nodes.,
      // '': nodes.,
    }


    try {
      const node = new types[nodeType](properties)
    // node.location = location()  // location() is a peggy function that indicates where this node is in the source code
    return node 
    } catch (error) {
      console.log(error)
    }
    
  }
}

File 
  = _ entries:( Statement / Struct )* _ { return entries }

Struct = "struct" _ structName:Id _ "{" _ props:( type:Id _ name:Id _ ";" _ { return { type, name } })+ _ "}" _ { return createNode('struct', { structName, props }) }

Statement
  = declarativeStatement: DeclarativeStatement _ { return declarativeStatement }
  / nonDeclarativeStatement: NonDeclarativeStatement _ { return nonDeclarativeStatement }

FlowControlStatement
	= declarativeStatement: DeclarativeStatement _ { return declarativeStatement }
  / nonDeclarativeStatement: FControlInsideStatement _ { return nonDeclarativeStatement }

FunctionStatement
	= returnExpression:Return _ { return returnExpression}
  / declarativeStatement: DeclarativeStatement _ { return declarativeStatement }
  / nonDeclarativeStatement: FStatement _ { return nonDeclarativeStatement }
 
FunctionFlowControlStatement 
  = returnExpression:Return _ { return returnExpression}
  / declarativeStatement: DeclarativeStatement _ { return declarativeStatement }
  / nonDeclarativeStatement: FunFlowControlInsideStatement _ { return nonDeclarativeStatement }

NonDeclarativeStatement
  = Block
  / FlowControl
  / expression:Expression _ ";" { return expression }
  / Function

FControlInsideStatement 
  = FlowControlBlock 
  / TransferStatement 
  / FlowControl
  / expression:Expression _ ";" { return expression }
  / Function

FunFlowControlInsideStatement 
  = FunFlowControlBlock 
  / TransferStatement
  / Return
  / FlowControl
  / expression:Expression _ ";" { return expression }
  / Function

FStatement
  =  FunctionBlock
  / FunFlowControl
  / expression:Expression _ ";" { return expression }
  / Function


Function = returnType:Type _ id:Id _ "("
    _ params:( paramLeft: Parameter paramsRight:(_ "," _ paramsRight:Parameter { return paramsRight })*  { return [paramLeft, ...paramsRight] } )? 
    _ ")" _ body:FunctionBlock { 
      return createNode('function', { returnType, id, params: params || [], body}) 
    }

Parameter = type:Type _ id:Id { return createNode('parameter', { type, id }) }

TransferStatement
  = "break" _ ";" { return createNode('break') }
  / "continue" _ ";" { return createNode('continue') }

Return = "return" _ expression:Expression? _ ";" { return createNode('return', { expression }) }

FunFlowControl
  = "if" _ "(" _ condition:Expression _ ")" 
      _ statementsTrue:FunFlowControlInsideStatement 
      statementsFalse:(_ "else " _ statements:FunFlowControlInsideStatement { return statements } )?
      { return createNode('if', { condition, statementsTrue, statementsFalse }) }
  / "switch" _ "(" _ subject:Expression _ ")" _ "{" 
      cases:( 
        _ "case" _ compareTo:Expression _ ":" 
          statements:(
            _ statement:FunctionFlowControlStatement _ { return statement }
          )* { return { compareTo, statements } }
        )* 
        _ defaultCase:("default" _ ":" _ statements:FunctionFlowControlStatement* { return { compareTo: 'default', statements}} 
      )?
    _"}" { 
      return createNode('switch', { subject, cases: [...cases, defaultCase] }) 
    }
  / "while" _ "(" _ condition:Expression _ ")" _ statements:FunFlowControlInsideStatement { return createNode('while', { condition, statements }) }
  / ForFunVariation

ForFunVariation
  = "for" _ "(" 
      _ variable:(
          dcl:DeclarativeStatement { return dcl }
          / dcl:Expression _ ";" { return dcl }
          / _ ";" { return 'empty'}
        )
      _ condition:Expression? _ ";"
      _ updateExpression:Expression? _ 
      ")" 
      _ body:FunFlowControlInsideStatement { 
      return createNode('for', { variable: variable != 'empty' ? variable : null, condition, updateExpression, body }) 
    }
  / "for" _ "(" _ decl:(type:"var"/ type:Type) _ varName:Id _ ":" _ arrayRef: Expression _")" _ statements:FunFlowControlInsideStatement {
      const varType = decl != "var" ? decl : undefined
      return createNode('forEach', { varType  , varName , arrayRef, statements }) 
    } // TODO in interpreter we need to see if statement is of type null or just var or property reference

FlowControl
  = "if" _ "(" _ condition:Expression _ ")" 
      _ statementsTrue:FControlInsideStatement 
      statementsFalse:(_ "else " _ statements:FControlInsideStatement { return statements })?
      { return createNode('if', { condition, statementsTrue, statementsFalse }) }
  / "switch" _ "(" _ subject:Expression _ ")" _ "{" 
      cases:( 
        _ "case" _ compareTo:Expression _ ":" 
          statements:(
            _ statement:FlowControlStatement { return statement }
          )* { return { compareTo, statements } }
        )* 
        _ defaultCase:("default" _ ":" _ statements:FlowControlStatement* { return { compareTo: 'default', statements}} 
      )?
    _"}" { 
      return createNode('switch', { subject, cases: [...cases, defaultCase] }) 
    }
  / "while" _ "(" _ condition:Expression _ ")" _ statements:FControlInsideStatement { return createNode('while', { condition, statements }) }
  / ForVariation

ForVariation
  = "for" _ "(" 
      _ variable:(
          dcl:DeclarativeStatement { return dcl }
          / dcl:Expression _ ";" { return dcl }
          / _ ";" { return 'empty'}
        )
      _ condition:Expression? _ ";"
      _ updateExpression:Expression? _ 
      ")" 
      _ body:FControlInsideStatement { 
      return createNode('for', { variable: variable != 'empty' ? variable : null, condition, updateExpression, body }) 
    }
  / "for" _ "(" _ decl:(type:"var"/ type:Type) _ varName:Id _ ":" _ arrayRef: Expression _")" _ statements:FControlInsideStatement {
      const varType = decl != "var" ? decl : undefined
      return createNode('forEach', { varType  , varName , arrayRef, statements }) 
    } // TODO in interpreter we need to see if statement is of type null or just var or property reference

FlowControlBlock = "{" _ statements:FlowControlStatement* _ "}" { return createNode('block', { statements }) }

FunctionBlock = "{" _ statements:FunctionStatement* _ "}" { return createNode('block', { statements }) }

FunFlowControlBlock = "{" _ statements:FunctionFlowControlStatement* _ "}" { return createNode('block', { statements }) }

Block 
  = "{" _ statements:Statement* _ "}" { return createNode('block', { statements }) }

DeclarativeStatement
  = "var" _ name:Id _ assigment:("=" _ value:Expression { return value })? _ ";" {
    if (!assigment){ 
      const loc = location()
      throw new Error('variable has to have a value at line ' + loc.start.line + ' column ' + loc.start.column)
    }
    return createNode('varDecl', { name, value: assigment }) 
  }
  / type:Type _ name:Id _ value:("=" _ expression:Expression _ { return expression } )? _ ";" { return createNode('varDefinition', { type, name, value }) }

Expression 
  = Assignment

Assignment
  = assignee:Call _ assignments:(operator:("+=" / "-="/ "=") _ assignment:Assignment { return { operator, assignment}})+ { 
      return assignments.reduce(
        (prevAssignee, currentAssignee) => {
          const {operator, assignment} = currentAssignee
          // first iteration IFs
          if(prevAssignee instanceof nodes.GetVar) 
            return createNode('setVar', { assignee: prevAssignee, operator, assignment })
          if(prevAssignee instanceof nodes.GetProperty)
            return createNode('setProperty', { assignee: prevAssignee, operator, assignment })

          // recursive assignment IFs
          if(prevAssignee instanceof nodes.SetVar || prevAssignee instanceof nodes.GetProperty) {
            const prevAssignment = prevAssignee.assigment
            if ((prevAssignment instanceof nodes.GetVar))
              return createNode('setVar', { assignee: prevAssignee, operator, assignment })
            if ((prevAssignment instanceof nodes.GetProperty))
              return createNode('setProperty', { assignee: prevAssignee, operator, assignment })
          } 
          
          const loc = location()
          throw new Error('Invalind assignment ' + assignment +  ' call  at line ' + loc.start.line + ' column ' + loc.start.column)
        },
        assignee
      )
    }
  / Ternary 

Ternary 
  = logicalExpression:Logical _ "?" _ nonDeclStatementTrue:Ternary _ ":" _ nonDeclStatementFalse:Ternary { return createNode('ternary', { logicalExpression, nonDeclStatementTrue, nonDeclStatementFalse }) }
  / Logical

Logical
  = left:Equality right:(_ operator:("&&"/"||") _ rightExpression:Equality { return { operator, rightExpression }})* {
      return right.reduce(
        (prevOperation, currentOperation) => {
          const {operator, rightExpression} = currentOperation
          return createNode('binary', { operator, left: prevOperation, right: rightExpression }) 
        },
        left
      )
    }

Equality
  = left:Comparisson right:(_ operator:("=="/"!=") _ rightExpression:Comparisson { return { operator, rightExpression }})* { 
      return right.reduce(
        (prevOperation, currentOperation) => {
          const {operator, rightExpression} = currentOperation
          return createNode('binary', { operator, left: prevOperation, right: rightExpression }) 
        },
        left
      )
    }
  

Comparisson
  = left:Additive right:(_ operator:(">=" / ">" / "<=" / "<") _ rightExpression:Additive { return { operator, rightExpression }})* { 
        const {operator, rightExpression} = right[0]
        return right.length == 0 ? left : createNode('binary', { operator, left, right: rightExpression }) 
    }

Additive
  = left:Multiplicative  right:(_ operator:FirstBinaryOperator _ rightExpression:Multiplicative  { return { operator, rightExpression }})* { 
      return right.reduce(
        (prevOperation, currentOperation) => {
          const {operator, rightExpression} = currentOperation
          return createNode('binary', { operator, left: prevOperation, right: rightExpression }) 
        },
        left
      )
  }

Multiplicative
  = left:Unary  right:(_ operator:SecondBinaryOperator _ rightExpression:Unary  { return { operator, rightExpression }})* { 
      return right.reduce(
        (prevOperation, currentOperation) => {
          const {operator, rightExpression} = currentOperation
          return createNode('binary', { operator, left: prevOperation, right: rightExpression }) 
        },
        left
      )
  }

Unary
  = operator:("-"/"!") right:Unary { return createNode('unary', { operator, right }) }
  / Call

Call 
  = callee:Primary _ actions:(
      "(" _ args:Arguments? _")" { return { type: 'functionCall', args: args.args } }
      / "." _ property:Id indexes:( _ arrayIndex:ArrayIndex { return { deep: arrayIndex.indexes } })* { return { type: 'getProperty', property, indexes: indexes } }
    )* { 
      if (!(callee instanceof nodes.Parenthesis || callee instanceof nodes.GetVar) && actions.length > 0) 
        throw new Error('illegal ' + actions.type + ' call  at line ' + location.start.line + ' column ' + location.start.column)

      return actions.reduce(
        (prevCallee, currentAction) => {
          const {type, args, indexes, property } = currentAction
          switch (type) {
            case 'functionCall':
              { return createNode('functionCall', { callee: prevCallee, args: args || []}) } 
            case 'getProperty':
              { return createNode('getProperty', { callee: prevCallee, name: property, indexes: indexes.map(entry => entry.index) }) } 
          }
        },
        callee
     )
    }

ArrayIndex = "[" _ index:Number _"]" { 
    if (index.type != 'integer') {
      const loc = location()
      throw new Error('Invalind index ' + index.value +  ' at line ' + loc.start.line + ' column ' + loc.start.column)
    }
    return { index: index.value } 
  }

Arguments = arg:Expression _ args:("," _ argument:Expression { return argument } )* { 
  return createNode('funArgs', { args: [arg, ...args] }) 
}

Primary
  = Primitve
  / "(" _ expression:Expression _ ")" { return createNode('parenthesis', { expression }) }
  / "null" { return createNode('literal', { type: 'null', value: null }) }
  / "typeof" _ expression:Expression _ { return createNode('typeof', { expression }) }
  / name:Id _ action:( 
      "{" _ args:StructArg _ "}" { return { type: 'constructor', args } }
      / _ indexes:ArrayIndex* { return { type: 'getArray', indexes: indexes.map(entry => entry.index) } }
    )? {
      const { type, args, indexes } = action
      if (type == 'constructor') {
        return createNode('structInstance', { name, args })   
      }

      if (type == 'getArray'){
        // else is a var refercne
        return createNode('getVar', { name, indexes }) 
      }
    }

StructArg = id:Id _ ":" _ expression:Expression args:(_ "," _ arg:StructArg { return arg } )* { 
  const enforcedArg = createNode('structArg', { id, expression }) 
  return [enforcedArg, ...args].flatMap(arg => arg)
}

Primitve 
  = Number
  / String
  / Boolean
  / Char
  / Array

String
  = "\"" string:(!["'].)* "\"" { return createNode('literal', { type: 'string', value: string.flatMap(s => s).join("") }) } 

Boolean = value:("true" / "false") { return createNode('literal', { type: 'boolean', value: value == "true"}) } 

Char = "'" character:(!["'].)? "'" { return createNode('literal', { type: 'char', value: character.flatMap(s => s).join("") }) } 

Array 
  = "{" _ element:Primary? elements:(_ "," _ elementRight:Primary { return elementRight } )* _ "}" { return createNode('arrayDef', { type:element.type + 'array' ,elements:[element, elements].flatMap(val => val) }) }
  / "new" _ type:Id _ levelsSize:("[" _ index:[0-9]+ _"]" { return parseInt(index.join(""), 10) })+ { return createNode('arrayInit', { type: type + 'array', levelsSize }) }

Number 
  = whole:[0-9]+decimal:("."[0-9]+)? {
      return createNode(
          'literal', 
          decimal 
            ? { type: 'float', value: parseFloat(whole.join("")+decimal.flatMap(n => n).join(""), 10) }
            : { type: 'integer', value: parseInt(whole.join(""), 10) }
        )
    }


FirstBinaryOperator = "+"/ "-"

SecondBinaryOperator = "*"/ "/"/ "%"

Id 
  = [_a-zA-Z][0-9a-zA-Z_]* { return text() }

Type = type:Id _ arrayLevel:("[" _ "]")* { return createNode('type', { type, arrayLevel: arrayLevel.length }) }

Types 
  = "int" / "float" / "string" / "boolean" / "char" / "Array"

FTypes 
  = "int" / "float" / "string" / "boolean" / "char" / "Array" / "void"

Comment 
  = 
  "//" (![\n].)*
  / "/*" (!("*/").)* "*/"

_ "whitespace"
  = (Comment / [ \t\n\r])*