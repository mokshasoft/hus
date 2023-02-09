// constants
ob = [0.056, 0.108, 0.228]; // Size of ordinary brick
fb = [0.065, 0.125, 0.228]; // Size of firebrick
mt = 0.005; // The mortar thickness

module brick() {
    color("orange")
    cube([ob[1], ob[2], ob[0]]);
}

module layer(i) {
    translate([0, 0, i*(ob[0] + mt)]) children();
}

module full_layer(x, y) {
    for (xx=[0:x-1])
        for (yy=[0:y-1])
            translate([xx*(2*ob[0] + mt), yy*(4*ob[0] + mt), 0]) brick();
}

module line(nbr) {
    for (i=[0:nbr-1])
        translate([0, i*(ob[2] + mt), 0]) children();
}

module ash_layer_odd() {
    line(2) brick();
    translate([ob[1] + ob[2] + 2*mt, 0, 0]) line(2) brick();
    translate([ob[1] + mt, ob[1], 0]) rotate([0, 0, -90]) brick();
    translate([ob[1] + mt, 2*ob[2] + mt, 0]) rotate([0, 0, -90]) brick();
}

module ash_layer_even() {
    translate([2*ob[2] + mt, 0, 0]) rotate([0, 0, 90]) ash_layer_odd();
}

module join() {
    children(0);
    translate([0, ob[2] + mt, 0]) children(1);
}