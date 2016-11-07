rbm=./rbm/rbm

all: tor-messenger

tor-messenger: tor-messenger-linux-x86_64 tor-messenger-linux-i686 tor-messenger-windows-i686 tor-messenger-osx-x86_64

tor-messenger-release: submodule-update
	$(rbm) build tor-messenger-release

tor-mail: tor-mail-linux-x86_64 tor-mail-linux-i686

tor-messenger-linux-x86_64: submodule-update
	$(rbm) build tor-messenger --target tor-messenger --target linux-x86_64

tor-messenger-linux-i686: submodule-update
	$(rbm) build tor-messenger --target tor-messenger --target linux-i686

tor-messenger-windows-i686: submodule-update
	$(rbm) build tor-messenger --target tor-messenger --target windows-i686

tor-messenger-osx-x86_64: submodule-update
	$(rbm) build tor-messenger --target tor-messenger --target osx-x86_64

tor-mail-linux-x86_64: submodule-update
	$(rbm) build tor-mail --target tor-mail --target linux-x86_64

tor-mail-linux-i686: submodule-update
	$(rbm) build tor-mail --target tor-mail --target linux-i686

submodule-update:
	git submodule update --init

fetch:
	$(rbm) fetch

clean-old: submodule-update
	./tools/clean-old

