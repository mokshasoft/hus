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
mrh = 4; // main room height
mrrh = 2; // main room roof height
hr = mrr + 4; // house radius
orh = 2.5; // outer room height
orrh = 1; // outer room roof height

// calculate approximate house size
function house_size() =
   let(v=360/corners/2)
   let(a=hr*sin(v))
   let(b=hr*cos(v))
   (corners-2)*a*b;
echo("area of house = ", house_size());

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
        translate([0,0, orh + r*tan(vr)])
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

// floor of main room
if (show_floor) {
    o(hr, wt);
}
// walls of main room
difference() {
    union() {
        ow(mrr, mrh+6.5);
        ow(hr, mrh+6.5);
    }
    main_roof(hr, wt*200);
}
// roof of main room
if (show_roof) {
    main_roof(hr, wt);
}

// winter garden
module winter_garden() {
    // calculate the corners
    p1 = inbetween(p(corners-1,hr), p(0, hr), 50);
    p2 = p(0, hr);
    p3 = p(1, hr);
    p4 = inbetween(p(1,hr), p(2, hr), 50);
    // walls
    color("gray") w(p1, p2, orh);
    color("gray") w(p2, p3, orh);
    color("gray") w(p3, p4, orh);
}
winter_garden();
