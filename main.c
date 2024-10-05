#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <scheme.h>

#include "boot.h"

int main(int argc, const char *argv[]) {
    if (strcmp(VERSION, Skernel_version()) != 0) {
        fprintf(stderr,
                "mismatched header and code scheme versions: header <%s> code <%s>\n",
                VERSION,
                Skernel_version());

        return EXIT_FAILURE;
    }

    Sscheme_init(NULL);
    Sregister_boot_file_bytes("embedded", &bootfile[0], bootfile_len);
    Sbuild_heap(NULL, NULL);
    const int status = Sscheme_start(argc, &argv[0]);
    Sscheme_deinit();
    return status;
}
