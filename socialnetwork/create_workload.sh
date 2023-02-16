#! /bin/bash

ROOT=$1

cd $ROOT/wrk2

make

./wrk -D exp -t 10 -c 5 -d 600 -L -s ./scripts/social-network/compose-post.lua http://192.168.121.240:8080/wrk2-api/post/compose -R 100 &
./wrk -D exp -t 10 -c 5 -d 600 -L -s ./scripts/social-network/read-home-timeline.lua http://192.168.121.240:8080/wrk2-api/home-timeline/read -R 100 &
./wrk -D exp -t 10 -c 5 -d 600 -L -s ./scripts/social-network/read-user-timeline.lua http://192.168.121.240:8080/wrk2-api/user-timeline/read -R 100
