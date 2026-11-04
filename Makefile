NAME := $(shell jq -r .name config.json)
VERSION := $(shell jq -r .version config.json)
TARGET := build/$(NAME)

all: $(TARGET)

$(TARGET): src/wordcount.c config.json | build
	gcc -DNAME=\"$(NAME)\" -DVERSION=\"$(VERSION)\" -o $@ $<

build:
	mkdir -p $@

clean:
	rm -rf build

check: $(patsubst test/%.txt,test/%.check,$(wildcard test/*.txt))

test/%.check: test/%.txt test/%.expected $(TARGET)
	@actual=$$(./$(TARGET) < $<); \
	expected=$$(cat test/$*.expected); \
	if [ "$$actual" != "$$expected" ]; then \
		echo "$$actual" | diff test/$*.expected -; \
		exit 1; \
	fi

.PHONY: all clean check
