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

	lexer: Lexer
	init(&lexer, input)

	for testToken, i in tests {
		tok: Token
		nextToken(&lexer, &tok)
		log.infof("token: %q %s", testToken.Type, testToken.Literal)
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

@(test)
testNextToken2 :: proc(t: ^testing.T) {
	input := "let five = 5;\nlet ten = 10;\n\nlet add = fn(x, y) {\n x + y; };\n\n let result = add(five, ten);"
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

