# Disables exceptions for the target. Accepts the [OPTIONAL] flag.
# Changes made to the target are PUBLIC.
function(sf_target_compile_disable_exceptions target_name)
  cmake_parse_arguments(THIS "OPTIONAL" "" "" ${ARGN})

  if (THIS_OPTIONAL)
    option(DISABLE_EXCEPTIONS "Disables C++ exceptions." TRUE)
  endif()

  if (DISABLE_EXCEPTIONS OR NOT THIS_OPTIONAL)
    target_compile_definitions(${target_name} PUBLIC _HAS_EXCEPTIONS=0)

    if (MSVC)
      target_compile_options(${target_name} PUBLIC /EHs-c-a-)
    elseif (CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
      target_compile_options(${target_name} PUBLIC -fno-exceptions)
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
      target_compile_options(${target_name} PUBLIC -fno-exceptions)
    else()
      message(AUTHOR_WARNING "Exceptions could not be disabled for '${CMAKE_CXX_COMPILER_ID}' compiler.")
    endif()
  endif()

endfunction()
