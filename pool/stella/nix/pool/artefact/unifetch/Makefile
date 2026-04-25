PREFIX = /usr
MANDIR = $(PREFIX)/share/man

all:
	@printf "Run 'make install' to install UniFetch.\n"

install:
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	@mkdir -p $(DESTDIR)$(MANDIR)/man1
	@mkdir -p $(DESTDIR)$(PREFIX)/share
	@mkdir -p $(DESTDIR)$(PREFIX)/share/unifetch
	@mkdir -p $(DESTDIR)$(PREFIX)/share/unifetch/baz_plugin
	@cp -p unifetch $(DESTDIR)$(PREFIX)/bin/unifetch
	@cp -p unifetch.1 $(DESTDIR)$(MANDIR)/man1/unifetch.1
	@cp -p baz.env $(DESTDIR)$(PREFIX)/share/unifetch/baz_plugin/baz.env
	@cp -pr hooks $(DESTDIR)$(PREFIX)/share/unifetch/baz_plugin/hooks
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/unifetch
	@cd $(DESTDIR)$(PREFIX)/bin && ln -sf unifetch neofetch

uninstall:
	@rm -rf $(DESTDIR)$(PREFIX)/bin/unifetch
	@rm -rf $(DESTDIR)$(PREFIX)/bin/neofetch
	@rm -rf $(DESTDIR)$(MANDIR)/man1/unifetch.1*
	@rm -rf $(DESTDIR)$(PREFIX)/share/unifetch
