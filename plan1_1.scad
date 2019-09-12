include <hus1-plan.scad>

// Create floor plan example 1 of house 1
module plan1() {
    // windows
    window(p(2, hr), p(3, hr), 75)
    window(p(3, hr), p(4, hr), 25)
    window(p(3, hr), p(4, hr), 80)
    window(p(4, hr), p(5, hr), 25)
    window(p(5, hr), p(6, hr), 25)
    window(p(5, hr), p(6, hr), 50)
    window(p(5, hr), p(6, hr), 75)
    window(p(6, hr), p(7, hr), 35)
    window(p(6, hr), p(7, hr), 65)
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
rotate(-v)
linear_extrude(height = 0.5)
plan1();
