# Include guard
if (SCAF_COMMON_DONE)
  return()
endif()
set(SCAF_COMMON_DONE ON)

# Block in-source builds.
if (CMAKE_CURRENT_BINARY_DIR STREQUAL PROJECT_SOURCE_DIR)
  message(FATAL_ERROR "In-source builds are not supported.")
endif()

# Block installation into the build.
if (CMAKE_INSTALL_PREFIX STREQUAL PROJECT_BINARY_DIR)
  message(FATAL_ERROR "Installing into the build directory is not supported.")
endif()

# Set a default build type if none was specified.
if (NOT CMAKE_BUILD_TYPE)
	message(STATUS "Setting build type to 'Release' as none was specified.")
	set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build." FORCE)

	# Set the possible values for the build type.
	set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release")
endif()

# Remove MinSizeRel and RelWithDebInfo configurations.
set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "" FORCE)

set(CMAKE_CXX_EXTENSIONS OFF) # Do not allow compiler specific extensions
set(CMAKE_SUPPRESS_REGENERATION ON) # Omit ZERO_CHECK target.
set_property(GLOBAL PROPERTY USE_FOLDERS ON) # Organize targets in the IDE

# Link Time Optimization.
option(ENABLE_LTO "Enable Link Time Optimization." ON)
if (ENABLE_LTO)
	include(CheckIPOSupported)
	check_ipo_supported(RESULT result OUTPUT output)
	if (result)
		set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
	else()
		message(SEND_ERROR "LTO is not supported: ${output}")
	endif()
endif()

if ($ENV{TRAVIS})
  set(TRAVIS ON)
endif()

string(TOUPPER ${PROJECT_NAME} UPPER_PROJECT_NAME)
string(TOLOWER ${PROJECT_NAME} LOWER_PROJECT_NAME)

# Determines if the current project is top-level.
function(sf_is_project_top_level project)
	if (CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
		set(${project} ON PARENT_SCOPE)
	else()
		set(${project} OFF PARENT_SCOPE)
	endif()
endfunction()

macro(sf_setup_modules)
  set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
  set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR})
endmacro()
