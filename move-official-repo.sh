#!/bin/bash

SRC="/home/tetra/verbatim/tamagochi-noctalia/"
DEST="/home/tetra/verbatim/noctalia-plugins/tamagotchi/"

rsync -av --delete \
	--exclude ".git" \
	"$SRC" "$DEST"
