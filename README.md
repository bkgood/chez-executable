# chez-executable

Build an executable from a [Chez Scheme](https://github.com/cisco/ChezScheme)
program for UNIX-like systems.

Just builds an example program now; may transform into a utility to build
arbitrary programs later.

Bare `make` builds an executable `./hello` from the program defined in
`hello.ss`.

The resulting executable is about 2.5 MB on my arm64 Mac.

Currently only builds in the Petite Chez Scheme boot file, which is unable to
compile new code at runtime.

## Prior art

Inspired by [gwatt/chez-exe](https://github.com/gwatt/chez-exe), which extracts
different artifacts into temp files. I wanted to see if I could build
everything into, and execute everything from (modulo dynamic linking) a single
executable.
