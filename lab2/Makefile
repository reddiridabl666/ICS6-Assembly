TARGET = main

all: run

build: ${TARGET}

${TARGET}: ${TARGET}.asm	
	nasm -f elf64 ${TARGET}.asm -o ${TARGET}.o
	ld -o ${TARGET}.out ${TARGET}.o 

run: ${TARGET}
	./${TARGET}.out

debug: ${TARGET}
	edb --run ${TARGET}.out

actual:
	python3 ${TARGET}.py
