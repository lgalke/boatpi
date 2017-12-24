BIB=boatpi.bib

all: boatpi.pdf README.md

boatpi.pdf: boatpi.md $(BIB)
	pandoc --bibliography $(BIB) --standalone -t latex -o $@ $<

README.md: boatpi.md $(BIB)
	pandoc --bibliography $(BIB) --standalone -t markdown_github -o $@ $<


clean:
	rm -f boatpi.pdf
