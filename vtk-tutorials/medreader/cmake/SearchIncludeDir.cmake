# 获取目录下的子目录名 目前只搜索到二级目录
# subdirnamelist 子目录名称列表，输出变量，调用处定义，填充时不能加${}
# targetdir      目标路径，为全路径
macro(SUBDIRNAMELIST_MACRO subdirnamelist targetdir)
    # message(STATUS "macro subdirnamelist = ${subdirnamelist}")
    # message(STATUS "macro targetdir = ${targetdir}")
    file(GLOB children ${targetdir}/*) # 获取目标路径下的内容，深度为1
    # message(STATUS "macro children = ${children}")
    set(dirlist "")
    foreach(child ${children})
        file(RELATIVE_PATH child_name ${targetdir} ${child}) # 通过相对路径计算获取名称
        # message(STATUS "macro child = ${child_name}")
        # message(STATUS "targetdir/child = ${targetdir}/${child_name}")
        if(IS_DIRECTORY ${targetdir}/${child_name})
            # message(STATUS "yes dir : targetdir/child = ${targetdir}/${child_name}")
            list(APPEND dirlist ${child_name})

            file(GLOB grandchildren ${targetdir}/${child_name}/*) # 获取目标路径下子目录的内容，深度为2
            foreach(grandchild ${grandchildren})
                file(RELATIVE_PATH grandchild_name ${targetdir} ${grandchild}) # 通过相对路径计算获取名称
                # message(STATUS "macro grandchild = ${grandchild_name}")
                # message(STATUS "targetdir/grandchild = ${targetdir}/${grandchild_name}")
                if(IS_DIRECTORY ${targetdir}/${grandchild_name})
                    # message(STATUS "yes dir : targetdir/grandchild = ${targetdir}/${grandchild_name}")
                    list(APPEND dirlist ${grandchild_name})
                endif()
            endforeach()

        endif()
    endforeach()

    list(APPEND ${subdirnamelist} ${dirlist})
    # message(STATUS "macro dirlist = ${dirlist}")
    # message(STATUS "macro subdirnamelist = ${subdirnamelist}")
endmacro()

# 获取目录下是否有CMakeLists
# hascmakelist 是否含有CMakeLists.txt，输出变量，调用处定义，填充时不能加${}
# targetdir    目标路径，为全路径
macro(CHECK_DIR_HAS_CMAKELIST hascmakelist targetdir)
    # message(STATUS "macro check has cmakelist targetdir = ${targetdir}")
    set(${hascmakelist} FALSE)
    if(IS_DIRECTORY ${targetdir})
        # message(STATUS "macro check has cmakelist is dir, targetdir = ${targetdir}")
        if(EXISTS ${targetdir}/CMakeLists.txt)
            set(${hascmakelist} TRUE)
        endif()
    else()
        # message(FATAL_ERROR "Invalid dir para: targetdir = ${targetdir}")
    endif()
endmacro()

# 为含有CMakeList的子目录添加add_subdirectory调用
# 自动识别调用处所在目录有哪些子目录，并为还有CMakeLists.txt的子目录添加add_sundirectory调用
macro(ADD_SUBDIRECTORY SRC_DIR)
    set(subdirnamelisttemp "")
    SUBDIRNAMELIST_MACRO(subdirnamelisttemp ${SRC_DIR})
    # message(STATUS "macro add_subdir subdirnamelisttemp = ${subdirnamelisttemp}")
    foreach(subdir ${subdirnamelisttemp})
        # message(STATUS "macro add_subdir subdir = ${SRC_DIR}/${subdir}")
        set(hascmakelisttemp FALSE)
        CHECK_DIR_HAS_CMAKELIST(hascmakelisttemp ${SRC_DIR}/${subdir})
        # message(STATUS "macro add_subdir hascmakelisttemp = ${hascmakelisttemp}")
        if(${hascmakelisttemp})
            # message(STATUS "macro add_subdir go to add_subdir = ${subdir}")
            add_subdirectory(${subdir})
        endif()
    endforeach()
endmacro()

# 自动识别SRC_DIR目录下一级及二级目录名
# 填充到SOURCE_INCLUDE_DIRS变量中
macro(FIND_SUBDIRECTORY SRC_DIR SOURCE_INCLUDE_DIRS)
    set(subdirnamelisttemp "")
    SUBDIRNAMELIST_MACRO(subdirnamelisttemp ${SRC_DIR})
    #message(STATUS "macro find_subdir subdirnamelisttemp = ${subdirnamelisttemp}")
    foreach(subdir ${subdirnamelisttemp})
        #message(STATUS "macro find_subdir subdir = ${SRC_DIR}/${subdir}")
        list(APPEND SOURCE_INCLUDE_DIRS ${SRC_DIR}/${subdir})
    endforeach()
endmacro()