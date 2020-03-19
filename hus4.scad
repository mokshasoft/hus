use <element.scad>

// configure the rendering
show_floor = true;
show_roof = true;

// constants
gr = 1.61803; // golden ration

// configure the house
wt = 0.2;  // wall thickness
corners = 8; // number of corners in main room
mrr = 4; // main room radius
mrh = 6; // main room height
mrrh = 2; // main room roof height
rh = 2; // roof height

// calculate the coordinates for the corners
function p(i, r) = point(i, r, corners);

// create a wall of thickness wt
module w(p1, p2, h) {
    wall(p1, p2, h, wt);
}

module o(r, h) {
    octagon(r, h, corners);
}

module ow(r, h) {
    octawalls(r, h, wt, corners);
}

module wi(p1, p2, pos, height, sizex, sizey) {
    window(p1, p2, pos, height, sizex, sizey, wt)
    children();
}

module main_roof(r, th) {
    vr = 45; // main roof angle
    rr = r + 0.4; // roof radius
    module half_roof() {
        assert(corners % 2 == 0);
        translate([0,0, rh + r*tan(vr)])
        rotate(vr, [0, 1, 0])
        rotate(-90)
        difference() {
            scale([1,1/cos(vr), 1])
            o(rr, th);
            translate([0, -rr, 0])
            cube([rr*2, rr*2, 3*th], center = true);
        }
    }
    half_roof();
    rotate(180) half_roof();
}

module side_block() {
    // floor of main room
    if (show_floor) {
        o(mrr, wt);
    }
    // walls of main room
    difference() {
        ow(mrr, mrh);
        main_roof(mrr, wt*200);
    }
    // roof of main room
    if (show_roof) {
        main_roof(mrr, wt);
    }
}

// Left and right octagon blocks
block_offset = mrr + mrr/gr;
translate([0, block_offset, 0]) side_block();
translate([0, -block_offset, 0]) side_block();

//
// Central part of the house
//

// Front wall
pf = p(2, mrr) - [0, block_offset];
w(pf, pf + [0, block_offset], 2);
// Back wall
pb = p(4, mrr) - [0, block_offset];
w(pb, pb + [0, block_offset*1.6], 2);
