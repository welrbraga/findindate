install:
	@echo "A instalaçao usa o parametro --install do script"
	@chmod a+x findindate.sh
	@sudo ./findindate.sh --install

uninstall:
	@echo "A desinstalaçao usa o parametro --uninstall do script"
	@sudo ./findindate.sh --uninstall
