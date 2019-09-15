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
function p(i, r) =
   let (vz = 360/corners/2)
   let (angle=i*(360/corners) - vz)
   [ r*cos(angle)
   , r*sin(angle)
   ];

function inbetween(p1, p2, procent) =
    let (x_diff = p2[0] - p1[0])
    let (y_diff = p2[1] - p1[1])
    [ p1[0] + x_diff*procent/100
    , p1[1] + y_diff*procent/100
    ];

// create a wall of thickness wt
module wall(p1, p2, h) {
    let (x_diff = p2[0] - p1[0])
    let (y_diff = p2[1] - p1[1])
    let (len = sqrt(pow(x_diff, 2) +
                    pow(y_diff, 2)))
    linear_extrude(height = h)
    translate(p1)
    rotate(atan2(y_diff, x_diff))
    translate([0, -wt/2])
    square([len, wt]);
}

module octagon(r, h) {
    coords=[for (i = [0:corners-1]) p(i, r)];
    linear_extrude(height = h)
    polygon(coords);
}

module octawalls(r, h) {
    difference () {
        octagon(r, h);
        translate([0, 0, -wt])
        octagon(r - wt, h + 2*wt);
    }
}

module hall(size, h) {
    r = mrr - size;
    wall(p(0, mrr), p(0, r), h);
    wall(p(0, r), p(1, r), h);
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
            octagon(rr, th);
            translate([0, -rr, 0])
            cube([rr*2, rr*2, 3*th], center = true);
        }
    }
    half_roof();
    rotate(180) half_roof();
}

// floor of main room
if (show_floor) {
    octagon(mrr, wt);
}
// walls of main room
difference() {
    octawalls(mrr, mrh+4);
    main_roof(wt*14);
}
// roof of main room
if (show_roof) {
    main_roof(wt);
}

// hall
hall(1.5, orh);

// outer walls
for (i = [2:corners-2])
    wall(p(i, hr), p(i+1, hr), orh);

// the non-standard outer wall on the right
module non_standard_right() {
    // calculate corners of room
    p1 = inbetween(p(1,mrr), p(2, mrr), 50);
    p2 = inbetween(p(1,hr), p(2, hr), 50);
    p3 = p(2, hr);
    p4 = p(2, mrr);
    // walls
    wall(p1, p2, orh);
    wall(p2, p3, orh);
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
    wall(p1, p2, orh);
    wall(p2, p3, orh);
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
    for (i = [2:corners-2])
        linear_extrude(height = wt)
        polygon([p(i, mrr), p(i, hr), p(i+1, hr), p(i+1,mrr)]);
}

// roof on outer rooms
if (show_roof) {
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
    color("gray") wall(p1, p2, orh);
    color("gray") wall(p2, p3, orh);
    color("gray") wall(p3, p4, orh);
}
winter_garden();

// inner walls
module inner_walls() {
    if (corners == 8) {
        wall(p(2, mrr), p(2, hr), orh);
        wall(p(7, mrr), p(7, hr), orh);
        wall(p(6, mrr), p(6, hr), orh);
        wall(p(7, mrr+1.5), p(6, mrr+1.5), orh);
        wall(p(5, mrr), p(5, hr), orh);
        wall(p(4, mrr), p(4, hr), orh);
        wall(p(3, mrr+1.5), p(4, mrr+1.5), orh);
        wall(p(3, mrr), p(3, hr), orh);
        wall( inbetween(p(1,mrr+(hr-mrr)/2), p(2, mrr+(hr-mrr)/2), 50)
        , p(2, mrr+(hr-mrr)/2), orh);
    }
}
inner_walls();
