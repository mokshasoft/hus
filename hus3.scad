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
    octagon(hr, wt);
}
// walls of main room
difference() {
    union() {
        octawalls(mrr, mrh+6.5);
        octawalls(hr, mrh+6.5);
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
    color("gray") wall(p1, p2, orh);
    color("gray") wall(p2, p3, orh);
    color("gray") wall(p3, p4, orh);
}
winter_garden();
