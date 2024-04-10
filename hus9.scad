use <lib/element.scad>

// constants
gr = 1.61803; // golden ration

// configure the house
wt =   0.6;  // wall thickness
corners = 7; // number of house corners
mrr = 4;     // house radius
fh = 4;     // floor height

// calculate the coordinates for the corners
function p(i, r) = point(i, r, corners);

// create a wall of thickness wt
module w(p1, p2, h) {
    wall(p1, p2, h, wt);
}

module wi(p1, p2, pos, height, sizex, sizey) {
    window(p1, p2, pos, height, sizex, sizey, wt)
    children();
}

module floor() {
    for (i = [1:corners])
        let (p1 = p(i, mrr))
        let (p2 = p(i+1, mrr))
        let (ll = norm(p1 - p2))
        let (wh = fh/gr)
        let (ww = wh/gr)
        echo ("len =", ll)
        wi(p1, p2, 50, 2, ww, wh)
        w(p1, p2, fh);
}

floor();
translate([0, 0, 4.1]) floor();