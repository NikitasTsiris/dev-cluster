#! /bin/bash

ROOT=$1
THREADS=$2
CON=$3
DURATION=$4
RPS=$5

RESULT_DIR=$(pwd)

cd $ROOT

../wrk2/wrk -D exp -t $THREADS -c $CON -d $DURATION -L -s ./wrk2/scripts/social-network/compose-post.lua http://10.64.82.240:8080/wrk2-api/post/compose -R $RPS #> /dev/null & #$RESULT_DIR/compose-post-results/Con_"$CON"-Duration_"$DURATION"-RPS_"$RPS".out &
../wrk2/wrk -D exp -t $THREADS -c $CON -d $DURATION -L -s ./wrk2/scripts/social-network/read-home-timeline.lua http://10.64.82.240:8080/wrk2-api/home-timeline/read -R $RPS #> /dev/null & #$RESULT_DIR/read-home-results/Con_"$CON"-Duration_"$DURATION"-RPS_"$RPS".out &
../wrk2/wrk -D exp -t $THREADS -c $CON -d $DURATION -L -s ./wrk2/scripts/social-network/read-user-timeline.lua http://10.64.82.240:8080/wrk2-api/user-timeline/read -R $RPS #> /dev/null &#$RESULT_DIR/read-user-results/Con_"$CON"-Duration_"$DURATION"-RPS_"$RPS".out
