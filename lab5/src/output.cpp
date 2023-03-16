#include <iostream>

extern "C" {
    void print_exchanged(const char* first, const char* second) {
        std::cout << "Exchanged '" << first << "' with '" << second << "'" << std::endl;
    }
}
