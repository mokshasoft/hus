// constants
bs = 0.07; // The length of the shortest side of the brick
mt = 0.005; // The mortar thickness

module brick(s = bs) {
    let (s2 = 2*s)
    let (s3 = 4*s)
    color("orange")
    cube([s2, s3, s]);
}

module layer(i) {
    translate([0, 0, i*(bs + mt)]) children();
}

module full_layer(x, y) {
    for (xx=[0:x-1])
        for (yy=[0:y-1])
            translate([xx*(2*bs + mt), yy*(4*bs + mt), 0]) brick();
}

module compose2() {
    union() {
        children();
        color("gray")
        difference() {
            hull() {
                children();
            }
            children();
        }
    }
}
