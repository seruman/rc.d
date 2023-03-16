OP := $(shell command -v op 2> /dev/null)

ifndef OP
    $(error "op is not installed")
else
	TARGETS += op
endif

.PHONY: all
all: $(TARGETS)

.PHONY: op
op:
	@op completion zsh > ./completions/_op


