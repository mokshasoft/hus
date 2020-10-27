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
a2 = 10;
l2 = 11.3;
l3 = 13.5;
l4 = 4.7;
wgr = 4; // winter garden radius
wgv = 5; // winter garden vertices

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
pc = (p1 + p4)/2;
p6 = pc + [l3*cos(a2), l3*sin(a2)];
p5 = pc + [l2*cos(a2), l2*sin(a2)] + [-l4*cos(a2 - 90), -l4*sin(a2 - 90)];
p7 = pc + [l2*cos(a2), l2*sin(a2)] + [l4*cos(a2 - 90), l4*sin(a2 - 90)];
sa = angle(p3, p4, p5);

// Lawn
if (show_lawn) {
    color_lawn()
    translate([0, 0, -0.5])
    cube([4*s, 4*s, 0.04], center = true);
}

function wg_vertice(i, nbr, r) =
  p4 + [-r*cos(a1 + i*sa/(nbr + 1)), r*sin(a1 + i*sa/(nbr + 1))];

module hus() {
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
        // Winter garden
        for (i=[0:wgv])
          let ( x1 = wg_vertice(i, wgv, wgr)
              , x2 = wg_vertice(i + 1, wgv, wgr)
              )
            w(x1, x2, room_h);
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
th_floor = 0.3;
th_roof = 0.5;

wall_length = vlength([p1, p2, p3, p4, p5, p6, p7, p1]);
wall_area = wall_length * room_h;
wall_volume = wall_area * th_walls;
echo("wall length = ", wall_length, " m");
echo("wall area = ", wall_area, " m2");
echo("wall volume = ", wall_volume, " m3");

roof_volume = house_area*th_roof;
floor_volume = house_area*th_floor;
echo("roof volume = ", roof_volume);
echo("floor volume = ", floor_volume);

total_volume = wall_volume + roof_volume + floor_volume;
echo("total volume = ", total_volume);

// Angles
echo("south angle = ", angle(p3, p4, p5));
