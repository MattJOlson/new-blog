clean:
	rm css/style.css
	cabal new-run site clean
.PHONY : clean

build: css
	cabal new-run site build
.PHONY : build

watch: css
	cabal new-run site watch
.PHONY : watch

refresh: clean watch
.PHONY : refresh

css: css/style.css
.PHONY : css

css/style.css: css/default.css
	npx tailwindcss -i css/default.css -o css/style.css