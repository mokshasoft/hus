// configure the house
corners = 8; // number of corners in main room
mrr = 4; // main room radius
hr = mrr + 4; // house radius
wt = 0.3; // wall thickness

// calculate the coordinates for the corners
function p(i, r) =
   let(angle=i*(360/corners))
   [ r*cos(angle)
   , r*sin(angle)
   ];

// return the point between p1 and p2 in percent from p1
function inbetween(p1, p2, procent) =
   let (x_diff = p2[0] - p1[0])
   let (y_diff = p2[1] - p1[1])
   [ p1[0] + x_diff*procent/100
   , p1[1] + y_diff*procent/100
   ];

// create a wall of thickness wt
module wall(p1, p2) {
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
module rmwall(p1, p2) {
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
module door(p1, p2, pos) {
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
module window(p1, p2, pos, size = 1) {
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

module octagon(r) {
    coords=[for (i = [0:corners-1]) p(i, r)];
    for (i = [0:corners-1])
        wall(coords[i], coords[(i+1) % corners]);
}

module winter_garden() {
    // calculate the corners
    p0 = inbetween(p(corners-1,mrr), p(0, mrr), 50);
    p1 = inbetween(p(corners-1,hr), p(0, hr), 50);
    p2 = p(0, hr);
    p3 = p(1, hr);
    p4 = inbetween(p(1,hr), p(2, hr), 50);
    p5 = inbetween(p(1,mrr), p(2, mrr), 50);
    // walls
    color("gray") wall(p1, p2);
    color("gray") wall(p2, p3);
    color("gray") wall(p3, p4);
    wall(p0, p1);
    wall(p4, p5);
}

// create the basic floor plan of the house
module bottom() {
    // inner octagon
    octagon(mrr);
    // outer octagon
    octagon(hr);
    // winter garden
    winter_garden();
}

// create floor plan example 1
module plan1() {
    // wall to winter garden
    door(p(0, mrr), p(1, mrr), 50)
    window(p(0, mrr), p(1, mrr), 18, 0.8)
    window(p(0, mrr), p(1, mrr), 82, 0.8)
    window(p(1, mrr), p(2, mrr), 23, 0.8)
    window(p(0, mrr), p(7, mrr), 23, 0.8)
    // winter garden outer wall
    door(p(0, hr), p(1, hr), 50)
    // remove wall between main room and hall
    rmwall(p(2, mrr), p(3, mrr))
    rmwall(p(2, mrr), inbetween(p(1, mrr), p(2, mrr), 50))
    // hall wall towards out
    door(p(1, hr), p(2, hr), 75)
    window(p(2, hr), p(3, hr), 25, 1)
    // door to storage room from outside
    door(p(7, hr), p(0, hr), 25)
    // door to bathroom area
    door(p(6, mrr), p(7, mrr), 50)
    // door to south-east bedroom
    door(p(3, mrr), p(4, mrr), 75)
    bottom();
    // create the hall
    door(p(3, mrr), inbetween(p(2, hr), p(3, hr), 50), 70)
    wall(p(3, mrr), inbetween(p(2, hr), p(3, hr), 50));
    door(p(7, mrr), p(7, hr), 25)
    wall(p(7, mrr), p(7, hr));
    // storage room from outside
    let (d = mrr + (hr - mrr)/2)
    wall(p(7, d), inbetween(p(7, d), p(0, d), 50));
    // bathroom area
    door(p(6, mrr), p(6, hr), 25)
    wall(p(6, mrr), p(6, hr));
    let (d = mrr + (hr - mrr)/2)
    door(p(6, d), p(7, d), 50)
    wall(p(6, d), p(7, d));
    // large bedroom
    let (p1 = inbetween(p(4, mrr), p(5, mrr), 50))
    let (p2 = inbetween(p(4, hr), p(5, hr), 50))
    wall(p1, p2);
    // split the other bedrooms
    let (p1 = inbetween(p(3, mrr), p(4, mrr), 50))
    let (p2 = inbetween(p(3, hr), p(4, hr), 50))
    wall(p1, p2);
}

v = 360/corners/2;
rotate(-v) plan1();
