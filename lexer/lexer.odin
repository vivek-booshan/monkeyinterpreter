package lexer

Token :: struct {
	Type:    TokenType,
	// Literal: []u8,
	Literal: rune,
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
	input:        string,
	position:     int,
	readPosition: int,
	idx:          int, // current rune index
}

init :: proc(l: ^Lexer, input: string) {
	l.input = input
}

newToken :: proc(tokenType: TokenType, r: rune) -> Token {
	return Token{Type = tokenType, Literal = r}
}

createTokenFromRune :: proc(r: rune) -> Token {
	tok: Token

	switch r {
	case '=':
		tok = newToken(TokenType.ASSIGN, r)
	case ';':
		tok = newToken(TokenType.SEMICOLON, r)
	case '(':
		tok = newToken(TokenType.LPAREN, r)
	case ')':
		tok = newToken(TokenType.RPAREN, r)
	case ',':
		tok = newToken(TokenType.COMMA, r)
	case '+':
		tok = newToken(TokenType.PLUS, r)
	case '{':
		tok = newToken(TokenType.LBRACE, r)
	case '}':
		tok = newToken(TokenType.RBRACE, r)
	case 0:
		tok = newToken(TokenType.EOF, r)
	}
	return tok
}

nextToken :: proc(l: ^Lexer) -> Token {
	if l.idx >= len(l.input) {
		return createTokenFromRune(0)
	}
	tok := createTokenFromRune(rune(l.input[l.idx]))
	l.idx += 1
	return tok
}

