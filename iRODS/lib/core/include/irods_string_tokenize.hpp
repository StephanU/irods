/* -*- mode: c++; fill-column: 132; c-basic-offset: 4; indent-tabs-mode: nil -*- */

#ifndef __IRODS_STRING_TOKENIZE_HPP__
#define __IRODS_STRING_TOKENIZE_HPP__

#include <string>
#include <vector>

namespace irods {
// =-=-=-=-=-=-=-
/// @brienf helper fcn to break up string into tokens for easy handling with a default delim of " "
    void string_tokenize(
        const std::string&,            // incoming string to tokenize
        const std::string&,            // delimiter for separating tokens
        std::vector< std::string >& ); // vector of tokenized symbols
}; // namespace irods

#endif // __IRODS_STRING_TOKENIZE_HPP__




