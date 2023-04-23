project(main)
cmake_minimum_required(VERSION 3.17)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_BUILD_TYPE Debug)

add_executable(${PROJECT_NAME} src/main.cpp src/analyze.cpp src/identifiers.cpp)
target_include_directories(${PROJECT_NAME} PUBLIC include)
