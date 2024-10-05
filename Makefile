.PHONY: default
default: hello

ifdef SCHEME
ifeq ($(shell command -v $(SCHEME)),)
$(error SCHEME=$(SCHEME) does not exist)
endif
else
SCHEME := $(or $(shell command -v scheme),$(shell command -v chez),$(error can't find a SCHEME))
endif

CHEZ_PATH ?= $(shell readlink -f $(SCHEME))
CHEZ_LIB_PATH ?= $(shell dirname $(CHEZ_PATH))

XXD ?= xxd

# petite has to be first or we get "S_G.base-rtd has not been set".
hello.boot: $(CHEZ_LIB_PATH)/petite.boot *.ss
	$(CHEZ_PATH) --script ./build $@ $?

boot.h: hello.boot
	$(XXD) -include -name bootfile $< $@

hello: boot.h main.c
	$(CC) -std=c17 -Wall -Wextra -Wpedantic $(CFLAGS) -o $@ \
		-I$(CHEZ_LIB_PATH) \
		$(CHEZ_LIB_PATH)/libkernel.a \
		$(CHEZ_LIB_PATH)/libz.a \
		$(CHEZ_LIB_PATH)/liblz4.a \
		-liconv -lncurses \
		main.c

.PHONY: clean
clean:
	rm -f hello boot.h hello.boot
