#----------------------------------------------------------------------------------------------------------------------
# Copyright (C) 2015, M. G. Tsai.
# ALL RIGHTS RESERVED.
#----------------------------------------------------------------------------------------------------------------------
include(CMakeParseArguments)
#----------------------------------------------------------------------------------------------------------------------
# Uniquely appends entries into a list.
#
# Input:
#   ARGN: The entries to be appended
#
# In-out:
#   list_var: The variable of the list which the specified entries to be appended into
#
function(cmakeduino_util_list_append_uniquely list_var)
    foreach (entry ${ARGN})
        list(FIND ${list_var} ${entry} entry_index)
        if (entry_index LESS 0)
            list(APPEND ${list_var} ${entry})
        endif()
    endforeach()

    set(${list_var} ${${list_var}} PARENT_SCOPE)
endfunction()
#----------------------------------------------------------------------------------------------------------------------
# Parse arguments.
#
# Input:
#   opts: List of options
#   args: List of single-value arguments
#   multi_args: List of multi-value arguments
#   ARGN: Argument list
#
# Output:
#   var_prefix: Variables ${var_prefix}.xxx contain parsed argument values
#
function(cmakeduino_util_parse_arguments var_prefix opts args multi_args)
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
# Input:
#   src_var_prefix: Variables ${src_var_prefix}.xxx which values to be copied from
#   ARGN: Subvariable names
#
# In-out:
#   dest_var_prefix: Variables ${dest_var_prefix}.xxx to be copied to if not set yet
#
function(cmakeduino_util_copy_subvariables_if_not_set dest_var_prefix src_var_prefix)
    foreach (subvar ${ARGN})
        if ((NOT ${dest_var_prefix}.${subvar}) AND ${src_var_prefix}.${subvar})
            set(${dest_var_prefix}.${subvar} ${${src_var_prefix}.${subvar}} PARENT_SCOPE)
        endif()
    endforeach()
endfunction()
#----------------------------------------------------------------------------------------------------------------------
# Read and parse C include headers from a source file.
#
# Input:
#   src_file: The source file
#
# In-out:
#   inc_hdrs_var: The variable containing include headers
#
function(cmakeduino_util_read_includes inc_hdrs_var src_file)
    file(STRINGS ${src_file} lines)

    foreach (line ${lines})
        if ("${line}" MATCHES "^[ \t]*#[ \t]*include[ \t]*[<\"]([^>\"]*)[>\"]")
            cmakeduino_util_list_append_uniquely(${inc_hdrs_var} ${CMAKE_MATCH_1})
        endif()
    endforeach()

    set(${inc_hdrs_var} ${${inc_hdrs_var}} PARENT_SCOPE)
endfunction()
#----------------------------------------------------------------------------------------------------------------------
