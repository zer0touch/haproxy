#!/bin/bash
set -x
LB_CALC=$(/usr/bin/ipcalc `ip addr list ens192 |grep inet |cut -d' ' -f6|cut -d/ -f1,2 | head -n 1 ` | grep 'HostMax:' | awk '{print $2}')
env
LBADDR=10.72.137.221
case $(hostname) in
*01*)
LB_ADDR=$LBADDR INT_PRIORITY=100 PRIORITY=102 /usr/local/bin/consul-template -consul 127.0.0.1:8500 -template "/etc/haproxy/haproxy.template:/etc/haproxy/haproxy.cfg:systemctl reload haproxy.service" -template "/etc/keepalived/keepalived.template:/etc/keepalived/keepalived.conf:systemctl reload keepalived.service"
;;
*02*)
LB_ADDR=$LBADDR INT_PRIORITY=101 PRIORITY=100 /usr/local/bin/consul-template -consul 127.0.0.1:8500 -template "/etc/haproxy/haproxy.template:/etc/haproxy/haproxy.cfg:systemctl reload haproxy.service" -template "/etc/keepalived/keepalived.template:/etc/keepalived/keepalived.conf:systemctl reload keepalived.service"
;;
*)
LB_ADDR=$LBADDR INT_PRIORITY=102 PRIORITY=101 /usr/local/bin/consul-template -consul 127.0.0.1:8500 -template "/etc/haproxy/haproxy.template:/etc/haproxy/haproxy.cfg:systemctl reload haproxy.service" -template "/etc/keepalived/keepalived.template:/etc/keepalived/keepalived.conf:systemctl reload keepalived.service"
;;
esac
