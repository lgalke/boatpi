BIB=boatpi.bib

all: boatpi.pdf README.md

boatpi.pdf: boatpi.md $(BIB)
	pandoc --bibliography $(BIB) --standalone --to latex -o $@ $<

README.md: boatpi.md $(BIB)
	pandoc --bibliography $(BIB) --to markdown_github -o $@ $<


clean:
	rm -f boatpi.pdf
	rm -f README.md
