package token


Token :: struct {
	Type:    TokenType,
	Literal: []u8,
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

