#!/bin/bash
for element in /mnt/disks/mysqlssd0 /mnt/disks/mysqlssd1 /mnt/disks/miniossd0 /mnt/disks/miniossd1 /mnt/disks/miniossd2 /mnt/disks/miniossd3 /mnt/disks/elasticssd0 /mnt/disks/elasticssd1 /mnt/disks/logstashssd0 /mnt/disks/prometheusssd0 /mnt/disks/prometheusssd1 /mnt/disks/grafanassd0 /mnt/disks/vaultssd1
do
  echo "Element: $element"
  if [ -d "$element" ];then 
    echo "'$element' found "
  else
    sudo mkdir -p $element
fi
done
# ip='54.185.91.194'
if [ -f "knote-ingress-tls.crt" ] || [ -f "knote-ingress-tls.key" ];then 
    echo "found IP: $IP"
    rm knote-ingress-tls.crt knote-ingress-tls.key
  else
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -out knote-ingress-tls.crt -keyout knote-ingress-tls.key -subj "/CN=$IP/O=knote-ingress-tls"
fi
if [ -f "/etc/haproxy/haproxy.pem" ];then 
    echo "found /etc/haproxy/haproxy.pem $IP"
    sudo rm /etc/haproxy/haproxy.pem
    echo "cat to /etc/haproxy/haproxy.pem"
    cat knote-ingress-tls.crt | sudo tee -a /etc/haproxy/haproxy.pem
    cat knote-ingress-tls.key | sudo tee -a /etc/haproxy/haproxy.pem
    # sudo cat knote-ingress-tls.crt >> /etc/haproxy/haproxy.pem
    # sudo cat knote-ingress-tls.key >> /etc/haproxy/haproxy.pem
  else
    cat knote-ingress-tls.crt | sudo tee -a /etc/haproxy/haproxy.pem
    cat knote-ingress-tls.key | sudo tee -a /etc/haproxy/haproxy.pem
    # sudo cat knote-ingress-tls.crt >> /etc/haproxy/haproxy.pem
    # sudo cat knote-ingress-tls.key >> /etc/haproxy/haproxy.pem
fi