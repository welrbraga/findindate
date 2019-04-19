install:
	@echo "A instalaçao usa o parametro --install do script"
	@sudo ./findindate.sh --install
	@[ -f /usr/local/bin/findindate ] && echo "OK"

uninstall:
	@echo "Desinstalando o script"
	@sudo rm /usr/local/bin/findindate
	@[ ! -f /usr/local/bin/findindate ] && echo "OK"

