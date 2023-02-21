#include <iostream>
#include <string>
#include <string_view>
#include <ranges>
#include <vector>

static constexpr size_t kMaxLength = 255;
static constexpr std::string_view kInvalidInput = "Invalid input";

extern "C" {
    const char* swap_words(const char* input, size_t size, size_t first, size_t second);
}

std::vector<size_t> get_numbers(const std::string& str) {
    std::vector<size_t> res;
    size_t num = 0;
    bool found = false;

    for (char c : str) {
        if (c > '0' && c < '9') {
            num = num * 10 + (c - '0');
            found = true;
            continue;
        }

        if (c == ' ') {
            res.push_back(num);
            num = 0;
            found = false;
            continue;
        }

        throw std::runtime_error("Invalid input");
    }

    if (found) {
        res.push_back(num);
    }
    return res;
}

int main() {
    std::cout << "Input line of text with <= 255 characters" << std::endl;

    std::string input;
    std::getline(std::cin, input);

    if (input.size() > kMaxLength) {
        std::cout << "Input should be <= 255 characters long" << std::endl;
        return -1;
    }

    std::string input_numbers;

    do {
        std::cout << "\nInput numbers of words you want to swap or 'end' to exit" << std::endl;
        std::getline(std::cin, input_numbers);

        if (input_numbers == "end") {
            break;
        }

        std::vector<size_t> numbers;
    
        try {
            numbers = get_numbers(input_numbers);
        } catch(std::runtime_error& e) {
            std::cout << e.what() << std::endl;
            return -1;
        }

        if (numbers.size() != 2) {
            std::cout << "You should input 2 numbers seperated by one space" << std::endl;
            continue;
        }

        input += ' ';
        input = swap_words(input.c_str(), input.size(), numbers[0], numbers[1]);
        std::cout << input << std::endl;
    } while (true);

    return 0;
}
