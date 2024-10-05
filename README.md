# chez-executable
Build an executable from a [Chez Scheme](https://github.com/cisco/ChezScheme)
program for UNIX-like systems.

Just builds an example program now; may transform into a utility to build
arbitrary programs later.

Bare `make` builds an executable `./hello` from the program defined in
`hello.ss`.

Currently only builds in the Petite Chez Scheme boot file, which is unable to
compile new code at runtime.
