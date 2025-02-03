s_x = 4000;
s_y = 5000;

module outer_shape(x, y, th) {
    difference() {
        scale([1, y/x]) circle(d=x);
        translate([0, 1.2*y/2]) circle(d = y + th);
    }
}

union() {
    difference() {
        difference() {
            linear_extrude(height = 4000)
            outer_shape(s_x, s_y, 0);
            scale(0.9)
            linear_extrude(height = 4000, center = true)
            outer_shape(s_x, s_y, 300);
        }

        translate([0, 0, 3000])
        rotate([11, 0, 0])
        linear_extrude(2000)
        scale(1.2) scale([1, s_y/s_x]) circle(d=s_x);
    }

    translate([0, 0, 3000])
    rotate([11, 0, 0])
    linear_extrude(400)
    scale(1.2) scale([1, s_y/s_x]) circle(d=s_x);
}

translate([900, 2200, 0])
linear_extrude(3500) circle(150);
translate([-900, 2200, 0])
linear_extrude(3500) circle(150);
