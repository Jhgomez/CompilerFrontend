// Expression implements Node
// BinaryExpresion implements Expression(left: Expression, right: Expression, operator: String) +-*/
// UnaryExpresion implements Expression(operand: Expression, operator: String) ! or -(minus)
// LiteralExpression implements Expression(value: Number)
// VariableExpression implements Expression(name: String)

class Expression {
    constructor() {
        this.location = null;
    }
}


