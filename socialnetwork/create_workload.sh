#! /bin/bash

ROOT=$1

cd $ROOT


../wrk2/wrk -D exp -t 10 -c 50 -d 6 -L -s ./wrk2/scripts/social-network/compose-post.lua http://10.96.12.240:8080/wrk2-api/post/compose -R 100 &
../wrk2/wrk -D exp -t 10 -c 50 -d 6 -L -s ./wrk2/scripts/social-network/read-home-timeline.lua http://10.96.12.240:8080/wrk2-api/home-timeline/read -R 100 &
../wrk2/wrk -D exp -t 10 -c 50 -d 6 -L -s ./wrk2/scripts/social-network/read-user-timeline.lua http://10.96.12.240:8080/wrk2-api/user-timeline/read -R 100
