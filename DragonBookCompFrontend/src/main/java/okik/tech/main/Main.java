package okik.tech.main;

import java.io.*;
import okik.tech.parser.Parser;
import okik.tech.lexer.*;

public class Main {
    public static void main(String[] args) throws IOException {
        Lexer lex = new Lexer();
        Parser parse = new Parser(lex) ;
        parse.program();
        System.out.write('\n');
    }
}