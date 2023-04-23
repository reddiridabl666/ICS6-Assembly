#pragma once

#include <unordered_map>

namespace lexem {
    enum lexem_t {
        UNKNOWN,
        CASE,
        ID,
        OF,
        LITERAL,
        COMMA,
        COLON,
        ASSIGN,
        END,
        SEMICOLON,
        COUNT
    };

    inline lexem_t from_string(const std::string& input) {
        static std::unordered_map<std::string, lexem_t> map = {
            {"case", CASE}, {"of", OF}, {",", COMMA},
            {":", COLON}, {"end", END}, {":=", ASSIGN},
            {";", SEMICOLON}
        };

        return map[input];
    }

    inline std::string to_string(lexem_t lexem, const std::string& token) {
        if (token == "") {
            return "nothing";
        }

        if (lexem == ID) {
            return "identifier \"" + token + '"';
        }

        if (lexem == LITERAL) {
            return "literal \"" + token + '"';
        }
        
        static std::unordered_map<lexem_t, std::string> map = {
            {CASE, "case"}, {OF, "of"}, {COMMA, "comma"},
            {COLON, "colon"}, {END, "end"}, {ASSIGN, "assign"},
            {SEMICOLON, "semicolon"},
        };

        auto res = map[lexem];
        if (res == "") {
            return "unknown";
        }
        return res;
    }
}
