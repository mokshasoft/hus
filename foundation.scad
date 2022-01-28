flat = false;

pw = 0.3; // plinth width
ph = 0.6; // plinth height
pd = 0.8; // plinth depth

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
    // above ground
    if (flat) {
        translate([x, y])
        square([pw, pw], center = true);
    } else {
        color("gray")
        translate([x, y, ph/2])
        cube([pw, pw, ph], center = true);
    }
        
    // below ground
    if (flat) {
        translate([x, y])
        square([pw, pw], center = true);
    } else {
        color("azure", 0.80)
        translate([x, y, -pd/2])
        cube([pw, pw, pd], center = true);
    }
}

// Corners
wt = 0.5;
c1 = [0 + wt, 0 + wt];
c2 = [0 + wt, 9.2 - wt];
c3 = [8.3 - wt, 9.2 - wt];
c4 = [8.3 - wt, 1.7 + wt];
c5 = [3.1 - wt, 1.7 + wt];
c6 = [3.1 - wt, 0 + wt];
oc1 = [0, 0];
oc2 = [0, 9.2];
oc3 = [8.3, 9.2];
oc4 = [8.3, 1.7];
oc5 = [3.1, 1.7];
oc6 = [3.1, 0];


// Outer surface area
if (flat) {
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

if (true) {
    // Wall plinths
    plinth_line(c1 + ne, c2 + se, 5, "south wall");
    plinth_line(c2 + se, c3 + sw, 4, "west wall");
    plinth_line(c3 + sw, c4 + nw, 4, "north wall");
    plinth_line(c4 + nw, c5 + nw, 3, "east wall");
    plinth(c6[0] + nw[0], c6[1] + nw[1]);

    // Center plinths
    let ( c = (c2 + c4)/2
        , d = 2.5
        )
        for (x=[0:1], y=[0:1])
            plinth( c[0] + x*d - d/2
                  , c[1] + y*d - d/2
                  );

    // Front porch plinths
    let ( c = [(c4 + nw)[0], (c1 + ne)[1]]
        )
        plinth_line(c, c6 + nw, 3, "front porch");

    // Winter garden
    let ( l1 = 3.7
        , l2 = 3.75
        , w = 2.5
        )
        plinth_line([-w, l1], [-w, l2 + l1], 3, "winter garden");
    
    // Measurements
    let ( nbr = 21
        )
        echo("concrete m3", nbr*pw*pw*(ph + pd));
    let ( area = (c2[1] - c4[1])*(c4[0] - c1[0]) + 
                 (c5[1] - c1[1])*(c5[0] - c1[0])
        )
        echo("area m2", area);
    }
