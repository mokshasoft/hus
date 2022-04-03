module beam(l, w = 0.095, t = 0.045) {
    color("lightblue")
    rotate([90, 0, 90])
    cube([l, w, t]);
}

module wall(w, h, t, ccx = 0.6, ccy = 1.22) {
    let ( nbrX = ceil(w/ccx)
        , nbrY = floor(h/ccy)
        , yOffset = h - nbrY*ccy - ccy + 0.045
        , xOffset = nbrX*ccx - w
        )
        for (x = [0:nbrX - 1])
            translate([x*ccx, 0, 0])
            union() {
                beam(h, t);
                for (y = [1:nbrY])
                    let ( oy = x % 2 == 0 ? 0 : yOffset
                        , ox = x == nbrX - 1 ? xOffset : 0
                        )
                    translate([0.045, oy + y*ccy, 0])
                    rotate([0, 0, -90])
                    beam(ccx - 0.045 - ox, t);
            }
    // the last beam
    translate([w, 0, 0])
    beam(h, t);
}

wall(4, 2.6, 0.3);