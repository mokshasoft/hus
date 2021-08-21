include <lib/element.scad>
include <lib/measurement.scad>

// configure the rendering
show_floor = false;
show_roof = true;
show_lawn = true;

//// configure the house
// outer size
el = 0.5; // house elevation
pw = 0.6; // plinth width
hw = 6; // house width
hl = 6; // house length
rhl = 2.6; // room height low
rhh = 4; // room height high

//// Helper values
ra = atan((rhh - rhl)/hl); // roof angle

// Corners of the outer walls of house
p1 = [0, 0];
p2 = [hw, 0];
p3 = [hw, hl];
p4 = [0, hl];

// Lawn
if (show_lawn) {
    color_lawn()
    translate([0, 0, -el])
    cube([4*hw, 4*hw, 0.04], center = true);
}

module hus() {
    // Outer walls
    color_outer_wall()
    union() {
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

module foundation() {
    // Foundation
    margin = 0.05;
    steps = 3;
    points = [for (x = [0 : steps - 1])
              for (y = [0 : steps - 1])
                  [ (1 - margin)*hw*x/(steps - 1), (1 - margin)*hl*y/(steps - 1) ]];
    color_concrete()
    translate([margin*hw/2, margin*hl/2, 0])
    for (a = points) plinth(a, pw, el);
}

hus();
translate([0,0, -el]) foundation();

// Measurements
echo("roof angle:", ra);
