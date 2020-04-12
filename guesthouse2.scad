include <element.scad>

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
house_h = 4000; // house height
room_h = 2200;  // room height
oh = 600;       // over-hang of the roof
log_d = 400;    // log diameter
angle = 20;     // angle of the left and right walls from center
w = 6000;       // front width of winter garden
ws = 1700;      // winter-garden side length
s = ws + bed_l; // left and right wall lengths
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

// Corners of the bed-room

// Lawn
if (show_lawn) {
    color("LawnGreen")
    translate([-1.5*s, -1.5*s, -500])
    cube([4*s, 4*s, 4]);
}

module hus() {
    // Windows

    color("MediumSpringGreen")
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

    // Bed room
    wall(p7, p7 + bed_l*[cos(90-angle), sin(90-angle)], room_h);
    // Bath room and study
    tmp = p8 + bed_l*[-cos(90-angle), sin(90-angle)];
    wall(p8, tmp, room_h);
    wall(inbetween(p9, p2, 50), inbetween(p8, tmp, 50), room_h);

    // Winter garden
    color("azure",0.25)
    wall(p5, p1, house_h);

    // Pillars
    color("Ivory")
    for (p = [p1, p2, p3, p4, p5])
        translate([p[0], p[1], -500]) cylinder(h = house_h + 500, d = log_d);

    if (show_floor) {
        color("Wheat")
        linear_extrude(300)
        polygon([p1, p2, p3, p4, p5]);
    }

    if (show_roof) {
        color("Lavender")
        rotate([-3, 0, 0])
        scale([1.3, 1.3, 1])
        translate([0, -700, house_h])
        linear_extrude(400)
        polygon([p1, p2, p3, p4, p5]);
    }

}

hus();
