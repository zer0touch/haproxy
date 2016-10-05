#!/bin/bash
set -x
LB_ADDR=$(/usr/bin/ipcalc `ip addr list eth0 |grep inet |cut -d' ' -f6|cut -d/ -f1,2 | head -n 1 ` | grep 'HostMax:' | awk '{print $2}')


     TX packets 28  bytes 7827 (7.6 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

case $(hostname) in
  *1*) echo yes ;;
  *3*) echo no ;;
  *) echo no ;;
esac


case $(hostname) in
*01*)
echo "Starting LB"
LB_ADDR=$LB_ADDR INT_PRIORITY=100 PRIORITY=150 /usr/local/bin/consul-template -consul 127.0.0.1:8500 -template "/etc/haproxy/haproxy.template:/etc/haproxy/haproxy.cfg:systemctl reload haproxy.service" -template "/etc/keepalived/keepalived.template:/etc/keepalived/keepalived.conf:systemctl reload keepalived.service"
;;
*02*)
echo "Starting LB"
LB_ADDR=$LB_ADDR INT_PRIORITY=150 PRIORITY=100 /usr/local/bin/consul-template -consul 127.0.0.1:8500 -template "/etc/haproxy/haproxy.template:/etc/haproxy/haproxy.cfg:systemctl reload haproxy.service" -template "/etc/keepalived/keepalived.template:/etc/keepalived/keepalived.conf:systemctl reload keepalived.service"
;;
*)
echo "Starting LB"
LB_ADDR=$LB_ADDR INT_PRIORITY=150 PRIORITY=100 /usr/local/bin/consul-template -consul 127.0.0.1:8500 -template "/etc/haproxy/haproxy.template:/etc/haproxy/haproxy.cfg:systemctl reload haproxy.service" -template "/etc/keepalived/keepalived.template:/etc/keepalived/keepalived.conf:systemctl reload keepalived.service"
;;
esac