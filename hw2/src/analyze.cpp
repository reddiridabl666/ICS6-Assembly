#include <string_view>
#include <vector>
#include <algorithm>
#include <map>
#include <cctype>
#include <utility>
#include <functional>
#include <iostream>
#include <iterator>
#include <set>
#include <tuple>

#include "analyze.hpp"
#include "identifiers.hpp"
#include "constants.hpp"
#include "lexem.hpp"
#include "trim.hpp"

namespace context {
    enum context_t {
        NONE,
        CASE,
    };
}

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
        context::context_t ctx;

        bool operator<(const with_context& other) const {
            return std::tie(state, lexem, ctx) < std::tie(other.state, other.lexem, other.ctx);
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
        /* CASE_NXT*/ {ERROR,  ERROR,  ERROR,  ERROR,  NEXT,     ERROR,  ERROR, ERROR,   CONTEXT,  ERROR},
        /* CASE_END*/ {ERROR,  ERROR,  ERROR,  ERROR,  ERROR,    ERROR,  ERROR, ERROR,   ERROR,    START},
    };
}

static size_t nesting_level = 0;

state::state_t nesting() {
    nesting_level -= 1;
    if (nesting_level > 0) {
        return state::CASE_NXT;
    }
    return state::CASE_END;
}

static std::map<state::with_context, std::function<state::state_t()> >contextual_table = {
    {state::with_context{state::EXPR_END, lexem::SEMICOLON, context::NONE}, [] { return state::START;}},
    {state::with_context{state::EXPR_END, lexem::END,       context::NONE}, [] { return state::ERROR;}},
    {state::with_context{state::EXPR_END, lexem::SEMICOLON, context::CASE}, [] { return state::CASE_NXT;}},
    {state::with_context{state::EXPR_END, lexem::END,       context::CASE}, nesting},
    {state::with_context{state::CASE_NXT, lexem::END,       context::CASE}, nesting},
};

namespace context {
    context_t update(context_t old, state::state_t state) {
        if (state == state::CASE) {
            nesting_level += 1;
            return CASE;
        }

        if (old == CASE && state == state::START) {
            return NONE;
        }

        return old;
    }
}

void to_lower(std::string& input) {
    std::transform(input.begin(), input.end(), input.begin(), tolower);
}

std::string next_token(std::string& input) {
    if (input.empty()) {
        return "";
    }

    trim(input);

    static std::set<char> separators = {' ', ',', ':', ';'};

    size_t i;
    for (i = 0; i < input.size(); ++i) {
        if (!separators.contains(input[i])) {
            continue;
        }

        if (i != 0) {
            break;
        }

        if (input.size() > 1 && input.substr(0, 2) == ":=") {
            i = 2;
        } else {
            i = 1;
        }

        std::string res(input.c_str(), i);
        input = input.substr(i);
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
    while (true) {
        token = next_token(input);
        current.lexem = identify_lexem(token);
        std::cout << "Got: " << lexem::to_string(current.lexem, token) << std::endl;

        auto next = state::table[current.state][current.lexem];
        if (next == state::CASE_END) {
            nesting_level -= 1;
        }

        current.ctx = context::update(current.ctx, next);
        if (next == state::CONTEXT) {
            next = contextual_table[current]();
        }

        current.state = next;
        if (current.state == state::ERROR) {
            std::cout << kError << std::endl << std::endl;
            nesting_level = 0;
            return;
        }

        if (input == "" && current.state == state::START) {
            break;
        }
    }

    std::cout << kOk << std::endl << std::endl;
}
