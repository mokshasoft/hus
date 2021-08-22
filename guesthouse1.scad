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
// Winter garden
ww = 3; // winter garden width
wd = 2; // winter garden depth

//// Helper values
ra = atan((rhh - rhl)/hl); // roof angle
ras = atan((rhh - rhl)/wd); // roof angle south

// Corners of the outer walls of house
p1 = [0, 0];
p2 = [hw, 0];
p3 = [hw, hl];
p4 = [0, hl];

// Corners of the winter garden
g1 = p4;
g2 = p4 + [ww, 0];
g3 = g2 + [0, wd];
g4 = g1 + [0, wd];

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
    
    // Winter garden
    color_glass()
    union() {
        wall2(g2, g3, rhh, rhl, 0.2);
        wall2(g3, g4, rhl, rhl, 0.2);
        wall2(g1, g4, rhh, rhl, 0.2);
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
    sp = [g4, g3, g4 + [hw, 0]];
    color_concrete()
    union() {
        // Main house
        translate([margin*hw/2, margin*hl/2, 0])
        for (a = points) plinth(a, pw, el);
        // South patio
        for (a = sp) plinth(a, pw, el);
    }
}

hus();
translate([0,0, -el]) foundation();

// Measurements
echo("roof angle:", ra);
echo("roof angle south:", ras);
