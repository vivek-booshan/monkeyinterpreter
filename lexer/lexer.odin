package lexer

import "../token"
import "core:strings"
Lexer :: struct {
	input:        string,
	position:     int,
	readPosition: int,
	ch:           rune,
}

init :: proc(input: string) -> ^Lexer {
	lexer := &Lexer{input = input}
	readRune(lexer)
	return lexer
}

destroy :: proc(l: ^Lexer) {
	free(l)
	return
}

readRune :: proc(l: ^Lexer) {
	if l.readPosition >= len(l.input) {
		l.ch = 0
	} else {
		l.ch = cast(rune)l.input[l.readPosition]
	}
	l.position = l.readPosition
	l.readPosition += 1
}

nextToken :: proc(l: ^Lexer) -> token.Token {
	tok: token.Token

	switch l.ch {
	case '=':
		tok = newToken(token.TokenType.ASSIGN, l.ch)
	case ';':
		tok = newToken(token.TokenType.SEMICOLON, l.ch)
	case '(':
		tok = newToken(token.TokenType.LPAREN, l.ch)
	case ')':
		tok = newToken(token.TokenType.RPAREN, l.ch)
	case ',':
		tok = newToken(token.TokenType.COMMA, l.ch)
	case '+':
		tok = newToken(token.TokenType.PLUS, l.ch)
	case '{':
		tok = newToken(token.TokenType.LBRACE, l.ch)
	case '}':
		tok = newToken(token.TokenType.RBRACE, l.ch)
	case 0:
		tok.Literal = ""
		tok.Type = token.TokenType.EOF
	}

	readRune(l)
	return tok
}

newToken :: proc(tokenType: token.TokenType, ch: rune) -> token.Token {
	return token.Token{tokenType, cast(string)ch}
}

