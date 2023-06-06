build?=build
src?=src
inc?=src/include
out?=$(build)/a.out

cc?=gcc
flags?=-Wall

src_files:=$(shell find $(src) -name *.c 2> /dev/null)
obj_files:=$(subst .c,.o,$(addprefix $(build)/,$(notdir $(src_files))))

all: $(out)
	@printf "\x1b[32mBuild complete\x1b[0m\n"

$(out): $(obj_files)
	@printf "\x1b[33mLinking\x1b[0m objects\n"
	@$(cc) $^ $(flags) -o $@

$(obj_files): build/%.o : src/%.c
	@printf "\x1b[34mCompiling\x1b[0m '%s'\x1b[0m\n" $*.c
	@$(cc) -c $< $(flags) -I $(inc) -o $@

clean:
	@find $(build) -type f -exec printf "\x1b[31mRemoving\x1b[0m %s\n" {} \; -exec rm -r {} 2> /dev/null \;

rebuild: clean all run

setup:
	@if [ ! -d "$(build)" ]; then printf "\x1b[35mCreating\x1b[0m %s\n" $(build); mkdir $(build); fi
	@if [ ! -d "$(src)" ]; then printf "\x1b[35mCreating\x1b[0m %s\n" $(src); mkdir $(src); fi
	@if [ ! -d "$(inc)" ]; then printf "\x1b[35mCreating\x1b[0m %s\n" $(inc); mkdir $(inc); fi
	@if [ ! -f "$(src)/main.c" ]; then printf "\x1b[35mCreating\x1b[0m %s/main.c\n" $(src); printf "#include <stdio.h>\n\nint main(int argc, char* argv[])\n{\n\tprintf(\"Hello, world!\\\n\");\n\treturn 0;\n}\n" >> $(src)/main.c; fi

run:
	@printf "\x1b[36mRunning\x1b[0m %s\n\n" $(notdir $(out))
	@$(out)
	@printf "\n\x1b[2mDone\x1b[0m\n"
