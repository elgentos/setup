INTERACTIVE:=$(shell cat /proc/1/cgroup | cut -d: -f3 | grep -q '/docker/' && echo 0 || echo 1)
INSIDE_DOCKER:=$(shell cat /proc/1/cgroup | cut -d: -f3 | grep -q '/docker/' && echo 1 || echo 0)
CI=0

install:: | flags # no-verify
optional::

all: | install optional

include */*.vars.make */*/*.vars.make */*.make */*/*.make

flags:
	@echo "INTERACTIVE: $(INTERACTIVE)"
	@echo "INSIDE_DOCKER: $(INSIDE_DOCKER)"
	@echo "CI: $(CI)"
