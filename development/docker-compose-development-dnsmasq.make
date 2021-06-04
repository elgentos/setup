$(DOCKER_COMPOSE_DEVELOPMENT_DNSMASQ): $(DNSMASQ) | $(DOCKER_COMPOSE_DEVELOPMENT_PROFILE) $(BASH) $(UFW) $(IP)
	$(DOCKER_COMPOSE_DEVELOPMENT)/bin/dev down
	$(BASH) -c '[ -f /.dockerenv ] || sudo rm -f /etc/resolv.conf'
	sudo touch /etc/resolv.conf
	DOCKER_GATEWAY="$(shell $(IP) route | grep -E 'docker[0-9]' | awk '{ print $$9 }' | grep '.')" \
		&& $(BASH) -c \
			'source "$(DOCKER_COMPOSE_DEVELOPMENT)/.env" && echo "address=/$$DOMAINSUFFIX/'$${DOCKER_GATEWAY:-127.0.0.1}'"' \
		| sudo tee $(DOCKER_COMPOSE_DEVELOPMENT_DNSMASQ) \
		&& echo nameserver $${DOCKER_GATEWAY:-127.0.0.1} | sudo tee -a /etc/resolv.conf \
		&& cat /etc/dnsmasq.conf \
			| sed -E 's/listen-address=.+/listen-address='$${DOCKER_GATEWAY:-127.0.0.1}'/' \
			| sudo tee /etc/dnsmasq.conf
	echo nameserver 127.0.0.1 | sudo tee -a /etc/resolv.conf
	echo nameserver 1.1.1.1   | sudo tee -a /etc/resolv.conf
	echo nameserver 9.9.9.9   | sudo tee -a /etc/resolv.conf
	for con in $(shell nmcli con show --active | tail -n +2 | awk '{ print $$1 }'); do \
		nmcli con mod "$$con" ipv4.dns "$(shell $(IP) route | grep -E 'docker[0-9]' | awk '{ print $$9 }' | grep '.') 127.0.0.1 1.1.1.1 9.9.9.9"; \
		nmcli con down "$$con"; \
		nmcli con up "$$con"; \
		sudo nmcli con reload; \
	done
	for iface in $(shell $(IP) route | grep -Eo 'docker[0-9]' | uniq); do \
		sudo $(UFW) allow in on "$$iface" to any port 53 proto udp; \
	done
	cat /etc/dnsmasq.conf
	dnsmasq --test
	@echo "$(INSIDE_DOCKER):$(CI)" | grep -q '1\|true' \
		&& echo 'sudo service dnsmasq restart' \
		|| sudo service dnsmasq restart;
	sudo service docker restart
	$(BASH) -c 'source "$(DOCKER_COMPOSE_DEVELOPMENT)/.env" && sudo $(DOCKER) run --rm -t tutum/dnsutils dig setup$$DOMAINSUFFIX +short'

docker-compose-development-dnsmasq: | $(DOCKER_COMPOSE_DEVELOPMENT_DNSMASQ)

install:: | docker-compose-development-dnsmasq
