package okik.tech.inter;

import okik.tech.lexer.*;
import okik.tech.symbols.*;

public class Logical extends Expr {
    public Expr expr1, expr2;

    Logical(Token tok, Expr x1, Expr x2) {
        super (tok, null);      // null type to start
        expr1 = x1;
        expr2 = x2;
        type = check(expr1.type, expr2.type) ;
        if (type == null) error("type error");
    }

    public Type check(Type p1, Type p2) {
        if (p1 == Type.Bool && p2 == Type.Bool) return Type.Bool;
        else return null;
    }

    public Expr gen() {
        int f = newLabel();
        int a = newLabel();
        Temp temp = new Temp(type) ;
        this.jumping (0,f);
        emit (temp + " = true");
        emit ("goto L" + a);
        emitLabel(f);
        emit(temp + " = false");
        emitLabel(a);
        return temp;
    }

    public String toString() {
        return expr1.toString() + " " + op.toString() + " " + expr2.toString();
    }
}
