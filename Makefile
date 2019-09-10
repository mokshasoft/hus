STL=hus1.scad
PNG=plan1.scad

all: stl png

stl: $(STL:.scad=.stl)
$(STL:.scad=.stl): $(STL)
	openscad --render -o gen/$@ $(patsubst %.stl,%.scad,$@)

png: $(PNG:.scad=.png)
$(PNG:.scad=.png): $(PNG)
	openscad --camera=10,10,40,0,0,0 -o gen/$@ $(patsubst %.png,%.scad,$@)

.PHONY: clean
clean:
	rm -rf gen/*
