use <lib/element.scad>

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

module hall(size, h) {
    r = mrr - size;
    w(p(0, mrr), p(0, r), h);
    w(p(0, r), p(1, r), h);
    translate([0, 0, h])
    linear_extrude(height = wt)
    polygon([p(0,mrr), p(0, r), p(1, r), p(1, mrr)]);
}

module main_roof(th) {
    vr = 45; // main roof angle
    rr = mrr + 0.4; // roof radius
    module half_roof() {
        assert(corners % 2 == 0);
        translate([0,0,mrh + mrr*tan(vr)])
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
    color_floor()
    o(mrr, wt);
}
// walls of main room
difference() {
    ow(mrr, mrh+4);
    main_roof(wt*14);
}
// roof of main room
if (show_roof) {
    color_roof()
    main_roof(wt);
}

// hall
hall(1.5, orh);

// outer walls
color_outer_wall()
for (i = [2:corners-2])
    w(p(i, hr), p(i+1, hr), orh);

// the non-standard outer wall on the right
module non_standard_right() {
    // calculate corners of room
    p1 = inbetween(p(1,mrr), p(2, mrr), 50);
    p2 = inbetween(p(1,hr), p(2, hr), 50);
    p3 = p(2, hr);
    p4 = p(2, mrr);
    // walls
    w(p1, p2, orh);
    w(p2, p3, orh);
    // floor
    if (show_floor) {
        linear_extrude(height = wt)
        polygon([p1, p2, p3, p4]);
    }
    // roof
    if (show_roof) {
        translate([0,0,orh])
        hull()
        for(p=[ [p1[0], p1[1], 0] + [0,0,orrh]
              , p2, p3
              , [p4[0], p4[1], 0] + [0,0,orrh]])
            translate(p) cube(wt, true);
    }
}
non_standard_right();

// the non-standard outer wall on the left
module non_standard_left() {
    // calculate corners of room
    p1 = inbetween(p(corners-1,mrr), p(0, mrr), 50);
    p2 = inbetween(p(corners-1,hr), p(0, hr), 50);
    p3 = p(corners-1, hr);
    p4 = p(corners-1, mrr);
    // walls
    w(p1, p2, orh);
    w(p2, p3, orh);
    // floor
    if (show_floor) {
        linear_extrude(height = wt)
        polygon([p1, p2, p3, p4]);
    }
    // roof
    if (show_roof) {
        translate([0,0,orh])
        hull()
        for(p=[ [p1[0], p1[1], 0] + [0,0,orrh]
              , p2, p3
              , [p4[0], p4[1], 0] + [0,0,orrh]])
            translate(p) cube(wt, true);
    }
}
non_standard_left();

// floor on outer rooms
if (show_floor) {
    color_floor()
    for (i = [2:corners-2])
        linear_extrude(height = wt)
        polygon([p(i, mrr), p(i, hr), p(i+1, hr), p(i+1,mrr)]);
}

// roof on outer rooms
if (show_roof) {
    color_roof()
    for (i = [2:corners-2])
        let (p1 = p(i, mrr))
        let (p2 = p(i+1, mrr))
        translate([0,0,orh])
        hull()
        for(p=[ [p1[0], p1[1], 0] + [0,0,orrh]
              , p(i, hr)
              , p(i+1, hr)
              , [p2[0], p2[1], 0] + [0,0,orrh]
              ])
            translate(p) cube(wt, true);

}

// winter garden
module winter_garden() {
    // calculate the corners
    p1 = inbetween(p(corners-1,hr), p(0, hr), 50);
    p2 = p(0, hr);
    p3 = p(1, hr);
    p4 = inbetween(p(1,hr), p(2, hr), 50);
    // walls
    color_glass() w(p1, p2, orh);
    color_glass() w(p2, p3, orh);
    color_glass() w(p3, p4, orh);
}
winter_garden();

// inner walls
module inner_walls() {
    if (corners == 8) {
        w(p(2, mrr), p(2, hr), orh);
        w(p(7, mrr), p(7, hr), orh);
        w(p(6, mrr), p(6, hr), orh);
        w(p(7, mrr+1.5), p(6, mrr+1.5), orh);
        w(p(5, mrr), p(5, hr), orh);
        w(p(4, mrr), p(4, hr), orh);
        w(p(3, mrr+1.5), p(4, mrr+1.5), orh);
        w(p(3, mrr), p(3, hr), orh);
        w( inbetween(p(1,mrr+(hr-mrr)/2), p(2, mrr+(hr-mrr)/2), 50)
         , p(2, mrr+(hr-mrr)/2), orh);
    }
}

color_inner_wall()
inner_walls();
