include <element.scad>
include <floorplan.scad>

// configure the house

// bathroom
bath_l = 2720;
bath_w = 1660;

// bedroom
bed_l = 3320;
bed_w = 3000;

// outer size
house_h = 4000; // house height
room_h = 2200;  // room height
oh = 600;       // over-hang of the roof
log_d = 400;    // log diameter
angle = 20;     // angle of the left and right walls from center
w = 6000;       // front width of winter garden
ws = 1700;      // winter-garden side length
s = ws + bed_l + 2000; // left and right wall lengths including winter garden
wl = s - ws;    // left and right wall lengths
o = 1500;       // offset left and right of left and right walls

// Corners of the outer walls of house
p1 = [-o + -w/2, 0];
p2 = [-o + -w/2, 0] - [s*sin(angle), -s*cos(angle)];
p3 = [0, p2[1]] - [0, p2[0]*tan(angle)];
p4 = [o + w/2, 0] + [s*sin(angle), s*cos(angle)];
p5 = [o + w/2, 0];
p6 = inbetween(p5, p4, 100*ws/s);
p7 = p6 + bed_w*[-cos(angle), sin(angle)];
p9 = inbetween(p1, p2, 100*ws/s);
p8 = p9 + bed_w*[cos(angle), sin(angle)];
p10 = p8 + wl*[-cos(90 - angle), sin(90 - angle)];
p11 = p7 + wl*[cos(90-angle), sin(90-angle)];

module hus() {
    union() {
        // Outer walls
        wall(p1, p2);
        wall(p2, p3);
        wall(p3, p4);
        wall(p4, p5);
        wall(p6, p7);
        wall(p7, p8);
        wall(p8, p9);
    }

    // Inner walls
    union() {
        // Bed room
        wall(p8, p10);
        wall(inbetween(p8, p10, 100*1500/wl), inbetween(p9, p2, 100*1500/wl));
        // Bath room and study
        wall(p7, p11);
        wall(inbetween(p6, p4, 50), inbetween(p7, p11, 50));
    }

    // Winter garden
    wall(p5, p1);
}

// Draw the scale
module drawScale() {
    translate([-5000, -2000])
    union() {
        wall([0, 0], [10000, 0]);
        wall([0, 0], [0, 500], 50);
        wall([1000, 0], [1000, 500], 50);
        wall([5000, 0], [5000, 500], 50);
        wall([10000, 0], [10000, 500], 50);
    }
}

hus();
drawScale();
