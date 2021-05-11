IP := $(shell command -v ip || echo /usr/sbin/ip)

$(IP):
	sudo apt install -y iproute2

ip: $(IP)
