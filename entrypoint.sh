# entrypoint.sh
#!/usr/bin/env bash
echo "nameserver 8.8.8.8" > "/etc/resolv.conf" 
service ssh start