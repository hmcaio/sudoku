#!/usr/bin/perl
# Filter between the game and the terminal: translates the CP437 glyph bytes the
# game writes into UTF-8. The game (Free Pascal crt) counts one byte per screen
# column, so the translation has to happen after crt, not inside the source.
use strict;
use warnings;

my %glyph = (
    "\x10" => "\xE2\x96\xBA",
    "\x1E" => "\xE2\x96\xB2",
    "\xB2" => "\xE2\x96\x92",
    "\xB3" => "\xE2\x94\x82",
    "\xB4" => "\xE2\x94\xA4",
    "\xBF" => "\xE2\x94\x90",
    "\xC0" => "\xE2\x94\x94",
    "\xC1" => "\xE2\x94\xB4",
    "\xC2" => "\xE2\x94\xAC",
    "\xC3" => "\xE2\x94\x9C",
    "\xC4" => "\xE2\x94\x80",
    "\xC5" => "\xE2\x94\xBC",
    "\xD9" => "\xE2\x94\x98",
    "\xDA" => "\xE2\x94\x8C",
);

binmode STDIN;
binmode STDOUT;
while (sysread(STDIN, my $buf, 65536)) {
    $buf =~ s/([\x10\x1E\xB2-\xB4\xBF-\xC5\xD9\xDA])/$glyph{$1}/g;
    syswrite(STDOUT, $buf);
}
