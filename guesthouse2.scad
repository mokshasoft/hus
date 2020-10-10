include <lib/element.scad>
include <lib/measurement.scad>

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
bed_w = 3000;

// outer size
house_h = 5000; // house height
room_h = 2200;  // room height
oh = 600;       // over-hang of the roof
log_d = 400;    // log diameter
angle = 30;     // angle of the left and right walls from center
w = 6000;       // front width of winter garden
ws = 1700;      // winter-garden side length
s = ws + bed_l + 2500; // left and right wall lengths including winter garden
wl = s - ws;    // left and right wall lengths
o = 1500;       // offset left and right of left and right walls

module win(p1, p2, pos, height, sizex, sizey, wt = 300) {
    window(p1, p2, pos, height, sizex, sizey, wt)
    children();
}

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

// Corners of the bed-room

// Lawn
if (show_lawn) {
    color_lawn()
    translate([0, 0, -500])
    cube([4*s, 4*s, 4], center = true);
}

module hus() {
    // Windows

    color_outer_wall()
    union() {
        // Outer walls
        wall(p1, p2, house_h);
        wall(p2, p3, house_h);
        wall(p3, p4, house_h);
        wall(p4, p5, house_h);
        wall(p6, p7, house_h);
        wall(p7, p8, house_h);
        wall(p8, p9, house_h);
    }

    // Inner walls
    color_inner_wall()
    union() {
        // Bed room
        wall(p8, p10, room_h);
        wall(inbetween(p8, p10, 100*2000/wl), inbetween(p9, p2, 100*2000/wl), room_h);
        // Bath room and study
        wall(p7, p11, room_h);
        wall(inbetween(p6, p4, 50), inbetween(p7, p11, 50), room_h);
    }

    // Winter garden
    color_glass()
    wall(p5, p1, house_h);

    // Pillars
    color_inner_wall()
    for (p = [p1, p2, p3, p4, p5])
        translate([p[0], p[1], -500]) cylinder(h = house_h + 500, d = log_d);

    if (show_floor) {
        color_floor()
        linear_extrude(300)
        polygon([p1, p2, p3, p4, p5]);
    }

    if (show_roof) {
        color_roof()
        rotate([-3, 0, 0])
        scale([1.3, 1.3, 1])
        translate([0, -700, house_h + 100])
        linear_extrude(400)
        polygon([p1, p2, p3, p4, p5]);
    }

}

hus();

// Areas

house_area = -area([p1, p2, p3, p4, p5])/1000000;
echo("house area = ", house_area, " m2");
living_room_area = -area([p8, p10, p3, p11, p7])/1000000;
echo("living room area = ", living_room_area, " m2");
winter_garden_area = -area([p1, p9, p8, p7, p6, p5])/1000000;
echo("winter garden area = ", winter_garden_area, " m2");
loft_area = -area([p9, p2, p10, p8])/1000000;
echo("loft areas = ", loft_area, " m2");

// Lengths

echo("p1 -> p5  = ", length(p1, p5)/1000);
echo("p1 -> p3  = ", length(p1, p3)/1000);
echo("p2 -> p1  = ", length(p2, p1)/1000);
echo("p2 -> p3  = ", length(p2, p3)/1000);
echo("p2 -> p10 = ", length(p2, p10)/1000);
echo("p1 -> p9  = ", length(p1, p9)/1000);
echo("p8 -> p3  = ", length(p8, p3)/1000);
echo("p8 -> p1  = ", length(p8, p1)/1000);

// Material calculations
echo("wood floor area = ", house_area - winter_garden_area + 2*loft_area, " m2");
outer_wall_length =
    length(p1, p2) +
    length(p2, p3) +
    length(p3, p4) +
    length(p4, p5) +
    length(p6, p7) +
    length(p7, p8) +
    length(p8, p9);
echo("outer wall area = ", outer_wall_length*house_h/1000000);
inner_wall_area =
    (length(p8, p9) + length(p7, p11) + length(p11, p4))*house_h/2/1000000 + // ground level
    (length(p8, p10) + length(p10, p2) + length(p7, p11))*house_h/2/1000000; // level 1
echo("inner wall area = ", inner_wall_area, " m2");
echo("wood ceiling area = ", house_area);
