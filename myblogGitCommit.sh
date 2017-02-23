#!/bin/bash
today2=`date --date='0 days ago' +%Y-%m-%d`
git add . 
git commit  -m  today2 
git push origin master 
