#include <string_view>
#include <vector>
#include <algorithm>
#include <map>
#include <cctype>
#include <utility>
#include <iostream>
#include <iterator>
#include <set>

#include "analyze.hpp"
#include "identifiers.hpp"
#include "constants.hpp"
#include "lexem.hpp"
#include "trim.hpp"

enum class context {
    NONE,
    CASE
};

namespace state {
    enum state_t {
        ERROR,
        START,
        CASE,
        OF,
        CHOICE,
        NEXT,
        ASSIGN,
        LITERAL,
        EXPR,
        EXPR_END,
        CASE_NXT,
        CASE_END,
        CONTEXT,
        COUNT
    };

    struct with_context {
        state_t state;
        lexem::lexem_t lexem;
        context ctx;

        bool operator<(const with_context& other) const {
            if (state < other.state) {
                return true;
            }
            if (lexem < other.lexem) {
                return true;
            }
            return ctx < other.ctx;
        }
    };

    static const state_t table[state::COUNT][lexem::COUNT] = {
                    // UNKNOWN CASE    ID      OF      LITERAL   COMMA   COLON  ASSIGN   END       SEMICOLON  
        /* ERROR */   {ERROR,  ERROR,  ERROR,  ERROR,  ERROR,    ERROR,  ERROR, ERROR,   ERROR,    ERROR}, 
        /* START */   {ERROR,  CASE,   ASSIGN, ERROR,  ERROR,    ERROR,  ERROR, ERROR,   ERROR,    ERROR},
        /* CASE */    {ERROR,  ERROR,  OF,     ERROR,  ERROR,    ERROR,  ERROR, ERROR,   ERROR,    ERROR},
        /* OF */      {ERROR,  ERROR,  ERROR,  CHOICE, ERROR,    ERROR,  ERROR, ERROR,   ERROR,    ERROR},
        /* CHOICE */  {ERROR,  ERROR,  ERROR,  ERROR,  NEXT,     ERROR,  ERROR, ERROR,   ERROR,    ERROR},
        /* NEXT */    {ERROR,  ERROR,  ERROR,  ERROR,  ERROR,    CHOICE, EXPR,  ERROR,   ERROR,    ERROR},
        /* ASSIGN */  {ERROR,  ERROR,  ERROR,  ERROR,  ERROR,    ERROR,  ERROR, LITERAL, ERROR,    ERROR},
        /* LITERAL */ {ERROR,  ERROR,  ERROR,  ERROR,  EXPR_END, ERROR,  ERROR, ERROR,   ERROR,    ERROR},
        /* EXPR */    {ERROR,  CASE,   ASSIGN, ERROR,  ERROR,    ERROR,  ERROR, ERROR,   ERROR,    ERROR},
        /* EXPR_END*/ {ERROR,  ERROR,  ERROR,  ERROR,  ERROR,    ERROR,  ERROR, ERROR,   CONTEXT,  CONTEXT},
        /* CASE_NXT*/ {ERROR,  ERROR,  ERROR,  ERROR,  NEXT,     ERROR,  ERROR, ERROR,   CASE_END, ERROR},
        /* CASE_END*/ {ERROR,  ERROR,  ERROR,  ERROR,  ERROR,    ERROR,  ERROR, ERROR,   ERROR,    START},
    };
}

static std::map<state::with_context, state::state_t> contextual_table = {
    {state::with_context{state::EXPR_END, lexem::SEMICOLON, context::NONE}, state::START},
    {state::with_context{state::EXPR_END, lexem::END,       context::NONE}, state::ERROR},
    {state::with_context{state::EXPR_END, lexem::SEMICOLON, context::CASE}, state::CASE_NXT},
    {state::with_context{state::EXPR_END, lexem::END,       context::CASE}, state::CASE_END},
};

context update_context(context old, state::state_t state) {
    if (state == state::CASE) {
        return context::CASE;
    }

    if (old == context::CASE && state == state::START) {
        return context::NONE;
    }

    return old;
}

void to_lower(std::string& input) {
    std::transform(input.begin(), input.end(), input.begin(), tolower);
}

std::string next_token(std::string& input) {
    if (input.empty()) {
        return "";
    }

    static std::set<char> separators = {' ', ',', ':', ';'};

    size_t i;
    for (i = 0; i < input.size(); ++i) {
        if (!separators.contains(input[i])) {
            continue;
        }

        if (i != 0) {
            break;
        }

        if (input[i] == ' ') {
            continue;
        }

        std::string res(input.c_str(), 1);
        input = input.substr(1);
        return res;
    }

    std::string res(input.c_str(), i);
    input = input.substr(i);
    return res;
}

static lexem::lexem_t identify_lexem(const std::string& input) {
    lexem::lexem_t lexem = lexem::from_string(input);
    if (lexem != lexem::UNKNOWN) {
        return lexem;
    }

    if (is_identifier(input)) {
        return lexem::ID;
    }

    if (is_literal(input)) {
        return lexem::LITERAL;
    }

    return lexem::UNKNOWN;
}

void analyze(std::string input) {
    to_lower(input);

    state::with_context current = {state::START, lexem::UNKNOWN, context::NONE};
    
    std::string token;
    while (token = next_token(input), token != "") {
        trim(token);

        current.lexem = identify_lexem(token);
        std::cout << "Got: " << lexem::to_string(current.lexem, token) << std::endl;

        auto next = state::table[current.state][current.lexem];

        current.ctx = update_context(current.ctx, next);
        if (next == state::CONTEXT) {
            next = contextual_table[current];
        }

        current.state = next;
        if (current.state == state::ERROR) {
            std::cout << kError << std::endl;
            return;
        }
    }

    std::cout << kOk << std::endl;
}
