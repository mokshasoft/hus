STL=hus1.scad hus2.scad hus3.scad plan1_1.scad plan1_2.scad guesthouse2.scad

all: stl

stl: $(STL:.scad=.stl)
$(STL:.scad=.stl): $(STL)
	openscad --render -o gen/$@ $(patsubst %.stl,%.scad,$@)

.PHONY: clean
clean:
	rm -rf gen/*
