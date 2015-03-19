rbm=./rbm/rbm

all: submodule-update tor-messenger-linux-x86_64 tor-messenger-linux-i686 tor-messenger-windows-i686

tor-messenger-linux-x86_64:
	$(rbm) build tor-messenger --target tor-messenger --target linux-x86_64

tor-messenger-linux-i686:
	$(rbm) build tor-messenger --target tor-messenger --target linux-i686

tor-messenger-windows-i686:
	$(rbm) build tor-messenger --target tor-messenger --target windows-i686

submodule-update:
	git submodule update --init

fetch:
	$(rbm) fetch

clean-old: submodule-update
	./tools/clean-old

