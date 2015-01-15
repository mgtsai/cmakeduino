#----------------------------------------------------------------------------------------------------------------------
# Copyright (C) 2015, M. G. Tsai.
# ALL RIGHTS RESERVED.
#----------------------------------------------------------------------------------------------------------------------
# Asserts for checking whether two strings are equal (using STREQUAL).
#
# Input:
#   actual: The actual string
#   expected: The expected string
#   msg: The message for this assertion
#
function(assert_strequal actual expected msg)
    if (NOT (actual STREQUAL expected))
        message(FATAL_ERROR "${msg}: Expected \"${expected}\" but actual \"${actual}\"")
    endif()
endfunction()
#----------------------------------------------------------------------------------------------------------------------
