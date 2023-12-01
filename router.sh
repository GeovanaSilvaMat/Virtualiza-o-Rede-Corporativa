#!/bin/bash

sudo sysctl net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

# aplicação do monitoramento do tráfego de rede considerando a porta 80
sudo apt install tcpdump -y
sudo tcpdump -i eth1 -c 5 port 80

# Atualiza a lista de pacotes
sudo apt-get update

# Instalação do FreeRADIUS e hostapd
sudo apt-get install -y freeradius hostapd

# Configuração do FreeRADIUS
sudo sed -i 's/\(^.*-l \).*$/\1/' /etc/default/freeradius

# Reinicia o serviço FreeRADIUS
sudo service freeradius restart

# Configuração do servidor DHCP para enviar opção de RADIUS aos clientes
echo 'option radius-server code 241 = string;' | sudo tee -a /etc/dhcp/dhcpd.conf
echo 'send dhcp-option 241 "192.168.50.1";' | sudo tee -a /etc/dhcp/dhcpd.conf
sudo service isc-dhcp-server restart

# Configuração da interface de rede cabeada e wireless (eth0 e wlan0)
sudo cat <<EOF | sudo tee /etc/network/interfaces.d/eth0
allow-hotplug eth0
iface eth0 inet static
  address 192.168.50.1
  netmask 255.255.255.0
EOF

sudo cat <<EOF | sudo tee /etc/network/interfaces.d/wlan0
allow-hotplug wlan0
iface wlan0 inet static
  address 192.168.50.2
  netmask 255.255.255.0
EOF

# Configuração do hostapd
sudo cat <<EOF | sudo tee /etc/hostapd/hostapd.conf
interface=wlan0
ssid=NomeDaRede
hw_mode=g
channel=6
auth_algs=1
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
EOF

# Reinicia os serviços DHCP e hostapd
sudo service isc-dhcp-server restart
sudo service hostapd restart
