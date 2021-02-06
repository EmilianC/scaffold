# Enables non-standard floating point optimizations for the target. Accepts the [OPTIONAL] flag.
# Changes made to the target are PUBLIC.
function(sf_target_compile_fast_fp target_name)
  cmake_parse_arguments(THIS "OPTIONAL" "" "" ${ARGN})

  if (THIS_OPTIONAL)
    option(ENABLE_FAST_FP "Compile with the fast floating point behaviour model." TRUE)
  endif()

  if (ENABLE_FAST_FP OR NOT THIS_OPTIONAL)
    if (MSVC)
      target_compile_options(${target_name} PUBLIC /fp:fast)
    elseif(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
      target_compile_options(${target_name} PUBLIC -ffast-math)
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
      target_compile_options(${target_name} PUBLIC -ffast-math)
    else()
      message(AUTHOR_WARNING "Fast floating point math could not be enabled for '${CMAKE_CXX_COMPILER_ID}' compiler.")
    endif()
  endif()

endfunction()
