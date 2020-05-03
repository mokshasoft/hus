// create a wall of thickness wt
module wall(p1, p2, wt = 300) {
    x_diff = p2[0] - p1[0];
    y_diff = p2[1] - p1[1];
    len = sqrt(pow(x_diff, 2) +
               pow(y_diff, 2));
    // add wall
    translate(p1)
    rotate(atan2(y_diff, x_diff))
    translate([0, -wt/2])
    square([len, wt]);
}

// remove a wall of thickness wt
module rmwall(p1, p2, wt = 300) {
    x_diff = p2[0] - p1[0];
    y_diff = p2[1] - p1[1];
    len = sqrt(pow(x_diff, 2) +
               pow(y_diff, 2));
    // remove wall
    difference() {
        children();
        translate(p1)
        rotate(atan2(y_diff, x_diff))
        translate([0, -wt*1.1/2])
        square([len, wt*1.1]);
    }
}

// add a door between p1 and p2
// The door parameter is the percent of the distance between p1
// and p2 where the center of the door is placed.
module door(p1, p2, pos, wt = 300) {
    w = 0.8; // door width
    d = abs(pos);
    assert(0 < d && d < 100);
    x_diff = p2[0] - p1[0];
    y_diff = p2[1] - p1[1];
    len = sqrt(pow(x_diff, 2) +
               pow(y_diff, 2));
    a = atan2(y_diff, x_diff);
    difference() {
        children();
        // remove wall for door
        translate(p1 + d*[x_diff, y_diff]/100)
        rotate(atan2(y_diff, x_diff))
        square([w, wt*1.1], center = true);
    }
    // add door
    door_angle = pos > 0 ? 30 : -30;
    translate(p1 - w/2*[cos(a), sin(a)] +
              d*[x_diff, y_diff]/100)
    rotate(atan2(y_diff, x_diff) - door_angle)
    translate([0, -wt/4])
    square([w, wt*0.5]);
}

// create a window
module window(p1, p2, pos, size = 1, wt = 300) {
    assert(0 < pos && pos < 100);
    x_diff = p2[0] - p1[0];
    y_diff = p2[1] - p1[1];
    len = sqrt(pow(x_diff, 2) +
               pow(y_diff, 2));
    // create hole for window
    difference() {
        children();
        translate(p1 + pos*[x_diff, y_diff]/100)
        rotate(atan2(y_diff, x_diff))
        square([size, wt*1.1], center = true);
    }
    // add the window glass
    translate(p1 + pos*[x_diff, y_diff]/100)
    rotate(atan2(y_diff, x_diff))
    color("gray") square([size, wt/4], center = true);
}
