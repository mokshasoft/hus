include <lib/element.scad>

function z(h) =
    [0, 0, h];

function inbetween(p1, p2, procent = 50) =
    let (x_diff = p2[0] - p1[0])
    let (y_diff = p2[1] - p1[1])
    let (z_diff = p2[2] - p1[2])
    [ p1[0] + x_diff*procent/100
    , p1[1] + y_diff*procent/100
    , p1[2] + z_diff*procent/100
    ];

function angle(v1, v2) =
    acos((v1*v2)/(norm(v1)*norm(v2)));

// Supporting structure

h = 2.9;
w = 6;
l = 10;
logd = 0.2;

// Create a line of plinths
module beam_line(coord1, coord2, h, nbr, tag = "cc") {
    assert(nbr >= 2, "more than two plinths");
    let ( cc = (coord2 - coord1)/(nbr - 1)
        )
        echo(tag, norm(cc))
        for (i=[0:nbr - 1])
            let (p = coord1 + i*cc)
            beam(p, p + z(h), logd);
}

c1 = [0, 0, 0];
c2 = [w, 0, 0];
c3 = [w, l, 0];
c4 = [0, l, 0];

color_logs()
union() {
    beam_line(c1, c2, h, 3);
    beam_line(c2, c3, h, 3);
    beam_line(c3, c4, h, 3);
    beam_line(c4, c1, h, 3);
}

color_logs()
union() {
    beam(c1 + z(h), c2 + z(h), logd);
    beam(c2 + z(h), c3 + z(h), logd);
    beam(c3 + z(h), c4 + z(h), logd);
    beam(c4 + z(h), c1 + z(h), logd);
}

module truss(p1, p2, height) {
    let ( ch = h + height
        , c = p1 + (p2 - p1)/3
        )
        echo("angle", angle(c + z(ch) - (p1 + z(h)), p2 - p1))
        echo("angle", angle(c + z(ch) - (p2 + z(h)), p1 - p2))
        union() {
            beam(p1 + z(h), c + z(ch), logd);
            beam(c + z(ch), p2 + z(h), logd);
        }
}

// roof beams
rh = 3;
color_logs()
union() {
    truss(c1, c2, rh);
    truss(c4, c3, rh);
    truss(inbetween(c1, c4), inbetween(c2, c3), rh);
}

// metal roof
let ( ch = h + rh
    , r1 = c1 + (c2 - c1)/3
    , r2 = c4 + (c3 - c4)/3
    )
    color("SaddleBrown")
    union() {
        color_roof() plane(c2 + z(h), c3 + z(h), r1 + z(ch), r2 + z(ch));
        color_roof() plane(c1 + z(h), c4 + z(h), r1 + z(ch), r2 + z(ch));
    }

module trellis_base(w, h, thickness, hollow = 50) {
    let ( pw = 0.1
        , cc = pw + 2*pw*(hollow/100)
        , nbr = w/cc
        )
        echo("nbr", nbr)
        linear_extrude(thickness)
        for (i = [0 : nbr - 1])
            union() {
                translate([i*cc, 0])
                square([pw, h]);
            }
    
}

// create a wall
module wall(p1, p2, h) {
    let ( thickness = 0.02
        , x_diff = p2[0] - p1[0]
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

module trellis(p1, p2, h) {
    let ( thickness = 0.02
        , x_diff = p2[0] - p1[0]
        , y_diff = p2[1] - p1[1]
        , len = sqrt(pow(x_diff, 2) +
                     pow(y_diff, 2))
        )
        translate(p1)
        rotate(atan2(y_diff, x_diff))
        translate([0, thickness/2])
        rotate([90, 0, 0])
        trellis_base(len, h, thickness, 50);
}

color("BlanchedAlmond")
union() {
    trellis(c1, inbetween(c1, c4), h);
    trellis(c2, inbetween(c2, c3), h);
    wall(inbetween(c2, c3), c3, h);
    wall(c3, c4, h);
    wall(c4, inbetween(c1, c4), h);

    // Triangle walls
    plane(c1 + z(h), c1 + z(h), c2 + z(h), c1 + (c2 - c1)/3 + z(rh + h));
    plane(c4 + z(h), c4 + z(h), c3 + z(h), c4 + (c3 - c4)/3 + z(rh + h));
}

// Ground
color_concrete() plane(c1, c2, c3, c4);
