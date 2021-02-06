# Disables Run-Time Type Information (RTTI) for the target. Accepts the [OPTIONAL] flag.
# Changes made to the target are PUBLIC.
function(sf_target_compile_disable_rtti target_name)
  cmake_parse_arguments(THIS "OPTIONAL" "" "" ${ARGN})

  if (THIS_OPTIONAL)
    option(DISABLE_RTTI "Disables Run-Time Type Information generation." TRUE)
  endif()

  if (DISABLE_RTTI OR NOT THIS_OPTIONAL)
    if (MSVC)
      target_compile_options(${target_name} PUBLIC /GR-)
    elseif(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
      target_compile_options(${target_name} PUBLIC -fno-rtti)
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
      target_compile_options(${target_name} PUBLIC -fno-rtti)
    else()
      message(AUTHOR_WARNING "RTTI could not be disabled for '${CMAKE_CXX_COMPILER_ID}' compiler.")
    endif()
  endif()

endfunction()
