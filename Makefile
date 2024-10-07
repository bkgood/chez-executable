.PHONY: default
default: hello

ifdef SCHEME
ifeq ($(shell command -v $(SCHEME)),)
$(error SCHEME=$(SCHEME) does not exist)
endif
else
SCHEME := $(or $(shell command -v scheme),$(shell command -v chez),$(error can't find a SCHEME))
endif

CHEZ_PATH := $(shell readlink -f $(SCHEME))
CHEZ_LIB_PATH := $(shell dirname $(CHEZ_PATH))

XXD ?= xxd

CFLAGS = -std=c17 -Wall -Wextra -I$(CHEZ_LIB_PATH)
LDLIBS = -liconv -lncurses -lkernel -lz -llz4
LDFLAGS = -L$(CHEZ_LIB_PATH)

# petite has to be first or we get "S_G.base-rtd has not been set".
hello.boot: $(CHEZ_LIB_PATH)/petite.boot *.ss
	$(CHEZ_PATH) --script ./build $@ $?

boot.h: hello.boot
	$(XXD) -include -name bootfile $< $@

hello: main.c boot.h
	$(CC) -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $<

.PHONY: clean
clean:
	rm -f hello boot.h hello.boot
