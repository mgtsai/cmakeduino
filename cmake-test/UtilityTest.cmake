#----------------------------------------------------------------------------------------------------------------------
# Copyright (C) 2015, M. G. Tsai.
# ALL RIGHTS RESERVED.
#----------------------------------------------------------------------------------------------------------------------
include(${CMAKE_CURRENT_LIST_DIR}/Assert.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../cmake/Utility.cmake)
set(F ${CMAKE_CURRENT_LIST_FILE})
set(L CMAKE_CURRENT_LIST_LINE)
#----------------------------------------------------------------------------------------------------------------------
set(test_list 123 456)
arduino_util_list_append_uniquely(test_list abc 123 abc xyz 123)
assert_strequal("${test_list}" "123;456;abc;xyz" "${F} ${${L}}")
#----------------------------------------------------------------------------------------------------------------------
arduino_util_parse_arguments(test "AB;CD;EF" "GH;IJ;KL" "MN;OP;QR" GH 123 CD QR abcd 1234 MN xyz AB IJ 987)
assert_strequal("${test.AB}" "TRUE" "${F} ${${L}}")
assert_strequal("${test.CD}" "TRUE" "${F} ${${L}}")
assert_strequal("${test.EF}" "FALSE" "${F} ${${L}}")
assert_strequal("${test.GH}" "123" "${F} ${${L}}")
assert_strequal("${test.IJ}" "987" "${F} ${${L}}")
assert_strequal("${test.KL}" "" "${F} ${${L}}")
assert_strequal("${test.MN}" "xyz" "${F} ${${L}}")
assert_strequal("${test.OP}" "" "${F} ${${L}}")
assert_strequal("${test.QR}" "abcd;1234" "${F} ${${L}}")
#----------------------------------------------------------------------------------------------------------------------
set(test_in.abc in-ab1)
set(test_in.def in-de2)
set(test_in.ghi in-gh3)
set(test_out.def out-de4)
set(test_out.xyz out-xy5)
arduino_util_copy_subvariables_if_not_set(test_out test_in abc def tuv xyz)
assert_strequal("${test_out.abc}" "in-ab1" "${F} ${${L}}")
assert_strequal("${test_out.def}" "out-de4" "${F} ${${L}}")
assert_strequal("${test_out.ghi}" "" "${F} ${${L}}")
assert_strequal("${test_out.tuv}" "" "${F} ${${L}}")
assert_strequal("${test_out.xyz}" "out-xy5" "${F} ${${L}}")
#----------------------------------------------------------------------------------------------------------------------
set(test_incs def.h ghi.h tuv.h)
arduino_util_read_includes(test_incs ${CMAKE_CURRENT_LIST_DIR}/TestInclude.c)
assert_strequal("${test_incs}" "def.h;ghi.h;tuv.h;abc.h;xyz.h" "${F} ${${L}}")
#----------------------------------------------------------------------------------------------------------------------
