INTERACTIVE=1

install::
optional::

all: | install optional

include */*.vars.make */*/*.vars.make */*.make */*/*.make
