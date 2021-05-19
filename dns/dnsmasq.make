$(DNSMASQ): | $(BASH) $(UFW)
	$(BASH) -c '[ -f /.dockerenv ] || sudo $(SYSTEMCTL) disable --now systemd-resolved'
	$(BASH) -c '[ -f /.dockerenv ] || sudo rm -f /etc/resolv.conf'
	echo 'nameserver 127.0.0.1' | sudo tee    /etc/resolv.conf
	echo 'nameserver 1.1.1.1'   | sudo tee -a /etc/resolv.conf
	echo 'nameserver 9.9.9.9'   | sudo tee -a /etc/resolv.conf
	sudo mkdir -p /etc/NetworkManager/conf.d
	echo "[main]\ndns=none\nrc-manager=unmanaged" | sudo tee /etc/NetworkManager/conf.d/dnsmasq.conf
	sudo service --status-all \
		| awk '{ print $$4 }' \
		| grep -q network-manager \
			&& sudo service network-manager restart \
			|| echo 'Skipping NetworkManager restart.'
	sleep 2
	for con in $(shell nmcli con show --active | tail -n +2 | awk '{ print $$1 }'); do \
		nmcli con mod "$$con" ipv4.ignore-auto-dns yes; \
		nmcli con mod "$$con" ipv4.dns '127.0.0.1 1.1.1.1 9.9.9.9'; \
		nmcli con down "$$con"; \
		nmcli con up "$$con"; \
		sudo nmcli con reload; \
	done
	sudo $(UFW) allow out to 1.1.1.1 port 53 proto udp;
	sudo $(UFW) allow out to 9.9.9.9 port 53 proto udp;
	sudo apt install -y dnsmasq
	sudo rm -f /etc/dnsmasq.conf
	echo port=53                  | sudo tee    /etc/dnsmasq.conf
	echo domain-needed            | sudo tee -a /etc/dnsmasq.conf
	echo expand-hosts             | sudo tee -a /etc/dnsmasq.conf
	echo bogus-priv               | sudo tee -a /etc/dnsmasq.conf
	echo listen-address=127.0.0.1 | sudo tee -a /etc/dnsmasq.conf
	echo cache-size=1000          | sudo tee -a /etc/dnsmasq.conf
	dnsmasq --test
	sudo mkdir -p "$(DNSMASQ)"
	$(BASH) -c '[ -f /.dockerenv ] || sudo service dnsmasq restart'

dnsmasq: | $(DNSMASQ)

install:: | dnsmasq
