open_x = 2460;
open_y = 2430;
st = [0, 300, 600, 1200, 1800, 2400, 3000];
c1 = [0, 300, 600, 1200];
c2 = [200, 400, 1200, 1800];

module plank(l, wd = 140, th = 18) {
    echo("plank l =", l);
    cube([l, wd, th], center = true);
}

module standing_plank(l, wd = 140, th = 18) {
    rotate([0, 90, 0]) plank(l);
}

// Create columns
translate([0, 0, open_y/2])
for(i = st)
    translate([i, 0, 0])
    standing_plank(open_y);

module section(s, c) {
    // Create shelves in column 1
    let ( x = st[s]
        , w = st[s + 1] - st[s] )
    translate([x + w/2, 0, 0])
    for(i = c)
        translate([0, 0, i])
        plank(w);
}

section(0, c1);
section(1, c2);