// constants
gr = 1.61803; // golden ration

function inbetween(p1, p2, procent = 50) =
    let (x_diff = p2[0] - p1[0])
    let (y_diff = p2[1] - p1[1])
    [ p1[0] + x_diff*procent/100
    , p1[1] + y_diff*procent/100
    ];

function h(p2d, h) =
    [p2d[0], p2d[1], h];

// create a wall
module wall(p1, p2, h, thickness = 300) {
    let (x_diff = p2[0] - p1[0])
    let (y_diff = p2[1] - p1[1])
    let (len = sqrt(pow(x_diff, 2) +
                    pow(y_diff, 2)))
    if (h != 0)
    {
        linear_extrude(height = h)
        translate(p1)
        rotate(atan2(y_diff, x_diff))
        translate([0, -thickness/2])
        square([len, thickness]);
    }
    else
    {
        translate(p1)
        rotate(atan2(y_diff, x_diff))
        translate([0, -thickness/2])
        square([len, thickness]);
    }
}

// create a wall with two different heights
module wall2(p1, p2, h1, h2, thickness = 0.5) {
    let (x_diff = p2[0] - p1[0])
    let (y_diff = p2[1] - p1[1])
    let (len = sqrt(pow(x_diff, 2) +
                    pow(y_diff, 2)))
    if ((h1 == 0)&&(h2 == 0))
    {
        wall(p1, p2, 0, thickness);
    }
    else
    {
        translate(p1)
        rotate(atan2(y_diff, x_diff))
        rotate([90, 0, 0])
        linear_extrude(height = thickness, center = true)
        polygon(points=[[0,0],[len,0],[len,h2],[0,h1]]);
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
    color_glass()
    translate([0,0,height])
    translate(p1 + pos*[x_diff, y_diff]/100)
    rotate(atan2(y_diff, x_diff) + 90, [0,0,1])
    translate([wt/2, 0, 0])
    cube([wt/2, sizex, sizey], center = true);
}

module plane(p1, p2, p3, p4, th = 0.000002) {
    v1 = [ p2[0] - p1[0]
         , p2[1] - p1[1]
         , p2[2] - p1[2]
         ];
    v2 = [ p2[0] - p3[0]
         , p2[1] - p3[1]
         , p2[2] - p3[2]
         ];
    hull()
        for(p=[p1, p2, p3, p4])
            translate(p) cube(th, true);
}

module beam(p1, p2, r = 0.4) {
    vector = [ p2[0] - p1[0]
             , p2[1] - p1[1]
             , p2[2] - p1[2]
             ];
    distance = norm(vector);
    translate(vector/2 + p1)
    rotate([0, 0, atan2(vector[1], vector[0])]) // rotationXY
    rotate([0, atan2(sqrt(pow(vector[0], 2) + pow(vector[1], 2)), vector[2]), 0]) // rotationZX
    cylinder(h = distance, r = r, $fn = 20, center = true);
}

module plinth(p, s, h) {
    translate([p[0], p[1], h/2])
    cube([s, s, h], center = true);
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
    color("azure", 0.50)
    children();
}

module color_concrete() {
    color("lightgrey")
    children();
}

// Regular polygons

// calculate the coordinates for the corners
function point(i, r, corners) =
   let (vz = 360/corners/2)
   let (angle=i*(360/corners) - vz)
   [ r*cos(angle)
   , r*sin(angle)
   ];

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

