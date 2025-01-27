open_x = 2460;
open_y = 2430;
th = 18;
wd = 450;
st = [0, 600, 1200, 1800, 2400];
c1 = [0, 300, 600, 1200];
c2 = [for (z = [0 : 7]) 100 + z*300];
c3 = [for (z = [0 : 7]) z*300];
c4 = c2;

module plank(l) {
    echo("plank l =", l);
    cube([l, wd, th], center = true);
}

module standing_plank(l) {
    rotate([0, 90, 0]) plank(l);
}

module section(s, c) {
    // Create shelves in column 1
    let ( x = st[s]
        , w = st[s + 1] - st[s] )
    translate([x + w/2, 0, 0])
    for(i = c)
        translate([0, 0, i])
        plank(w);
}
// Opening
color("gray", 0.5)
union() {
    translate([-th/2, 0, open_y/2])
        standing_plank(open_y);
    translate([th/2 + open_x, 0, open_y/2])
        standing_plank(open_y);
    translate([open_x/2, 0, -th/2])
        plank(open_x);
    translate([open_x/2, 0, open_y + th/2])
        plank(open_x);
}

// Create columns
translate([0, 0, open_y/2])
for(i = st)
    translate([i, 0, 0])
    standing_plank(open_y);

// Create shelves
section(0, c1);
section(1, c2);
section(2, c3);
section(3, c4);