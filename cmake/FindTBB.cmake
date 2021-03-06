#
#     Copyright 2013 Pixar
#
#     Licensed under the Apache License, Version 2.0 (the "License");
#     you may not use this file except in compliance with the License
#     and the following modification to it: Section 6 Trademarks.
#     deleted and replaced with:
#
#     6. Trademarks. This License does not grant permission to use the
#     trade names, trademarks, service marks, or product names of the
#     Licensor and its affiliates, except as required for reproducing
#     the content of the NOTICE file.
#
#     You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#     Unless required by applicable law or agreed to in writing,
#     software distributed under the License is distributed on an
#     "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
#     either express or implied.  See the License for the specific
#     language governing permissions and limitations under the
#     License.
#

# - Try to find Intel's Threading Building Blocks
# Once done this will define
#
#  TBB_FOUND - System has OPENCL
#  TBB_INCLUDE_DIR - The TBB include directory
#  TBB_LIBRARIES - The libraries needed to use TBB

# Obtain include directory
if (WIN32)
    find_path(TBB_INCLUDE_DIR
        NAMES
            tbb/tbb.h
        PATHS
            ${TBB_LOCATION}/include
            $ENV{TBB_LOCATION}/include
            $ENV{PROGRAMFILES}/Intel/TBB/include
            /usr/include
            DOC "The directory where TBB headers reside")
elseif (APPLE)
    find_path(TBB_INCLUDE_DIR
        NAMES
            tbb/tbb.h
        PATHS
            ${TBB_LOCATION}/include
            $ENV{TBB_LOCATION}/include
            DOC "The directory where TBB headers reside")
else ()
    find_path(TBB_INCLUDE_DIR
        NAMES
            tbb/tbb.h
        PATHS
            ${TBB_LOCATION}/include
            $ENV{TBB_LOCATION}/include
            /usr/include
            /usr/local/include
            /usr/openwin/share/include
            /usr/openwin/include
            DOC "The directory where TBB headers reside")
endif ()

# List library files
foreach(TBB_LIB tbb             tbb_debug 
                tbbmalloc       tbbmalloc_debug
                tbbmalloc_proxy tbbmalloc_proxy_debug
                tbb_preview     tbb_preview_debug)

    if (WIN32)

            if ("${CMAKE_GENERATOR}" MATCHES "[Ww]in64")
            set(WINPATH intel64)
        else ()
            set(WINPATH ia32)
        endif()

            if (MSVC80)
            set(WINPATH "${WINPATH}/vc8")
        elseif (MSVC90)
            set(WINPATH "${WINPATH}/vc9")
        elseif (MSVC10)
            set(WINPATH "${WINPATH}/vc10")
        elseif (MSVC11)
            set(WINPATH "${WINPATH}/vc11")
        endif()
    endif()

    find_library(TBB_${TBB_LIB}_LIBRARY
        NAMES
            ${TBB_LIB}
        PATHS
            ${TBB_LOCATION}/lib
            ${TBB_LOCATION}/bin/${WINPATH}
            ${TBB_LOCATION}/lib/${WINPATH}
            $ENV{TBB_LOCATION}/lib
            $ENV{TBB_LOCATION}/bin/${WINPATH}
            $ENV{PROGRAMFILES}/TBB/lib
            /usr/lib
            /usr/lib/w32api
            /usr/local/lib
            /usr/X11R6/lib
            DOC "Intel's Threading Building Blocks library")

    if (TBB_${TBB_LIB}_LIBRARY)
        list(APPEND TBB_LIBRARIES ${TBB_${TBB_LIB}_LIBRARY})
    endif()
    
endforeach()

# Obtain version information
if(TBB_INCLUDE_DIR)

    # Tease the TBB version numbers from the lib headers
    function(parseVersion FILENAME VARNAME)
            
        set(PATTERN "^#define ${VARNAME}.*$")
        
        file(STRINGS "${TBB_INCLUDE_DIR}/${FILENAME}" TMP REGEX ${PATTERN})
        
        string(REGEX MATCHALL "[0-9]+" TMP ${TMP})
        
        set(${VARNAME} ${TMP} PARENT_SCOPE)
        
    endfunction()

    if(EXISTS "${TBB_INCLUDE_DIR}/tbb/tbb_stddef.h")
        parseVersion(tbb/tbb_stddef.h TBB_VERSION_MAJOR)
        parseVersion(tbb/tbb_stddef.h TBB_VERSION_MINOR)        
    endif()

    if(${TBB_VERSION_MAJOR} OR ${TBB_VERSION_MINOR})
        set(TBB_VERSION "${TBB_VERSION_MAJOR}.${TBB_VERSION_MINOR}")
        set(TBB_VERSION_STRING "${TBB_VERSION}")
        mark_as_advanced(TBB_VERSION)
    endif()

endif(TBB_INCLUDE_DIR)




include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(TBB 
    REQUIRED_VARS
        TBB_INCLUDE_DIR
        TBB_LIBRARIES
    VERSION_VAR
        TBB_VERSION
)

mark_as_advanced(
  TBB_INCLUDE_DIR
  TBB_LIBRARIES
)

