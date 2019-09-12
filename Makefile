STL=hus1.scad plan1_1.scad plan1_2.scad

all: stl

stl: $(STL:.scad=.stl)
$(STL:.scad=.stl): $(STL)
	openscad --render -o gen/$@ $(patsubst %.stl,%.scad,$@)

.PHONY: clean
clean:
	rm -rf gen/*
