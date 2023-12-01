#!/bin/bash

# Atualiza a lista de pacotes
sudo apt-get update

# Configuração da interface de rede
sudo ip addr add 192.168.50.2/24 dev enp0s8
sudo ip link set enp0s8 up
