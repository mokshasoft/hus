include <lib/element.scad>
include <lib/measurement.scad>

// configure the rendering
show_floor = true;
show_roof = true;
show_lawn = false;

// Parameters
a1 = atan(3/4);
ll = 9.5;
l2 = 10;

// 3D
room_hl = 2.4;  // room height low
room_hh = 3.5;  // room height high
room_ht = 4.8;  // height in tea room

module w(p1, p2, h, thickness = 0.300) {
    wall(p1, p2, h, thickness)
    children();
}

// Corners of the outer walls of house
p1 = [0, 0];
p2 = p1 + [-ll*cos(a1), ll*sin(a1)];
p4 = [0, 8];
p3 = p4 + 0.5*[-ll*cos(a1), ll*sin(a1)];
p6 = [l2, 0];
p5 = [l2, 8];

// Winter garden
ws = 3;
w1 = p5;
w2 = p5 - [ws, 0];
w3 = w2 + [0, ws];
w4 = w3 + [1.5*ws, 0];
w5 = w4 - [0, 2*ws];
w6 = w5 - [0.5*ws, 0];

// Tea room
ts = 2.5;
t1 = p6;
t2 = t1 - [ts, 0];
t3 = t2 + [0, ts];
t4 = t3 + [ts, 0];

// Points on the top of the outer wall
function walltop(c) =
    concat(p1, room_h);

// Lawn
if (show_lawn) {
    color_lawn()
    translate([0, 0, -0.5])
    cube([4*s, 4*s, 0.04], center = true);
}

module hus() {
    color_outer_wall()
    union() {
        // Outer walls
        w(p1, p2, room_hl);
        w(p2, p3, room_hl);
        w(p3, p4, room_hl);
        w(p4, p5, room_hh);
        w(p5, p6, room_hh);
        w(p6, p1, room_hh);
        // Tea room
        w(t1, t2, room_ht);
        w(t2, t3, room_ht);
        w(t3, t4, room_ht);
        w(t4, t1, room_ht);        
    }
    color_glass()
    union() {
        w(w1, w2, room_hh);
        w(w2, w3, room_hh);
        w(w3, w4, room_hh);
        w(w4, w5, room_hh);
        w(w5, w6, room_hh);
    }
}

hus();
