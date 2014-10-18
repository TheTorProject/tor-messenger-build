rbm=./rbm/rbm

all: submodule-update tor-messenger-linux-x86_64

tor-messenger-linux-x86_64:
	$(rbm) build tor-messenger --target linux-x86_64

submodule-update:
	git submodule update --init

fetch:
	$(rbm) fetch

