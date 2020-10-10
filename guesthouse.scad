include <lib/element.scad>

// configure the rendering
show_floor = true;
show_roof = true;
show_lawn = true;

// configure the house

// bathroom
bath_l = 2720;
bath_w = 1660;

// bedroom
bed_l = 3320;
bed_w = 2720;

// outer size
house_l = 9000; // house length
house_w = house_l/gr; // house width
house_h = 4000; // house height
oh = 600; // over-hang of the roof
log_d = 400; // log diameter

// winter garden
ww = house_w - bed_l; // winter-garden width
wl = house_l - bath_l; // winter-garden length

function w_area() =
    ww*wl/999999;
function area() =
    house_l*house_w/1000000 - w_area();

echo("long side = ", house_l/1000);
echo("short side = ", house_w/1000);
echo("area = ", area());
echo("area winter-garden= ", w_area());

module win(p1, p2, pos, height, sizex, sizey, wt = 300) {
    window(p1, p2, pos, height, sizex, sizey, wt)
    children();
}

// Points
c1 = [0, 0];
c2 = [0, house_l];
c3 = [house_w, house_l];
c4 = [house_w, 0];
w1 = c4 + [0, wl];
w2 = [house_w - ww, wl];
w3 = [house_w - ww, 0];

// Lawn
if (show_lawn) {
    color_lawn()
    translate([0, 0, -500])
    cube([4*house_w, 4*house_l, 4], center = true);
}

module hus() {
    // Floor
    if (show_floor) {
        color_floor()
        cube([house_w, house_l, 400]);
    }

    // Roof
    if (show_roof) {
        color_roof()
        translate([-oh, -oh, house_h])
        rotate([-2, -2, 0])
        cube([house_w + 2*oh, house_l + 2*oh, 400]);
    }

    // Windows

    // Outer walls
    color_outer_wall()
    union() {
        wall(c1, c2, house_h);
        wall(c2, c3, house_h);
        wall(c3, w1, house_h);
        wall(w1, w2, house_h);
        wall(w2, w3, house_h);
        wall(w3, c1, house_h + 100);
        // Loft
        translate([0, 0, 2500]) wall(w1, c4, 1700);
        translate([0, 0, 2500]) wall(c4, w3, 1700);
    }

    // Pillars
    color_logs()
    union() {
        translate([0, 0, -500]) cylinder(h = house_h + 500, d = log_d);
        translate([0, house_l, -500]) cylinder(h = house_h + 500, d = log_d);
        translate([house_w, house_l, -500]) cylinder(h = house_h + 500, d = log_d);
        translate([house_w, 0, -500]) cylinder(h = house_h + 500 + 200, d = log_d);
    }

    // Inner walls
    color_inner_wall()
    union() {
        translate([0, bed_w, 0]) wall(c1, w3, 2500); // bed room
        translate([-bath_w, 0, 0]) wall(c3, w1, 2500); // bath room
    }

    // Wintergarden roof
    color_roof()
    translate([bed_l, 0, 2500])
    cube([ww, wl, 200]);
}

hus();
