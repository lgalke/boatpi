boatpi.pdf: boatpi.pandoc
	pandoc --standalone -t latex -o $@ $<

clean:
	rm boatpi.pdf
