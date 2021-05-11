INTERACTIVE=1

install::
optional::

all: | install optional

include */*.make */*/*.make
