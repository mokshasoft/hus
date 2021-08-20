include <lib/element.scad>
include <lib/measurement.scad>

// configure the rendering
show_floor = false;
show_roof = true;
show_lawn = true;

//// configure the house
// outer size
hw = 6; // house width
hl = 6; // house length
rhl = 2.6; // room height low
rhh = 4; // room height high

// Corners of the outer walls of house
p1 = [0, 0];
p2 = [hw, 0];
p3 = [hw, hl];
p4 = [0, hl];

// Lawn
if (show_lawn) {
    color_lawn()
    translate([0, 0, -0.5])
    cube([4*hw, 4*hw, 0.04], center = true);
}

module hus() {
    color_outer_wall()
    union() {
        // Outer walls
        wall2(p1, p2, rhl, rhl);
        wall2(p2, p3, rhl, rhh);
        wall2(p3, p4, rhh, rhh);
        wall2(p4, p1, rhh, rhl);
    }

    if (show_floor) {
        color_floor()
        linear_extrude(0.5)
        polygon([p1, p2, p3, p4]);
    }
}

hus();

// Measurements
echo("roof angle:", atan((rhh - rhl)/hl));