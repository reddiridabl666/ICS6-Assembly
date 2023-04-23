#include <iostream>
#include <fstream>
#include <string>

#include "constants.hpp"
#include "analyze.hpp"

int main() {
    std::string input;
    std::ifstream in("in.txt");
    
    while (true) {
        std::getline(in, input);
        if (input == kEnd || !in) {
            break;
        }

        analyze(input);
    }

    return 0;
}
