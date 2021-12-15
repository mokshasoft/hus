include <lib/element.scad>

// dimensions
h = 0.4;
w = 3;
l = 5;

// Corners
c1 = [0, 0, 0];
c2 = [w, 0, 0];
c3 = [w, l, 0];
c4 = [0, l, 0];

// module wall
module wall(p1, p2, h, thickness = 0.2) {
    let ( x_diff = p2[0] - p1[0]
        , y_diff = p2[1] - p1[1]
        , len = sqrt(pow(x_diff, 2) +
                     pow(y_diff, 2))
        )
        translate(p1)
        rotate(atan2(y_diff, x_diff))
        translate([0, thickness/2])
        rotate([90, 0, 0])
        linear_extrude(thickness)
        square([len, h]);
}

// foundation
color_concrete()
union() {
    wall(c1, c2, h);
    wall(c2, c3, h);
    wall(c3, c4, h);
    wall(c4, c1, h);
}

// module beam
module beam2(length, width = 0.095, thickness = 0.045) {
    cube([length, width, thickness]);
}

// module frame
module frame(w1, w2, h1, h2) {
    module oneside() {
    let ( x = (w1 - w2)/2
        , x1 = (w1 - w2)/2
        , y1 = h1
        , x2 = w1/2
        , y2 = h2
        , l1 = norm([x1, y1])
        , l2 = norm([x2 - x1, y2 - y1])
        , v1 = atan(h1/x1)
        , v2 = atan((h2 - h1)/(x2 - x1))
        )
        translate([-x2, 0, 0])
        union() {
            rotate([90, -v1, 0])
            beam2(l1);
            translate([x1, 0, y1])
            rotate([90, -v2, 0])
            beam2(l2);
        }
    }
    union() {
        mirror([1, 0, 0])
        oneside();
        oneside();
    }
}

// frames
fhh = 3.5; // frame height high
fhl = 3;   // frame height low
cc = 0.6;
nbr_frames = floor(l/cc);
echo("nbr frames", nbr_frames);
for (i = [0 : nbr_frames])
    translate([w/2, i*cc, h])
    frame(w, w - 1, fhl, fhh);