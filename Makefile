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

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean
