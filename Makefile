# Имя проекта
PROJECT_NAME = vinnny-gift

NAME_SUFFIX = $(shell date +%Y%m%d)-$(shell git log --format="%h" -n 1)

ifeq ($(COPY_SNAPSHOT_TO),)
	COPY_SNAPSHOT_TO = C:\Temp
endif

.PHONY: all build clean

all: build

build: $(PARTS:%=build/%.bin.zx0) ## Default: build project
	@printf "\033[32mBuilding '$(PROJECT_NAME)'\033[0m\n"

	mkdir -p build
	rm -f build/*.trd

	sjasmplus --fullpath --color=off --inc=src/. \
		-DSNA_FILENAME=\"build/$(PROJECT_NAME)-$(NAME_SUFFIX).sna\" \
		-DTRD_FILENAME=\"build/$(PROJECT_NAME).trd\" \
		src/main.asm

	cp --force build/$(PROJECT_NAME)-$(NAME_SUFFIX).sna $(COPY_SNAPSHOT_TO)
	@printf "\033[32mDone\033[0m\n"


clean: ## Remove all artifacts
	rm -f build/*

help: 	## Display available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-8s\033[0m %s\n", $$1, $$2}' 
