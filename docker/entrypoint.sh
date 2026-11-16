#!/bin/sh
# Run the game on its own pty (crt needs a terminal on stdout) and translate its
# CP437 glyphs to UTF-8 on the way to the real terminal (see cp437-to-utf8.pl).
script -qf -c sudoku /dev/null | perl /usr/local/bin/cp437-to-utf8.pl
