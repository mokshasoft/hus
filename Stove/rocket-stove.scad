module pipe(l, d_inner, d_outer) {
    difference() {
        cylinder(h = l, r = d_outer/2, center = true);
        cylinder(h = l*1.01, r = d_inner/2, center = true);
    }
}

// fire pipe
translate([0, 0, 0]) pipe(1000, 110, 114);
// water heater pipe
translate([300, 0, 0])
    union() {
        pipe(1000, 165, 169);
        pipe(800, 220, 224);
    }
// chimney pipe
translate([600, 0, 0]) pipe(1000, 165, 169);
