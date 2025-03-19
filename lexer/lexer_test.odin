package lexer

import token "../token"
import "core:fmt"
import "core:testing"

@(test)
testNextToken :: proc(t: ^testing.T) {
	input :: "=+(){},;"
	tests := []token.Token {
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

	lexer := init(input)
	defer destroy(lexer)

	for testToken, i in tests {
		tok := nextToken(lexer)

		testing.expectf(t, tok.Type == testToken.Type, "%i : Unequal Token Type", i)
		testing.expectf(t, tok.Literal == testToken.Literal, "%i : Unequal Token Literal", i)

		// if tok.Type != testToken.Type {
		// 	fmt.eprintln("tests[%d] - expected=%q, got%q", i, testToken.Type, testToken.Type)
		// }

		// if tok.Literal != testToken.Literal {

		// 	fmt.eprintln("tests[%d] - expected=%q, got%q", i, testToken.Literal, testToken.Literal)
		// }
	}
}

