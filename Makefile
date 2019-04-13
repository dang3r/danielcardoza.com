all:
	hugo -d docs

debug:
	hugo server -D

unexif:
	for file in "$(ls static/header-slides/*)"; do convert "$$file" -strip "$$file"; done

.PHONY: all debug