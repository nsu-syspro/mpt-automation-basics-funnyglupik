NAME := $(shell jq -r .name config.json)
VERSION := $(shell jq -r .version config.json)

SRC := src/wordcount.c
BUILD_DIR := build
TARGET := $(BUILD_DIR)/$(NAME)

all: $(TARGET)

COMP_ARGS := -DNAME=\"$(NAME)\" -DVERSION=\"$(VERSION)\"
$(TARGET): $(SRC) config.json | $(BUILD_DIR)
	gcc $(COMP_ARGS) -o $(TARGET) $(SRC)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

TESTS := $(wildcard test/*.txt)
check: $(TARGET)
	@for test in $(TESTS); do \
		exp_result="$${test%.txt}.expected"; \
		./$(TARGET) < "$$test" > .result; \
		if ! diff -q "$$exp_result" .result > /dev/null; then \
			echo "Test $$test failed but I won't"; \
			diff "$$exp_result" .result; \
			rm -f .result; \
			exit 1; \
		fi; \
	done
	@rm -f .result

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean
