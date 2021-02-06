# Enables standard accepted warnings for the target.
# Changes are PRIVATE to the target.
function(sf_target_compile_warnings target_name)
  set(MSVC_WARNINGS
    /W4          # Baseline reasonable warnings
    /w14242      # 'identifier': conversion from 'type1' to 'type1', possible loss of data
    /w14254      # 'operator': conversion from 'type1:field_bits' to 'type2:field_bits', possible loss of data
    /w14263      # 'function': member function does not override any base class virtual member function
    /w14265      # 'classname': class has virtual functions, but destructor is not virtual instances of this class may not be destructed correctly
    /w14287      # 'operator': unsigned/negative constant mismatch
    /we4289      # nonstandard extension used: 'variable': loop control variable declared in the for-loop is used outside the for-loop scope
    /w14296      # 'operator': expression is always 'boolean_value'
    /w14311      # 'variable': pointer truncation from 'type1' to 'type2'
    /w14545      # expression before comma evaluates to a function which is missing an argument list
    /w14546      # function call before comma missing argument list
    /w14547      # 'operator': operator before comma has no effect; expected operator with side-effect
    /w14549      # 'operator': operator before comma has no effect; did you intend 'operator'?
    /w14555      # expression has no effect; expected expression with side- effect
    /w14619      # pragma warning: there is no warning number 'number'
    /w14640      # Enable warning on thread un-safe static member initialization
    /w14826      # Conversion from 'type1' to 'type_2' is sign-extended. This may cause unexpected runtime behavior.
    /w14905      # wide string literal cast to 'LPSTR'
    /w14906      # string literal cast to 'LPWSTR'
    /w14928      # illegal copy-initialization; more than one user-defined conversion has been implicitly applied
  )

  set(MSVC_DISABLED_WARNINGS
    /wd4100      # 'identifier' : unreferenced formal parameter
    /wd4505      # 'function' : unreferenced local function has been removed
  )

  set(CLANG_WARNINGS
    -Wall
    -Wextra              # reasonable and standard
    -Wshadow             # warn the user if a variable declaration shadows one from a parent context
    -Wnon-virtual-dtor   # warn the user if a class with virtual functions has a non-virtual destructor.
    -Wold-style-cast     # warn for c-style casts
    -Wcast-align         # warn for potential performance problem casts
    -Wunused             # warn on anything being unused
    -Woverloaded-virtual # warn if you overload (not override) a virtual function
    -Wpedantic           # warn if non-standard C++ is used
    -Wconversion         # warn on type conversions that may lose data
    -Wsign-conversion    # warn on sign conversions
    -Wnull-dereference   # warn if a null dereference is detected
    -Wdouble-promotion   # warn if float is implicit promoted to double
    -Wformat=2           # warn on security issues around functions that format output (ie printf)
  )

  set(GCC_WARNINGS
    ${CLANG_WARNINGS}
    -Wmisleading-indentation # warn if indentation implies blocks where blocks do not exist
    -Wduplicated-cond        # warn if if / else chain has duplicated conditions
    -Wduplicated-branches    # warn if if / else branches have duplicated code
    -Wlogical-op             # warn about logical operations being used where bitwise were probably wanted
    -Wuseless-cast           # warn if you perform a cast to the same type
  )

  if (MSVC)
    target_compile_options(${target_name} PRIVATE ${MSVC_WARNINGS} ${MSVC_DISABLED_WARNINGS})
  elseif (CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
    target_compile_options(${target_name} PRIVATE ${CLANG_WARNINGS})
  elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_compile_options(${target_name} PRIVATE ${GCC_WARNINGS})
  else()
    message(AUTHOR_WARNING "No compiler warnings set for '${CMAKE_CXX_COMPILER_ID}' compiler.")
  endif()

endfunction()

# Enables warnings-as-errors for the target. Accepts the [OPTIONAL] flag.
# Changes are PRIVATE to the target.
function(sf_target_compile_warnings_as_errors target_name)
  cmake_parse_arguments(THIS "OPTIONAL" "" "" ${ARGN})

  if (THIS_OPTIONAL)
    option(ENABLE_WARNINGS_AS_ERRORS "Treat compiler warnings as errors." TRUE)
  endif()

  if (ENABLE_WARNINGS_AS_ERRORS OR NOT THIS_OPTIONAL)
    if (MSVC)
      target_compile_options(${target_name} PRIVATE /WX)
    elseif (CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
      target_compile_options(${target_name} PRIVATE -Werror)
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
      target_compile_options(${target_name} PRIVATE -Werror)
    else()
      message(AUTHOR_WARNING "Warnings as errors could not be set '${CMAKE_CXX_COMPILER_ID}' compiler.")
    endif()
  endif()

endfunction()
