#!/bin/bash
trap : SIGTERM SIGINT

function echoUsage()
{
    echo -e "Usage: ./run.sh [FLAG] [PARAMETER FILE PATH FROM HOST] \n\
            \t -o : Run ov2slam \n\
            \t -h help \n
            \t Example: ./run.sh -ov2slam /home/agslam/ov2slam/parameters_files/camera.yaml \n " >&2
}

function absPath() 
{
    # generate absolute path from relative path
    # $1     : relative filename
    # return : absolute path
    if [ -d "$1" ]; then
        # dir
        (cd "$1"; pwd)
    elif [ -f "$1" ]; then
        # file
        if [[ $1 = /* ]]; then
            echo "$1"
        elif [[ $1 == */* ]]; then
            echo "$(cd "${1%/*}"; pwd)/${1##*/}"
        else
            echo "$(pwd)/$1"
        fi
    fi
}

function relativePath()
{
    # both $1 and $2 are absolute paths beginning with /
    # returns relative path to $2/$target from $1/$source
    source=$1
    target=$2

    common_part=$source # for now
    result="" # for now

    while [[ "${target#$common_part}" == "${target}" ]]; do
        # no match, means that candidate common part is not correct
        # go up one level (reduce common part)
        common_part="$(dirname $common_part)"
        # and record that we went back, with correct / handling
        if [[ -z $result ]]; then
            result=".."
        else
            result="../$result"
        fi
    done

    if [[ $common_part == "/" ]]; then
        # special case for root (no common path)
        result="$result/"
    fi

    # since we now have identified the common part,
    # compute the non-common part
    forward_part="${target#$common_part}"

    # and now stick all parts together
    if [[ -n $result ]] && [[ -n $forward_part ]]; then
        result="$result$forward_part"
    elif [[ -n $forward_part ]]; then
        # extra slash removal
        result="${forward_part:1}"
    fi

    echo $result
}

#if [ "$#" -lt 1 ]; then
#  echoUsage
#  exit 1
#fi

DO_OV2SLAM=0
DO_VINS=0
KITTI=0

while getopts "holk" opt; do
    case "$opt" in
        h)
            echoUsage
            exit 0
            ;;
        o)  DO_OV2SLAM=1
            ;;
        l)  DO_VINS=1
            ;;
        k)  KITTI=1
            ;;
        *)
            echoUsage
            exit 1
            ;;
    esac
done


 CONFIG_IN_DOCKER="/root/catkin_ws/src/ov2slam/$(relativePath $(absPath ..) $(absPath ${*: -1}))"


roscore &
ROSCORE_PID=$!
sleep 1

#rviz -d ../config/vins_rviz_config.rviz &
#RVIZ_PID=$!

OV2SLAM_DIR=$(absPath "..")

if [ $DO_OV2SLAM -eq 1 ]; then
        docker run \
        -it \
        --rm \
        --net=host \
        -v ${OV2SLAM_DIR}/include:/root/catkin_ws/src/ov2slam/include \
        -v ${OV2SLAM_DIR}/src:/root/catkin_ws/src/ov2slam/src \
        -v ${OV2SLAM_DIR}/parameters_files:/root/catkin_ws/src/ov2slam/parameters_files \
        agslam/ov2slam:V1 \
        /bin/bash -c \
        "cd /root/catkin_ws/; \

            catkin build; \
            source devel/setup.bash; \
            rosrun ov2slam ov2slam_node ${CONFIG_IN_DOCKER}"
fi

wait $ROSCORE_PID
wait $RVIZ_PID

if [[ $? -gt 128 ]]
then
    kill $ROSCORE_PID
    kill $RVIZ_PID
fi
