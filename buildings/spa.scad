s_x = 4000;
s_y = 5000;
height = 3000;
roof_th = 400;

module outer_shape(x, y, th) {
    difference() {
        scale([1, y/x]) circle(d=x);
        translate([0, 1.2*y/2]) circle(d = y + th);
    }
}

module add_roof(x, y, th, show = true) {
    module roof(h, th) {
        translate([0, 0, h])
        rotate([11, 0, 0])
        linear_extrude(th)
        scale(1.3) scale([1, y/x]) circle(d=x);
    }

    if (show) {
        union() {    
            difference() {
                children();
                roof(3000, 4000);
            }
            roof(3000, th);
        }
    } else {
        children();
    }
}

add_roof(s_x, s_y, roof_th)
difference() {
    linear_extrude(height = height + 2000)
    outer_shape(s_x, s_y, 0);
    scale(0.9)
    linear_extrude(height = 3 * (height + 2000), center = true)
    outer_shape(s_x, s_y, 300);
}

translate([900, 2200, 0])
linear_extrude(3500) circle(150);
translate([-900, 2200, 0])
linear_extrude(3500) circle(150);
