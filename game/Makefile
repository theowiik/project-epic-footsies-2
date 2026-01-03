.PHONY: format check build dev

NIX := nix --extra-experimental-features 'nix-command flakes'

format:
	$(NIX) run .#format

check:
	$(NIX) run .#check

build:
	$(NIX) run .#build

dev:
	$(NIX) develop
