BIB=boatpi.bib

all: boatpi.pdf README.md

boatpi.pdf: boatpi.md $(BIB)
	pandoc --number-sections --bibliography $(BIB) --standalone --to latex -o $@ $<

README.md: boatpi.md $(BIB)
	pandoc --bibliography $(BIB) --to markdown_github -o $@ $<
	echo >> README.md
	echo "<!-- Do not modify this file, it is auto-generated from boatpi.md -->" >> README.md


clean:
	rm -f boatpi.pdf
	rm -f README.md
