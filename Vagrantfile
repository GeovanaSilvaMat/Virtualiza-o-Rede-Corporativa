# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Configuração do roteador
  config.vm.define "router" do |router|
    router.vm.box = "ubuntu/bionic64"
    router.vm.network "private_network", type: "dhcp", name: "eth1"
    router.vm.network "private_network", type: "dhcp", name: "wlan1"
    router.vm.hostname = "router"
    router.vm.provision "shell", path: "router.sh"
  end

  # Configuração do switch
  config.vm.define "switch" do |switch|
    switch.vm.box = "ubuntu/bionic64"
    switch.vm.network "private_network", type: "dhcp", name: "eth1"
    switch.vm.hostname = "switch"
    switch.vm.provision "shell", path: "switch.sh"
      # Configurações específicas do switch
  end

  # Configuração dos hosts
  (1..7).each do |i|
    config.vm.define "host#{i}" do |host|
      host.vm.box = "ubuntu/bionic64"
      host.vm.network "private_network", type: "dhcp", name: "eth1"
      host.vm.hostname = "host#{i}"
      host.vm.provision "shell", inline: <<-SHELL
        # Configurações específicas do host#{i}
      SHELL
    end
  end

end
