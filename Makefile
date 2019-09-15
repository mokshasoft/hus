STL=hus1.scad hus2.scad hus3.scad plan1_1.scad plan1_2.scad

all: stl

stl: $(STL:.scad=.amf)
$(STL:.scad=.amf): $(STL)
	openscad --render -o gen/$@ $(patsubst %.amf,%.scad,$@)

.PHONY: clean
clean:
	rm -rf gen/*
