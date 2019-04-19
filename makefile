install:
	@echo "A instalaçao usa o parametro --install do script"
	@sudo ./findindate.sh --install
	@[ -f /usr/local/bin/findindate ] && echo "OK"

uninstall:
	@echo "A desinstalaçao usa o parametro --uninstall do script"
	@sudo ./findindate.sh --uninstall
	@[ ! -f /usr/local/bin/findindate ] && echo "OK"
