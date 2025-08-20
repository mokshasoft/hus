// ==== Parameters ====
depth = 3;               // Depth into the hill (m)
south_height = 3;        // Height at the front
north_height = 2.5;      // Height at the back
num_windows = 4;         // Number of windows in width
num_window_rows = 2;     // Number of window rows (vertically)

window_size = 1.2;       // Windows are 1.2 x 1.2 m
wall_thickness = 0.2;    // Wall thickness (m)
roof_thickness = 0.1;    // Roof thickness
ws = window_size;
wg = 0.1; // window gap

// ==== Parameters for the hill ====
hill_width = 5;          // Width of the hill (m)
hill_height = 1.5;       // Height of the hill (m)
hill_length = 7;         // Length of the hill (m)
detail_level = 50;       // Detail level (number of segments, higher = more details)

// ==== Derived dimensions ====
width = num_windows * window_size;
roof_slope = (north_height - south_height) / depth;
roof_angle = atan(roof_slope);

// ==== Functions ====
module wall(width, height) {
    color("gray")
    translate([width/2, 0, height/2])
    cube([width, .2, height], center = true);
}

module window(width, height) {
    translate([width/2, 0, height/2])
    cube([width, .3, height], center = true);
}

function spacing(num, size, gap) =
    num * (size + gap) + gap;

module front_window_section() {
    difference() {
        wall(spacing(num_windows, ws, wg),
             spacing(2, ws, wg));
        for (row = [0 : 1]) { // two rows of windows
            for (i = [0 : num_windows - 1]) {
                translate([spacing(i, ws, wg),
                           0,
                           spacing(row, ws, wg)])
                    window(ws, ws);
            }
        }
    }
}

module greenhouse() {
    difference() {
        // Greenhouse volume
        hull() {
            translate([0, 0, 0])
                cube([width, wall_thickness, south_height]);
            translate([0, depth, 0])
                cube([width, wall_thickness, north_height]);
        }

        // Window openings on the south side (multiple rows)
        window_gap = (south_height - 0.4) / num_window_rows;
        translate([0,0,1])
        for (row = [0 : num_window_rows - 1]) {
            for (i = [0 : num_windows - 1]) {
                translate([i * window_size + 0.1, -0.01, 0.4 + row * window_gap])
                    cube([window_size - 0.2, wall_thickness + 0.02, window_size - 0.2]);
            }
        }
    }
}

module greenhouse2() {
    width = spacing(num_windows, ws, wg);
    // windows
    rotate([30, 0, 0]) front_window_section();
    // front wall
    translate([0, 0, -1]) wall(width, 1);
    // floor
    translate([0, 0, -1]) rotate([90, 0, 0]) wall(width, 3);
    // back wall
    translate([0, -3, -1]) wall(width, 3);
    // roof
    translate([0, -1.25, 2.4]) rotate([100, 0, 0]) wall(width, 2);
}

// ==== Hill module with 3D ellipse ====
module hill() {
    color("saddlebrown")
        scale([hill_length, hill_width, hill_height]) // Adjust length, width, and height
            sphere(1, $fn=detail_level);  // Create an ellipsoid with high detail (radius 1)
}

module ground() {
    color("green")
    linear_extrude(.1)
    square(15, center = true);
}

module render() {
    union() {
        difference() {
            union() {
                hill();
                ground();
            }
            translate([-width/2, 5, .3]) hull() { children(); }
        }
        translate([-width/2, 5, .3]) children();
    }
}

render() greenhouse2();

// sun ray at midsummer noon
translate([-width/2, 5, .3]) translate([0, -2.9, 0]) rotate([-(90-54), 0, 0]) cylinder(h = 5, r = 0.1);

translate([-width/2, 5, .3]) translate([0, -2.9, 1]) rotate([-(90-37), 0, 0]) cylinder(h = 5, r = 0.1);
