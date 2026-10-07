# Patch ANTLR4 4.7.1 runtime CMakeLists.txt to remove cmake_policy(SET ... OLD)
# calls that are no longer supported by modern CMake (3.27+).
#
# The affected policies (CMP0042, CMP0045, CMP0054, CMP0059) all have their
# NEW behavior as the only supported mode in recent CMake, so removing the
# OLD overrides is safe and produces identical build results.

set(CMAKE_FILE "${ANTLR4_ROOT}/runtime/Cpp/CMakeLists.txt")

if(EXISTS "${CMAKE_FILE}")
  file(READ "${CMAKE_FILE}" CONTENT)

  # Count matches before replacement for diagnostics
  string(REGEX MATCHALL
    "cmake_policy\\(SET[ \t]+CMP[0-9]+[ \t]+OLD\\)"
    MATCHES "${CONTENT}")
  list(LENGTH MATCHES NUM_MATCHES)
  message(STATUS "Found ${NUM_MATCHES} cmake_policy(SET ... OLD) calls to remove")

  # Remove lines like: cmake_policy(SET CMP0054 OLD)
  string(REGEX REPLACE
    "cmake_policy\\(SET[ \t]+CMP[0-9]+[ \t]+OLD\\)"
    ""
    CONTENT "${CONTENT}")

  file(WRITE "${CMAKE_FILE}" "${CONTENT}")
  message(STATUS "Patched ANTLR4 CMakeLists.txt at ${CMAKE_FILE}")
else()
  message(WARNING "ANTLR4 CMakeLists.txt not found at ${CMAKE_FILE}")
endif()
