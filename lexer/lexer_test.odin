package lexer

import "core:log"
import "core:testing"

@(test)
testNextToken :: proc(t: ^testing.T) {
	input :: "=+(){},;"
	tests := []Token {
		{.ASSIGN, "="},
		{.PLUS, "+"},
		{.LPAREN, "("},
		{.RPAREN, ")"},
		{.LBRACE, "{"},
		{.RBRACE, "}"},
		{.COMMA, ","},
		{.SEMICOLON, ";"},
		{.EOF, ""},
	}

	check(t, input, &tests)
}

@(test)
testNextToken2 :: proc(t: ^testing.T) {
	// input := "let five = 5;\nlet ten = 10;\n\nlet add = fn(x, y) {\n x + y; };\n\n let result = add(five, ten);"
	input := `
		let five = 5;
		let ten = 10;
		let add = fn(x, y) {
		x + y;
		};
		let result = add(five, ten);`
	tests := []Token {
		{.LET, "let"},
		{.IDENT, "five"},
		{.ASSIGN, "="},
		{.INT, "5"},
		{.SEMICOLON, ";"},
		{.LET, "let"},
		{.IDENT, "ten"},
		{.ASSIGN, "="},
		{.INT, "10"},
		{.SEMICOLON, ";"},
		{.LET, "let"},
		{.IDENT, "add"},
		{.ASSIGN, "="},
		{.FUNCTION, "fn"},
		{.LPAREN, "("},
		{.IDENT, "x"},
		{.COMMA, ","},
		{.IDENT, "y"},
		{.RPAREN, ")"},
		{.LBRACE, "{"},
		{.IDENT, "x"},
		{.PLUS, "+"},
		{.IDENT, "y"},
		{.SEMICOLON, ";"},
		{.RBRACE, "}"},
		{.SEMICOLON, ";"},
		{.LET, "let"},
		{.IDENT, "result"},
		{.ASSIGN, "="},
		{.IDENT, "add"},
		{.LPAREN, "("},
		{.IDENT, "five"},
		{.COMMA, ","},
		{.IDENT, "ten"},
		{.RPAREN, ")"},
		{.SEMICOLON, ";"},
		{.EOF, ""},
	}
	check(t, input, &tests)
}

@(test)
testNextToken3 :: proc(t: ^testing.T) {
	input := `
		!-/*5;
		5 < 10 > 5;`

	tests := []Token {
		{.BANG, "!"},
		{.MINUS, "-"},
		{.FSLASH, "/"},
		{.ASTERISK, "*"},
		{.INT, "5"},
		{.SEMICOLON, ";"},
		{.INT, "5"},
		{.LT, "<"},
		{.INT, "10"},
		{.GT, ">"},
		{.INT, "5"},
		{.SEMICOLON, ";"},
		{.EOF, ""},
	}

	check(t, input, &tests)
}

@(test)
testNextToken4 :: proc(t: ^testing.T) {
	input := `let five = 5;
		let ten = 10;
		let add = fn(x, y) {
		x + y;
		};
		let result = add(five, ten);
		!-/*5;
		5 < 10 > 5;
		if (5 < 10) {
		return true;
		} else {
		return false;
		}`
	tests := []Token {
		{.LET, "let"},
		{.IDENT, "five"},
		{.ASSIGN, "="},
		{.INT, "5"},
		{.SEMICOLON, ";"},
		{.LET, "let"},
		{.IDENT, "ten"},
		{.ASSIGN, "="},
		{.INT, "10"},
		{.SEMICOLON, ";"},
		{.LET, "let"},
		{.IDENT, "add"},
		{.ASSIGN, "="},
		{.FUNCTION, "fn"},
		{.LPAREN, "("},
		{.IDENT, "x"},
		{.COMMA, ","},
		{.IDENT, "y"},
		{.RPAREN, ")"},
		{.LBRACE, "{"},
		{.IDENT, "x"},
		{.PLUS, "+"},
		{.IDENT, "y"},
		{.SEMICOLON, ";"},
		{.RBRACE, "}"},
		{.SEMICOLON, ";"},
		{.LET, "let"},
		{.IDENT, "result"},
		{.ASSIGN, "="},
		{.IDENT, "add"},
		{.LPAREN, "("},
		{.IDENT, "five"},
		{.COMMA, ","},
		{.IDENT, "ten"},
		{.RPAREN, ")"},
		{.SEMICOLON, ";"},
		{.BANG, "!"},
		{.MINUS, "-"},
		{.FSLASH, "/"},
		{.ASTERISK, "*"},
		{.INT, "5"},
		{.SEMICOLON, ";"},
		{.INT, "5"},
		{.LT, "<"},
		{.INT, "10"},
		{.GT, ">"},
		{.INT, "5"},
		{.SEMICOLON, ";"},
		{.IF, "if"},
		{.LPAREN, "("},
		{.INT, "5"},
		{.LT, "<"},
		{.INT, "10"},
		{.RPAREN, ")"},
		{.LBRACE, "{"},
		{.RETURN, "return"},
		{.TRUE, "true"},
		{.SEMICOLON, ";"},
		{.RBRACE, "}"},
		{.ELSE, "else"},
		{.LBRACE, "{"},
		{.RETURN, "return"},
		{.FALSE, "false"},
		{.SEMICOLON, ";"},
		{.RBRACE, "}"},
		{.EOF, ""},
	}

	check(t, input, &tests)
}
check :: check_string

check_string :: proc(t: ^testing.T, input: string, tests: ^[]Token) {
	lexer: Lexer
	init(&lexer, input)
	for testToken, i in tests {
		tok: Token
		nextToken(&lexer, &tok)
		log.infof("token: %q %s", tok.Type, tok.Literal)
		testing.expectf(
			t,
			tok.Type == testToken.Type,
			"%i : Unequal Token Type %q, got %q",
			i,
			testToken.Type,
			tok.Type,
		)
		testing.expectf(
			t,
			tok.Literal == testToken.Literal,
			"%i : Unequal Token Literal %s, got %s",
			i,
			testToken.Literal,
			tok.Literal,
		)
	}
}

