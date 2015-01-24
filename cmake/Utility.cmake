#----------------------------------------------------------------------------------------------------------------------
# Copyright (C) 2015, M. G. Tsai.
# ALL RIGHTS RESERVED.
#----------------------------------------------------------------------------------------------------------------------
include(CMakeParseArguments)
#----------------------------------------------------------------------------------------------------------------------
# Uniquely appends entries into a list.  This function ensures that the newly appended entries would not be duplicated
# in this list.
function(cmakeduino_util_list_append_uniquely
    list_var    # (in-out) Entries would be uniquely appended into this list variable
    # ARGN        (input)  The entries to be appended
)
    set(list ${${list_var}})

    foreach (entry ${ARGN})
        list(FIND list ${entry} entry_index)
        if (entry_index LESS 0)
            list(APPEND list ${entry})
        endif()
    endforeach()

    set(${list_var} ${list} PARENT_SCOPE)
endfunction()
#----------------------------------------------------------------------------------------------------------------------
# Parses arguments (by using cmake_parse_arguments()).
function(cmakeduino_util_parse_arguments
    var_prefix  # (output) Variables ${var_prefix}.xxx contain parsed argument values
    opts        # (input)  List of options
    args        # (input)  List of single-value arguments
    multi_args  # (input)  List of multi-value arguments
    # ARGN        (input)  Argument list
)
    cmake_parse_arguments(__input "${opts}" "${args}" "${multi_args}" ${ARGN})

    set(unparsed_args ${__input_UNPARSED_ARGUMENTS})
    if (NOT ("${unparsed_args}" STREQUAL ""))
        message(FATAL_ERROR "Unparsed argument(s): ${unparsed_args}")
    endif()

    foreach (arg ${opts} ${args} ${multi_args})
        set(${var_prefix}.${arg} ${__input_${arg}} PARENT_SCOPE)
    endforeach()
endfunction()
#----------------------------------------------------------------------------------------------------------------------
# Fills subvariables which are not set yet.
#
# For example, if ${src_var_prefix} = 'parent_src', ${dest_var_prefix} = 'parent_dest', and subvariable names are
# 'aa;bb;cc', the value of ${parent_src.aa} (or ${parent_src.bb}, ${parent_src.cc}) would be copied to
# ${parent_dest.aa} (or ${parent_dest.bb}, ${parent_dest.cc}, respectively) if it has not been assigned before.
function(cmakeduino_util_copy_subvariables_if_not_set
    dest_var_prefix # (in-out) Variables ${dest_var_prefix}.xxx to be copied to if not set yet
    src_var_prefix  # (input)  Variables ${src_var_prefix}.xxx which values to be copied from
    # ARGN            (input)  Subvariable names
)
    foreach (subvar ${ARGN})
        if ((NOT ${dest_var_prefix}.${subvar}) AND ${src_var_prefix}.${subvar})
            set(${dest_var_prefix}.${subvar} ${${src_var_prefix}.${subvar}} PARENT_SCOPE)
        endif()
    endforeach()
endfunction()
#----------------------------------------------------------------------------------------------------------------------
# Reads and parses C include headers from a source file.
function(cmakeduino_util_read_includes
    inc_hdrs_var    # (output) The list variable containing found include headers
    src_file        # (input)  The source file
)
    set(inc_hdrs)
    file(STRINGS ${src_file} lines)

    foreach (line ${lines})
        if ("${line}" MATCHES "^[ \t]*#[ \t]*include[ \t]*[<\"]([^>\"]*)[>\"]")
            cmakeduino_util_list_append_uniquely(inc_hdrs ${CMAKE_MATCH_1})
        endif()
    endforeach()

    set(${inc_hdrs_var} ${inc_hdrs} PARENT_SCOPE)
endfunction()
#----------------------------------------------------------------------------------------------------------------------
# Finds files with the specified extensions contained in the specified directory.  The caller can specify whether
# descendant directories would be searched or not.
function(cmakeduino_util_find_files_by_exts
    files_var       # (output) The list variable containing found files
    dir             # (input)  The directory containing the files to be searched
    is_recursive    # (input)  Indicates whether descendant directories would be searched
    # ARGN            (input)  File extensions used for searching
)
    set(search_list)
    foreach (ext ${ARGN})
        list(APPEND search_list ${dir}/*.${ext})
    endforeach()

    if (is_recursive)
        file(GLOB_RECURSE files ${search_list})
    else()
        file(GLOB files ${search_list})
    endif()

    set(${files_var} ${files} PARENT_SCOPE)
endfunction()
#----------------------------------------------------------------------------------------------------------------------
