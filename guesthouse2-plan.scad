include <element.scad>
include <floorplan.scad>
include <guesthouse2.scad>

// Hide the lawn in the floorplan
show_lawn = false;

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
