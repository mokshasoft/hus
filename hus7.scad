include <lib/element.scad>
include <lib/measurement.scad>

// configure the rendering
show_floor = true;
show_roof = true;
show_lawn = true;

// Parameters
s = 20;
a1 = atan(3/4);
ll = 9.5;
wl = 5;
a2 = 20;
l2 = 10;
l3 = 12;
l4 = 10;

room_h = 2.2;  // room height
oh = 0.6;       // over-hang of the roof
log_d = 0.4;    // log diameter

module win(p1, p2, pos, height, sizex, sizey, wt = 0.3) {
    window(p1, p2, pos, height, sizex, sizey, wt)
    children();
}

module w(p1, p2, h, thickness = 0.300) {
    wall(p1, p2, h, thickness)
    children();
}

// Corners of the outer walls of house
p1 = [0, 0];
p2 = p1 + [-ll*cos(a1), ll*sin(a1)];
p3 = p2 + [-wl*cos(a1 + 90), wl*sin(a1 + 90)];
p4 = [0, wl/cos(a1)];
p5 = p4 + [l2*cos(a1), l2*sin(a1)];
p6 = [12, 9.5];
p7 = [12.5, 4];

// Corners of the bed-room

// Lawn
if (show_lawn) {
    color_lawn()
    translate([0, 0, -0.5])
    cube([4*s, 4*s, 0.04], center = true);
}

module hus() {
    // Windows

    color_outer_wall()
    union() {
        // Outer walls
        w(p1, p2, room_h);
        w(p2, p3, room_h);
        w(p3, p4, room_h);
        w(p4, p5, room_h);
        w(p5, p6, room_h);
        w(p6, p7, room_h);
        w(p7, p1, room_h);
    }

    if (show_floor) {
        //color_floor()
        //linear_extrude(300)
        //polygon([p1, p2, p3, p4, p5]);
    }

    if (show_roof) {
    }

}

hus();

// Areas
house_area = -area([p1, p2, p3, p4, p5, p6, p7, p1]);
echo("house area = ", house_area, " m2");

// Lengths
l57 = length(p5, p7);
echo("longest roof length = ", l57);

// Material calculations
th_walls = 0.4;
th_floors = 0.3;
th_roof = 0.5;

wall_length = vlength([p1, p2, p3, p4, p5, p6, p7, p1]);
wall_area = wall_length * room_h;
wall_volume = wall_area * th_walls;
echo("wall length = ", wall_length, " m");
echo("wall area = ", wall_area, " m2");
echo("wall volume = ", wall_volume, " m3");
