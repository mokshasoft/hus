STL= \
  garage1.escad

all: stl

stl: $(STL:.escad=.stl)
$(STL:.escad=.stl): $(STL)
	extopenscad -o $@ $(patsubst %.stl,%.escad,$@)

.PHONY: clean
clean:
	rm -rf *.stl
