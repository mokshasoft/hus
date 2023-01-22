// constants
brick_side = 0.07;

module brick(s = brick_side) {
    let (s2 = 2*s)
    let (s3 = 4*s)
    color("orange")
    cube([s2, s3, s]);
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
