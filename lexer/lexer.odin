package lexer

import "core:fmt"
import "core:unicode"

Token :: struct {
	Type:    TokenType,
	// Literal: []u8,
	Literal: string,
}


TokenType :: enum {
	ILLEGAL,
	EOF,
	IDENT,
	INT,
	ASSIGN,
	PLUS,
	COMMA,
	SEMICOLON,
	LPAREN,
	RPAREN,
	LBRACE,
	RBRACE,
	FUNCTION,
	LET,
}

Lexer :: struct {
	input: string,
	// position:     int,
	// readPosition: int,
	idx:   int, // current rune index
}

init :: proc(l: ^Lexer, input: string) {
	l.input = input
}

newTokenWithString :: proc(tokenType: TokenType, literal: string) -> Token {
	return Token{Type = tokenType, Literal = literal}
}

newTokenNoString :: proc(tokenType: TokenType) -> Token {
	return Token{Type = tokenType, Literal = ""}
}

newToken :: proc {
	newTokenWithString,
	newTokenNoString,
}

createToken :: proc(l: ^Lexer) -> Token {
	tok: Token

	r := l.input[l.idx]
	switch r {
	case '=':
		tok = newToken(TokenType.ASSIGN, "=")
	case ';':
		tok = newToken(TokenType.SEMICOLON, ";")
	case '(':
		tok = newToken(TokenType.LPAREN, "(")
	case ')':
		tok = newToken(TokenType.RPAREN, ")")
	case ',':
		tok = newToken(TokenType.COMMA, ",")
	case '+':
		tok = newToken(TokenType.PLUS, "+")
	case '{':
		tok = newToken(TokenType.LBRACE, "{")
	case '}':
		tok = newToken(TokenType.RBRACE, "}")
	case 0:
		tok = newToken(TokenType.EOF)
	case 'a' ..= 'z':
		switch word := getIdent(l); word {
		case "let":
			tok = newToken(TokenType.LET, "let")
		case "fn":
			tok = newToken(TokenType.FUNCTION, "fn")
		case:
			tok = newToken(TokenType.IDENT, word)
		}
	case '0' ..= '9':
		num := getNum(l)
		tok = newToken(TokenType.INT, num)
	}
	return tok
}

getIdent :: proc(l: ^Lexer) -> string {
	offset := 0
	for is_alpha(l.input[l.idx + offset]) {
		offset += 1
	}
	l.idx += offset - 1
	return l.input[l.idx - offset + 1:l.idx + 1]
}

getNum :: proc(l: ^Lexer) -> string {
	offset := 0
	for is_digit(l.input[l.idx + offset]) {
		offset += 1
	}
	l.idx += offset - 1
	return l.input[l.idx - offset + 1:l.idx + 1]
}

is_alpha :: proc(b: u8) -> bool {
	return unicode.is_alpha(cast(rune)b)
}

is_digit :: proc(b: u8) -> bool {
	return unicode.is_digit(cast(rune)b)
}

is_whitespace :: proc(b: u8) -> bool {
	return unicode.is_white_space(cast(rune)b)
}

nextToken :: proc(l: ^Lexer, tok: ^Token) {
	if l.idx >= len(l.input) {
		tok^ = newToken(TokenType.EOF)
		return
	}
	for is_whitespace(l.input[l.idx]) {
		l.idx += 1
	}
	tok^ = createToken(l)
	l.idx += 1
}

