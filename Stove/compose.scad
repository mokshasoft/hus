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
