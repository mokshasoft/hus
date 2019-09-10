STL=hus1.scad
SVG=plan1.scad

all: stl svg

stl: $(STL:.scad=.stl)
$(STL:.scad=.stl): $(STL)
	openscad --render -o gen/$@ $(patsubst %.stl,%.scad,$@)

svg: $(SVG:.scad=.svg)
$(SVG:.scad=.svg): $(SVG)
	openscad --render -o gen/$@ $(patsubst %.svg,%.scad,$@)

.PHONY: clean
clean:
	rm -rf gen/*
