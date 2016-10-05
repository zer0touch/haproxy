haproxy
======
Creates the haproxy docker build
  - the container has the following components installed. 
    - haproxy
    - keepalived
    - consul-template


The container build currently leverages systemd as there are a few dependent processes that need to be started up for this to work. The primary reason for using systemd was as a result of keepalived not working particularly well when running in the foreground in docker mode. The other design idea was that running keepalived within the same container meant that if the either of the processes stopped working would it would result in a failover, whereas running in separate containers would require an interogation of the keepalived and vice versa to determine if the process was running or not.  Systemd already has this capability built into it, so seemed like overkill to write a wrapper layer for something that already existed. 
  
## Example
Run the haproxy container example
Ths runs the container in host mode so you access the root net namespace.  This needs to have the cap net admin capability, so run with either privileged mode or add the appropriate capability

  $docker run --net=host --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /etc/ssl/:/etc/ssl/ -d zer0touch/haproxy /lib/systemd/systemd
  configuration is provided by consul template. 
## TODO
  
## Issues

