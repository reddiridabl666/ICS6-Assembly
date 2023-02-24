BUILD_DIR = build
TARGET = main

all: run

build: ${TARGET}
	ld ${BUILD_DIR}/${TARGET}.o -o ${BUILD_DIR}/${TARGET}.out

${TARGET}: ${TARGET}.asm	
	nasm -f elf64 ${TARGET}.asm -o ${BUILD_DIR}/${TARGET}.o

run: build
	./${BUILD_DIR}/${TARGET}.out

debug: build
	edb --run ${BUILD_DIR}/${TARGET}.out

actual:
	python3 ${TARGET}.py
