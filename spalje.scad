// configure
bt = 42;
bh = 1550;
fh = 1550;
fw = 3295;
fbw = 200;
fbt = 20;

module frame(h) {
    // Frame top/bottom
    translate([0, 0, fh/2])
        cube([fw, fbw, fbt], center = true);
    translate([0, 0, -fh/2])
        cube([fw, fbw, fbt], center = true);

    // Frame left/right
    translate([fw/2, 0, 0])
        rotate([0, 90, 0])
        cube([fh, fbw, fbt], center = true);
    translate([-fw/2, 0, 0])
        rotate([0, 90, 0])
        cube([fh, fbw, fbt], center = true);
}

module beam(h) {
    cube([bt, bt, h], center = true);
}

module beams(h, cc, nbr) {
    for (i = [0:nbr-1])
        translate([i*cc, 0, 0])
        beam(h);
}

if (false) {
    frame();
    translate([-fw/2, 0, -bh/2])
        beams(bh, 142, 23);
}

module section(l, r, h1, h2, w) {
    if (l) {
        translate([-w/2 + bt/2, 0, 0])
            cube([bt, 2*bt, h1], center = true);
    }
    if (r) {
        translate([w/2 - bt/2, 0, 0])
            cube([bt, 2*bt, h1], center = true);
    }
    translate([-w/2 + w/6, 0, -(h1 - h2)/2])
        beams(h2, w/6, 5);
    translate([0, 0, h2 - h1/2])
        cube([w, 2*bt, bt], center = true);
}

if (true) {
    frame();
    let (h2 = 900)
    translate([-1.5*fw/4, 0, 0])
    union() {
        translate([0*fw/4, 0, 0])
            section(false, true, fh, h2, fw/4);
        translate([1*fw/4, 0, 0])
            section(true, true, fh, h2, fw/4);
        translate([2*fw/4, 0, 0])
            section(true, true, fh, h2, fw/4);
        translate([3*fw/4, 0, 0])
            section(true, false, fh, h2, fw/4);
    }
}