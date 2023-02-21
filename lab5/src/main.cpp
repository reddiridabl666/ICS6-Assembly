#include <iostream>
#include <string>
#include <string_view>

static constexpr size_t kMaxLength = 255;
static constexpr std::string_view kInvalidInput = "Invalid input";

extern "C" {
    const char* swap_words(const char* input, size_t size, size_t first, size_t second);
}

int main() {
    std::cout << "Input text with <= 255 characters" << std::endl;

    std::string input;
    std::getline(std::cin, input);

    // std::cout << "Input numbers of words you want to swap" << std::endl;

    size_t first, second;
    first = 1;
    second = 3;

    // std::cin >> first;
    // if (std::cin.bad()) {
    //     std::cout << kInvalidInput << std::endl;
    //     return -1;
    // }

    // std::cin >> second;
    // if (std::cin.bad()) {
    //     std::cout << kInvalidInput << std::endl;
    //     return -1;
    // }

    // if (input.size() > kMaxLength) {
    //     std::cout << "Input should be <= 255 characters long" << std::endl;
    //     return -1;
    // }
    
    input += ' ';
    /* std::cout << */ swap_words(input.c_str(), input.size(), first, second) /* << std::endl */;

    return 0;
}
