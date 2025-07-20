@echo off
cd /d C:\ClusterMonitor\CCStatus
start /min python -m http.server 8080 --bind 0.0.0.0
exit
