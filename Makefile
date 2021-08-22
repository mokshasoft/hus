STL= \
  floorplan.scad \
  hus1-plan.scad \
  hus1.scad \
  hus2.scad \
  hus3.scad \
  hus4.scad \
  hus5.scad \
  hus6-plan.scad \
  hus6.scad \
  hus7.scad \
  plan1_1.scad \
  plan1_2.scad \
  hus8.scad

all: stl

stl: $(STL:.scad=.stl)
$(STL:.scad=.stl): $(STL)
	openscad --render -o gen/$@ $(patsubst %.stl,%.scad,$@)

.PHONY: clean
clean:
	rm -rf gen/*
