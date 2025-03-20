package repl

import "../lexer"
import "core:bufio"
import "core:fmt"
import "core:os"

repl :: proc() {
	s: bufio.Scanner
	stdout: bufio.Writer
	bufio.scanner_init(&s, os.stream_from_handle(os.stdin))
	defer bufio.scanner_destroy(&s)

	PROMPT :: ">> "
	for {
		fmt.print(PROMPT)
		if scanned := bufio.scanner_scan(&s); !scanned {
			return
		}

		line := bufio.scanner_text(&s)
		l: lexer.Lexer
		lexer.init(&l, line)

		tok: lexer.Token
		for lexer.nextToken(&l, &tok); tok.Type != lexer.TokenType.EOF; {
			fmt.printfln("%v", tok)
			lexer.nextToken(&l, &tok)
		}
	}
}
main :: proc() {
	repl()
}

