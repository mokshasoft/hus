include <lib/element.scad>
include <lib/measurement.scad>

// configure the rendering
show_floor = true;
show_roof = true;
show_lawn = false;

// Parameters
s = 20;
a1 = atan(3/4);
ll = 9.5;
ll1 = ll - 2.5;
wl = 7;
a2 = 10;
l2 = 9.3;
l3 = 11.5;
l4 = 4.7;
wgr = 4.5; // winter garden radius
wgv = 5; // winter garden vertices

// 3D
ra = 30; // roof angle
room_h = 2.6;  // room height

module w(p1, p2, h, thickness = 0.300) {
    wall(p1, p2, h, thickness)
    children();
}

// Corners of the outer walls of house
p1 = [0, 0];
p2 = p1 + [-ll*cos(a1), ll*sin(a1)];
p3 = p2 + [-wl*cos(a1 + 90), wl*sin(a1 + 90)];
p4 = p3 + [ll1*cos(a1), -ll1*sin(a1)];
pc = (p1 + p4)/2;
p6 = pc + [l3*cos(a2), l3*sin(a2)];
p5 = pc + [l2*cos(a2), l2*sin(a2)] + [-l4*cos(a2 - 90), -l4*sin(a2 - 90)];
p7 = pc + [l2*cos(a2), l2*sin(a2)] + [l4*cos(a2 - 90), l4*sin(a2 - 90)];
sa = angle(p3, p4, p5);

// Roof points
r1 = concat(inbetween(p2, p3), 10);
r2 = concat(inbetween(p1, p4), 10);

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
    // Roof
    union() {
        cylinder(h = 5, r = 0.4);
    }
}

hus();

// Areas
house_area = -area([p1, p2, p3, p4, p5, p6, p7, p1]);
echo("house area = ", house_area, " m2");

winter_garden_area = -area(concat([p4], [for (i=[0:wgv]) wg_vertice(i, wgv, wgr)]));
echo("winter garden area = ", winter_garden_area);

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