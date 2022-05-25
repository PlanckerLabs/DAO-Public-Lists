VERSION=$(shell node VERSION.js)

.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo "Available targets:"
	@echo "1、clean\n2、all\n3、build"

.PHONY: clean
clean:
	@rm -rf build 


.PHONY: build
build:
	@echo "Building release version $(VERSION)"
	@node ./node_modules/sol-merger/dist/bin/sol-merger.js "./contracts/soulBoundBridge.sol" ./build
	@node ./node_modules/sol-merger/dist/bin/sol-merger.js "./contracts/soulBoundMedal.sol" ./build

.PHONY: cleanup
cleanup:
	@echo "cleanup errors"
	@sed -i '' 's/SPDX-License-Identifier: MIT/_/g' ./build/*.sol
	

.PHONY: all
all:
	make clean
	make build
	make cleanup
	@echo "Build finished"