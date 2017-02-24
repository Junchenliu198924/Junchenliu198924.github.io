#!/bin/bash
today2=`date +%Y-%m-%d-%H:%M:%S`
git add . 
git commit  -m  ${today2}
git push origin master 
