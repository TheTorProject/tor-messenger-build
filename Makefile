rbm=./rbm/rbm

all: tor-messenger

tor-messenger: tor-messenger-linux-x86_64 tor-messenger-linux-i686 tor-messenger-windows-i686 tor-messenger-windows-x86_64 tor-messenger-osx-x86_64

tor-messenger-release: submodule-update
	$(rbm) build tor-messenger-release --target tormessenger-all

tor-mail: tor-mail-linux-x86_64 tor-mail-linux-i686 tor-mail-windows-i686 tor-mail-windows-x86_64 tor-mail-osx-x86_64

tor-messenger-linux-x86_64: submodule-update
	$(rbm) build tor-messenger --target tor-messenger --target tormessenger-linux-x86_64

tor-messenger-linux-i686: submodule-update
	$(rbm) build tor-messenger --target tor-messenger --target tormessenger-linux-i686

tor-messenger-windows-i686: submodule-update
	$(rbm) build tor-messenger --target tor-messenger --target tormessenger-windows-i686

tor-messenger-windows-x86_64: submodule-update
	$(rbm) build tor-messenger --target tor-messenger --target tormessenger-windows-x86_64

tor-messenger-osx-x86_64: submodule-update
	$(rbm) build tor-messenger --target tor-messenger --target tormessenger-osx-x86_64

tor-mail-linux-x86_64: submodule-update
	$(rbm) build tor-mail --target tor-mail --target tormail-linux-x86_64

tor-mail-linux-i686: submodule-update
	$(rbm) build tor-mail --target tor-mail --target tormail-linux-i686

tor-mail-windows-i686: submodule-update
	$(rbm) build tor-mail --target tor-mail --target tormail-windows-i686

tor-mail-windows-x86_64: submodule-update
	$(rbm) build tor-mail --target tor-mail --target tormail-windows-x86_64

tor-mail-osx-x86_64: submodule-update
	$(rbm) build tor-mail --target tor-mail --target tormail-osx-x86_64

submodule-update:
	git submodule update --init

fetch:
	$(rbm) fetch

clean-old: submodule-update
	./tools/clean-old

