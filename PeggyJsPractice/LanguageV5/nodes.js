class Statement {
    constructor() {
        this.location = null;
    }

    accept(visitor) {
        throw new Error('accept() not implemented');
    }
}

class BinaryExpresion extends Statement {
    constructor({ left, right, op }) {
        super();
        this.left = left;
        this.right = right;
        this.op = op;
    }

    accept(visitor) {
        return visitor.visitBinaryExpresion(this);
    }
}

class UnaryExpresion extends Statement {
    constructor({ expression, op }) {
        super();
        this.expression = expression;
        this.op = op;
    }

    accept(visitor) {
        return visitor.visitUnaryExpresion(this);
    }
}

class LiteralExpression extends Statement {
    constructor({ value }) {
        super();
        this.value = value;
    }

    accept(visitor) {
        return visitor.visitLiteralExpression(this);
    }
}

// ##############################################################################################3333
class Parenthesis extends Statement {
    constructor({ expression }) {
        super();
        this.expression = expression;
    }

    accept(visitor) {
        return visitor.visitParenthesis(this);
    }
}

class VariableReference  extends Statement {
    constructor({ id }) {
        super();
        this.id = id
    }

    accept(visitor) {
        return visitor.visitVariableReference(this);
    }
}

class DeclarativeStatement extends Statement {
    constructor({ id, expression }) {
        super();
        this.id = id;
        this.expression = expression;
    }

    accept(visitor) {
        return visitor.visitDeclarativeStatement(this);
    }
}

class Print extends Statement {
    constructor({ expression }) {
        super();
        this.expression = expression
    }

    accept(visitor) {
        return visitor.visitPrint(this);
    }
}

class NonDeclarativeStatement extends Statement {
    constructor({expression}) {
        super();
        this.expression = expression
    }

    accept(visitor) {
        return visitor.visitNonDeclarativeStatement(this);
    }
}

class Assignment extends Statement {
    constructor({id, expression}) {
        super();
        this.id = id
        this.expression = expression
    }

    accept(visitor) {
        return visitor.visitAssignment(this);
    }
}

class Block extends Statement {
    constructor({ statements }) {
        super();
        this.statements = statements
    }

    accept(visitor) {
        return visitor.visitBlock(this);
    }
}

class If extends Statement {
    constructor({ logicalExpression, statementTrue, statementFalse=undefined }) {
        super();
        this.logicalExpression = logicalExpression;
        this.statementTrue = statementTrue;
        this.statementFalse = statementFalse
    }

    accept(visitor) {
        return visitor.visitIf(this);
    }
}

class While extends Statement {
    constructor({ logicalExpression, statementTrue }) {
        super();
        this.logicalExpression = logicalExpression;
        this.statementTrue = statementTrue;
    }

    accept(visitor) {
        return visitor.visitWhile(this);
    }
}

export default {
    BinaryExpresion,
    UnaryExpresion,
    LiteralExpression,
    Parenthesis,
    VariableReference,
    DeclarativeStatement,
    Print,
    NonDeclarativeStatement,
    Assignment,
    Block,
    If,
    While
}