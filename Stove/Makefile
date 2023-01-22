STL= \
  stove1.scad

all: stl

stl: $(STL:.scad=.stl)
$(STL:.scad=.stl): $(STL)
	openscad --render -o gen/$@ $(patsubst %.stl,%.scad,$@)

.PHONY: clean
clean:
	rm -rf gen/*
