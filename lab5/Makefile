SRC_DIR = src
BUILD_DIR = build

TARGET = main
ASM_MODULE = swap_words

all: run

build: ${ASM_MODULE} ${TARGET}
	g++ -z noexecstack -no-pie ${BUILD_DIR}/${ASM_MODULE}.o ${BUILD_DIR}/${TARGET}.o -o ${BUILD_DIR}/${TARGET}.out

${ASM_MODULE}: ${SRC_DIR}/${ASM_MODULE}.asm	
	nasm -f elf64 ${SRC_DIR}/${ASM_MODULE}.asm -o ${BUILD_DIR}/${ASM_MODULE}.o

${TARGET}: ${SRC_DIR}/${TARGET}.cpp
	g++ -c ${SRC_DIR}/${TARGET}.cpp -o ${BUILD_DIR}/${TARGET}.o

run: build
	./${BUILD_DIR}/${TARGET}.out

debug: ${TARGET}
	edb --run ${BUILD_DIR}/${TARGET}.out
