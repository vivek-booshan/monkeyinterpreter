package lexer

import "core:fmt"
import "core:log"
import "core:testing"

@(test)
testNextToken :: proc(t: ^testing.T) {
	input :: "=+(){},;"
	tests := []Token {
		{.ASSIGN, '='},
		{.PLUS, '+'},
		{.LPAREN, '('},
		{.RPAREN, ')'},
		{.LBRACE, '{'},
		{.RBRACE, '}'},
		{.COMMA, ','},
		{.SEMICOLON, ';'},
		{.EOF, 0},
	}

	lexer: Lexer
	init(&lexer, input)

	for testToken, i in tests {
		tok := nextToken(&lexer)
		log.infof("token: %q %r", testToken.Type, testToken.Literal)
		testing.expectf(t, tok.Type == testToken.Type, "%i : Unequal Token Type %q", i, tok.Type)
		testing.expectf(
			t,
			tok.Literal == testToken.Literal,
			"%i : Unequal Token Literal %r",
			i,
			tok.Literal,
		)
	}
}

