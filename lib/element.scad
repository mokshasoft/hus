// constants
gr = 1.61803; // golden ration

// calculate the coordinates for the corners
function point(i, r, corners) =
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

module glas_color() {
    color("lightblue")
    children();
}

// create a wall
module wall(p1, p2, h, thickness = 300) {
    let (x_diff = p2[0] - p1[0])
    let (y_diff = p2[1] - p1[1])
    let (len = sqrt(pow(x_diff, 2) +
                    pow(y_diff, 2)))
    linear_extrude(height = h)
    translate(p1)
    rotate(atan2(y_diff, x_diff))
    translate([0, -thickness/2])
    square([len, thickness]);
}

module octagon(r, h, corners) {
    coords=[for (i = [0:corners-1]) point(i, r, corners)];
    linear_extrude(height = h)
    polygon(coords);
}

module octawalls(r, h, wt, corners) {
    difference () {
        octagon(r, h, corners);
        translate([0, 0, -wt])
        octagon(r - wt, h + 2*wt, corners);
    }
}

module window(p1, p2, pos, height, sizex, sizey, wt = 300) {
    assert(0 < pos && pos < 100);
    x_diff = p2[0] - p1[0];
    y_diff = p2[1] - p1[1];
    len = sqrt(pow(x_diff, 2) +
               pow(y_diff, 2));
    difference () {
        children();
        // create the hole for the window
        translate([0,0,height])
        translate(p1 + pos*[x_diff, y_diff]/100)
        rotate(atan2(y_diff, x_diff) + 90, [0,0,1])
        cube([4*wt, sizex, sizey], center = true);
    }
    // add the glass to the window
    glas_color()
    translate([0,0,height])
    translate(p1 + pos*[x_diff, y_diff]/100)
    rotate(atan2(y_diff, x_diff) + 90, [0,0,1])
    translate([wt/2, 0, 0])
    cube([wt/2, sizex, sizey], center = true);
}

module color_lawn() {
    color("LawnGreen")
    children();
}

module color_outer_wall() {
    color("MediumSpringGreen")
    children();
}

module color_inner_wall() {
    color("Ivory")
    children();
}

module color_roof() {
    color("Lavender")
    children();
}

module color_floor() {
    color("Wheat")
    children();
}

module color_logs() {
    color("Ivory")
    children();
}

module color_glass() {
    color("azure", 0.25)
    children();
}
