// ==== Parameters ====
depth = 3;               // Depth into the hill (m)
south_height = 3;        // Height at the front
north_height = 2.5;      // Height at the back
num_windows = 4;         // Number of windows in width
num_window_rows = 1;     // Number of window rows (vertically)

window_size = 1.2;       // Windows are 1.2 x 1.2 m
wall_thickness = 0.2;    // Wall thickness (m)
roof_thickness = 0.1;    // Roof thickness

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

module gr() {
    translate([-width/2, -5, -1]) greenhouse();
}

union() {
    difference() {
        hill();
        gr();
    }
    gr();
    ground();
}
