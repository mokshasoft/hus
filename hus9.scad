use <lib/element.scad>

// constants
gr = 1.61803; // golden ration

// configure the house
wt =   0.6;  // wall thickness
corners = 11; // number of house corners
mrr = 4;     // house radius
fh = 3.65;     // floor height

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
        let (w1 = norm(p1 - p2))
        let (h1 = fh)
        let (d1 = sqrt(w1^2 + h1^2))
        let (ww = sqrt(d1^2 - h1^2)/gr)
        let (wh = sqrt(d1^2 - w1^2)/gr)
        let (ratio = max(ww, wh)/min(ww, wh))
        echo ("ratio =", ratio)
        echo ("ratio in % to GR = ", 100*(ratio - gr)/gr)
        wi(p1, p2, 50, 2, ww, wh)
        w(p1, p2, fh);
}

floor();
translate([0, 0, fh + 0.1]) floor();