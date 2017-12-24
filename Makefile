BIB=boatpi.bib
boatpi.pdf: boatpi.md
	pandoc --bibliography $(BIB) --standalone -t latex -o $@ $<

clean:
	rm -f boatpi.pdf
