include <hus1-plan.scad>

// Create floor plan example 2 of house 1
module plan2() {
    // coordinates for hall and outer storage room
    sr1 = inbetween(p(1, hr), p(2, hr), 50);
    sr2 = inbetween(p(1, hr), p(2, hr), 75);
    sr3 = inbetween(p(2, mrr), sr2, 60);
    h1 = inbetween(p(1, mrr), p(2, mrr), 50);
    sr4 = inbetween(h1, sr1, 60);
    h2 = sr4;
    h3 = sr3;
    h4 = p(2, mrr);
    // coordinates for work-shop room
    ws1 = h4;
    ws2 = sr2;
    ws3 = inbetween(p(2, hr), p(3, hr), 50);
    ws4 = inbetween(p(2, mrr), p(3, mrr), 50);
    // coordinates for the first bedroom
    b11 = ws4;
    b12 = ws3;
    b13 = inbetween(p(3, hr), p(4, hr), 50);
    b14 = inbetween(p(3, mrr), p(4, mrr), 50);
    // coordinates for the second bedroom
    b21 = b14;
    b22 = b13;
    b23 = inbetween(p(4, hr), p(5, hr), 50);
    b24 = inbetween(p(4, mrr), p(5, mrr), 50);
    // coordinates for the walk in closet
    wi1 = p(5, mrr);
    wi2 = inbetween(p(4, hr), p(5, hr), 75);
    // coordinates for the bathrooms
    bd = mrr + (hr - mrr)/2;
    b1 = inbetween(p(6, hr), p(7, hr), 60);
    b2 = inbetween(p(6, bd), p(7, bd), 63);

    // remove wall between main room and hall
    rmwall(h1, h4)

    // doors
    // hall and outer storage
    door(h1, h2, 30)
    door(sr1, sr2, 50)
    // work-shop room
    door(h3, h4, 70)
    // first bedroom
    door(p(3, mrr), p(4, mrr), 25)
    // sedond bedroom
    door(p(3, mrr), p(4, mrr), 75)
    // walk in closet
    door(wi1, wi2, 80)
    // large bedroom
    door(p(6, mrr), p(6, hr), 25)
    // bathroom area
    door(p(6, mrr), p(7, mrr), 50)
    // shower room
    door(p(6, bd), p(7, bd), 25)
    // toilet
    door(p(6, bd), p(7, bd), 80)
    // guest room
    door(p(7, mrr), p(7, hr), 25)
    // winter garden
    door(p(0, hr), p(1, hr), 50)

    // windows
    // work-shop
    window(p(2, hr), p(3, hr), 24)
    // the first bedroom
    window(p(2, hr), p(3, hr), 75)
    window(p(3, hr), p(4, hr), 25)
    // sedond bedroom
    window(p(3, hr), p(4, hr), 80)
    window(p(4, hr), p(5, hr), 25)
    // large bedroom
    window(p(5, hr), p(6, hr), 25)
    window(p(5, hr), p(6, hr), 50)
    window(p(5, hr), p(6, hr), 75)
    // shower room
    window(p(6, hr), p(7, hr), 30)
    // toilet
    window(p(6, hr), p(7, hr), 80)
    // guestroom
    window(p(7, hr), p(0, hr), 25)
    // winter garden
    window(p(0, mrr), p(1, mrr), 50, 0.8)
    window(p(0, mrr), p(1, mrr), 18, 0.8)
    window(p(0, mrr), p(1, mrr), 82, 0.8)
    window(p(1, mrr), p(2, mrr), 23, 0.8)
    window(p(0, mrr), p(7, mrr), 23, 0.8)

    // create rooms counter clock-wise from winter garden
    union() {
        // house structure
        bottom();
        // hall and outer storage
        wall(h4, sr2);
        wall(h2, h3);
        // work-shop
        wall(ws3, ws4);
        // first and second bedroom
        wall(b13, b14);
        wall(b23, b24);
        // walk in closet
        wall(wi1, wi2);
        // large bedroom
        wall(p(6, mrr), p(6, hr));
        // guestroom
        wall(p(7, mrr), p(7, hr));
        // bathrooms
        wall(p(6, bd), p(7, bd));
        wall(b1, b2);
    }
}

v = 360/corners/2;
rotate(-v)
linear_extrude(height = 0.5)
plan2();
