include <compose.scad>

layer(0) full_layer(2, 3);
layer(1) full_layer(2, 3);

*compose2() {
    brick();
    translate([0.20, 0, 0]) brick();
}
