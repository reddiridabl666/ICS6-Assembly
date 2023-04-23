#include <algorithm>

#include "identifiers.hpp"

bool is_number(char c) {
    return c >= '0' && c <= '9';
}

bool is_letter(char c) {
    return c >= 'a' && c <= 'z';
}

bool is_identifier(std::string_view input) {
    if (input.empty()) {
        return false;
    }

    if (!is_letter(input.front()) && input.front() != '_') {
        return false;
    }

    return std::all_of(input.begin() + 1, input.end(), [] (char c) {
        return is_number(c) || is_letter(c) || c == '_';
    });
}

bool is_literal(std::string_view input) {
    if (input.empty()) {
        return false;
    }

    if (input.front() == '-' || input.front() == '+') {
        input.remove_prefix(1);
    }
    return std::all_of(input.begin(), input.end(), is_number);
}
