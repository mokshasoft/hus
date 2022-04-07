flat = false;
floorFrame = false;
logs = true;

pw = 0.5; // plinth width
ph = 0.25; // plinth height
sx = 8.3; // house width
sy = 10.2; // house length

p2 = -0.05;

n = [0, p2];
ne = [p2, p2];
e = [p2, 0];
se = [p2, -p2];
s = [0, -p2];
sw = [-p2, -p2];
w = [-p2, 0];
nw = [-p2, p2];

module plinth(x, y) {
    echo("plinth position: ", [x, y])
    if (flat) {
        color("gray")
        translate([x, y])
        circle($fn = 20, r = pw/2);
    } else {
        color("gray")
        translate([x, y, ph/2])
        cylinder($fn = 20, h = ph, r = pw/2, center = true);
    }
}

// Corners
wt = 0.5;
wt2 = wt/2;
c1 = [0 + wt, 0 + wt];
c2 = [0 + wt, sy - wt];
c3 = [sx - wt, sy - wt];
c4 = [sx - wt, 1.7 + wt];
c5 = [3.1 - wt, 1.7 + wt];
c6 = [3.1 - wt, 0 + wt];
oc1 = [0, 0];
oc2 = [0, sy];
oc3 = [sx, sy];
oc4 = [sx, 1.7];
oc5 = [3.1, 1.7];
oc6 = [3.1, 0];


// Outer surface area
if (flat) {
    color("blue", 0.3)
    difference() {
        polygon([oc1, oc2, oc3, oc4, oc5, oc6]);
        polygon([c1, c2, c3, c4, c5, c6]);
    }
} else {
    translate([0, 0, ph])
    linear_extrude(0.01)
    difference() {
        polygon([oc1, oc2, oc3, oc4, oc5, oc6]);
        polygon([c1, c2, c3, c4, c5, c6]);
    }
}

// Create a line of plinths
module plinth_line(coord1, coord2, nbr, tag = "cc") {
    assert(nbr >= 2, "more than two plinths");
    let ( cc = (coord2 - coord1)/(nbr - 1)
        )
        echo(tag, sqrt(cc[0]*cc[0] + cc[1]*cc[1]))
        for (i=[0:nbr - 1])
          plinth(coord1[0] + i*cc[0], coord1[1] + i*cc[1]);
}

module beam(p1, p2, width, height, color = "yellow") {
    let ( x_diff = p2[0] - p1[0]
        , y_diff = p2[1] - p1[1]
        , length = sqrt(pow(x_diff, 2) + pow(y_diff, 2))
        )
        color(color)
        translate(p1 + (p2 - p1)/2)
        rotate(atan2(y_diff, x_diff))
        cube([length, width, height], center = true);
}

module doublebeam(p1, p2, width, height) {
    beam(p1, p2, width, height);
    translate([0, 0, height]) beam(p1, p2, width, height, "gray");
}

// Outer beams

if (floorFrame) {
    let ( th = 0.06
        , h = 0.2
        )
    translate([0, 0, 0.8]) 
    union() {
        doublebeam(c1, c2, th, h);
        doublebeam(c2, c3, th, h);
        doublebeam(c3, c4, th, h);
        doublebeam(c4, c5, th, h);
        doublebeam(c5, c6, th, h);
        doublebeam(c6, c1, th, h);
    }
}

if (true) {
    // Wall plinths
    plinth_line(oc1 + [wt2, wt2], oc2 + [wt2, -wt2], 5, "line 1");
    plinth_line(oc1 + [2.8 - wt2, wt2], oc2 + [2.8 -wt2, -wt2], 5, "line 2");
    plinth_line(oc1 + [5.0, wt2], oc2 + [5.0, -wt2], 5, "line 4");
    plinth_line(oc1 + [8.3 - wt2, wt2], oc3 + [-wt2, -wt2], 5, "line 4");

    // Winter garden
    let ( l1 = 3.7
        , l2 = 3.75
        , w = 2.5
        )
        plinth_line([-w, l1], [-w, l2 + l1], 3, "winter garden");
}
    
module log(l) {
    rotate([-90, 0, 0])
    cylinder($fn = 20, h = l, r = 0.125);
}
 
if (logs) {
    translate([wt2, 0, ph + 0.12]) log(10.2);
}
