#!/bin/bash

startTime=$(date '+%s')

# LOG INFO    #BLUE
# LOG WARNING #YELLOW
# LOG ERROR   #PINK
# LOG FATAL   #RED
# LOG SUCCESS #GREEN

function LOG() {
  # Define Color Variables
  RED_COLOR='\E[1;31m'
  GREEN_COLOR='\E[1;32m'
  YELLOW_COLOR='\E[1;33m'
  BLUE_COLOR='\E[1;34m'
  PINK_COLOR='\E[1;35m'
  RES='\E[0m'

  if [ $# -ne 2 ]; then
    echo -e "${RED_COLOR}-- LOG Function Need Two Parameters${RES}"
    return
  else
    if [ "$1" = "INFO" ]; then
      logColor=${BLUE_COLOR}
    elif [ "$1" = "WARNING" ]; then
      logColor=${YELLOW_COLOR}
    elif [ "$1" = "ERROR" ]; then
      logColor=${PINK_COLOR}
    elif [ "$1" = "FATAL" ]; then
      logColor=${RED_COLOR}
    elif [ "$1" = "SUCCESS" ]; then
      logColor=${GREEN_COLOR}
    else
      echo -e "${RED_COLOR}-- First Parameter Must Be INFO||WARNING||ERROR||FATAL||SUCCESS${RES}"
      return
    fi
  fi

  logText=$2
  echo -e "${logColor}-- ${logText}${RES}"

  if [ "$1" = "FATAL" ]; then
    exit 0
  fi
}

checkSystem() {
  if [[ "$(awk -F= '/^NAME/{print $2}' /etc/os-release)" == "CentOS Linux" ]]; then
    system="centos"

  elif grep </etc/issue -q -i "debian" && [[ -f "/etc/issue" ]] || grep </etc/issue -q -i "debian" && [[ -f "/proc/version" ]]; then
    if grep </etc/issue -i "8"; then
      debianVersion=8
    fi
    system="debian"

  elif grep </etc/issue -q -i "ubuntu" && [[ -f "/etc/issue" ]] || grep </etc/issue -q -i "ubuntu" && [[ -f "/proc/version" ]]; then
    system="ubuntu"
  fi

  if [[ -z ${system} ]]; then
    LOG "FATAL" "The current operating system does not currently support!"
  else
    LOG "INFO" "The current system is ${system}"
  fi
}
checkSystem

BUILD_PLUGINS=1
BUILD_SHARED=0

for key in "$@"; do
  case $key in
  -s)
    BUILD_SHARED=1
    ;;
  -f)
    BUILD_PLUGINS=0
    ;;
  *) ;;

  esac
done

if [ $BUILD_SHARED -eq 1 ]; then
  LOG "INFO" "BUILD_SHARED_DEPS"
fi

if [ $BUILD_PLUGINS -eq 0 ]; then
  LOG "WARNING" "Not Install Common Plugins"
  CPU_CORES="$(cat "/proc/cpuinfo" | grep "processor" | wc -l)"
  if [ "${CPU_CORES}" -lt 0 ]; then
    LOG "FATAL" "Your Computer CPU_CORES Less Than 0"
  fi
else
  LOG "INFO" "Install Common Plugins"
  if [ "${system}" = "ubuntu" ]; then
    #apt-get update -y

    ######### Need To Build Tools #########
    sudo apt install gcc g++ gfortran -y
    sudo apt install bison flex cmake make -y

    ######### Need To Build VTK #########
    sudo apt install libx11-dev -y
    sudo apt-get install libgl1-mesa-dev -y
    sudo apt-get install libosmesa6-dev -y


    if [ $BUILD_SHARED -eq 1 ]; then
      sudo apt-get install tcllib tklib tcl-dev tk-dev libfreetype-dev libfreeimage-dev -y
    else
      sudo apt-get install libfontconfig1-dev -y
    fi
  elif [ "${system}" = "centos" ]; then
    sudo yum install update -y

    ######### Need To Build Tools #########
    sudo yum install -y gcc g++ gfortran
    sudo yum install -y bison flex make

    wget https://cae-static-1252829527.cos.ap-shanghai.myqcloud.com/devops/dev/cmake-3.17.3-Linux-x86_64.sh
    chmod 755 cmake-3.17.3-Linux-x86_64.sh
    ./cmake-3.17.3-Linux-x86_64.sh --skip-license --prefix=/usr/
    rm -f cmake-3.17.3-Linux-x86_64.sh

    ######### Need To Build VTK #########
    sudo yum install -y libX11
    sudo yum install -y mesa-libGL

    sudo yum install -y fontconfig
  fi
fi

project_name="MEDTEST"
script_dir=$(
  cd $(dirname ${BASH_SOURCE[0]})
  pwd
)

cmakeLists_txt="CMakeLists.txt"
cmakeLists_txt_path="${script_dir}/${cmakeLists_txt}"
if [ ! -f "${cmakeLists_txt_path}" ]; then
  LOG "FATAL" "Could Not Build At ${script_dir} , Please Check The ${cmakeLists_txt_path}"
else
  LOG "INFO" "${project_name} Build Directory at ${script_dir}"
fi

build_dir="${script_dir}/build_${system}_release"
LOG "INFO" "Build ${project_name} Directory Is ${build_dir}"

if [ ! -d "${build_dir}" ]; then
  LOG "INFO" "Create ${project_name} Build Directory at ${build_dir}"
  mkdir "${build_dir}"
else
  LOG "WARNING" "${project_name} Build Directory Already Exists at ${script_dir}"
fi

cmakeCache_txt="CMakeCache.txt"
cmakeCache_txt_path="${build_dir}/${cmakeCache_txt}"
if [ ! -f "${cmakeCache_txt_path}" ]; then
  LOG "INFO" "${cmakeCache_txt_path} Is Not Exists"
else
  rm -f "${cmakeCache_txt_path}"
  LOG "WARNING" "Delete CMakeCache"
fi

cd "${build_dir}" || exit
LOG "INFO" "Build ${project_name} Release"

if [ $BUILD_SHARED -eq 1 ]; then
  cmake -DCMAKE_BUILD_TYPE=Release  -DBUILD_WITH_STATIC=OFF ..
else
  cmake -DCMAKE_BUILD_TYPE=Release  ..
fi

if [ $BUILD_PLUGINS -eq 0 ]; then
  cmake --build . -j"${CPU_CORES}"
else
  cmake --build .
fi

endTime=$(date '+%s')

if [ ! -f "${build_dir}/${project_name}" ]; then
  LOG "FATAL" "Build ${project_name} At ${build_dir} Failed!"
else
  LOG "SUCCESS" "Build ${project_name} At ${build_dir} Success!"
fi

LOG "INFO" "Compile Time $((${endTime} - ${startTime})) s"
