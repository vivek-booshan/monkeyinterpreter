package lexer

import "core:fmt"
import "core:unicode"

Token :: struct {
	Type:    TokenType,
	Literal: string,
}

TokenType :: enum {
	ILLEGAL,
	EOF,
	IDENT,
	INT,

	// One Character
	ASSIGN, // =
	PLUS, // +
	COMMA, // ,
	SEMICOLON, // ;
	LPAREN, // (
	RPAREN, // )
	LBRACE, // {
	RBRACE, // }
	BANG, // !
	MINUS, // -
	FSLASH, // /
	ASTERISK, // *
	LT, // <
	GT, // >

	// Two Character
	EQ, // == 
	NEQ, // !=
	LEQ, // <=
	GEQ, // >=

	// Keyword
	FUNCTION, // fn
	LET, // let
	IF, // if
	ELSE, // else
	TRUE, // true
	FALSE, // false
	RETURN, // return
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
	// TODO: switch case is O(N) in worst case, should either make
	// sub switches or convert to token table 
	switch r {
	case '=':
		if peek(l) == '=' {
			tok = newToken(TokenType.EQ, "==")
			l.idx += 1
		} else {
			tok = newToken(TokenType.ASSIGN, "=")
		}
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
	case '-':
		tok = newToken(TokenType.MINUS, "-")
	case '*':
		tok = newToken(TokenType.ASTERISK, "*")
	case '/':
		tok = newToken(TokenType.FSLASH, "/")
	case '<':
		if peek(l) == '=' {
			tok = newToken(TokenType.LEQ, "<=")
			l.idx += 1
		} else {
			tok = newToken(TokenType.LT, "<")
		}
	case '>':
		if peek(l) == '=' {
			tok = newToken(TokenType.GEQ, ">=")
			l.idx += 1
		} else {
			tok = newToken(TokenType.GT, ">")
		}
	case '{':
		tok = newToken(TokenType.LBRACE, "{")
	case '}':
		tok = newToken(TokenType.RBRACE, "}")
	case '!':
		if peek(l) == '=' {
			tok = newToken(TokenType.NEQ, "!=")
			l.idx += 1
		} else {
			tok = newToken(TokenType.BANG, "!")
		}
	case 'a' ..= 'z':
		switch word := getIdent(l); word {
		case "let":
			tok = newToken(TokenType.LET, "let")
		case "fn":
			tok = newToken(TokenType.FUNCTION, "fn")
		case "if":
			tok = newToken(TokenType.IF, "if")
		case "else":
			tok = newToken(TokenType.ELSE, "else")
		case "return":
			tok = newToken(TokenType.RETURN, "return")
		case "true":
			tok = newToken(TokenType.TRUE, "true")
		case "false":
			tok = newToken(TokenType.FALSE, "false")
		case:
			tok = newToken(TokenType.IDENT, word)
		}
	case '0' ..= '9':
		num := getNum(l)
		tok = newToken(TokenType.INT, num)
	case 0:
		tok = newToken(TokenType.EOF)
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

peek :: proc(l: ^Lexer) -> u8 {
	return l.input[l.idx + 1]
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

