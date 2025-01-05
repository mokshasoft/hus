use <lib/element.scad>

// constants
gr = 1.61803; // golden ration

// configure the house
floors = 2;
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

module floor(f_height, w_width, w_height) {
    for (i = [1:corners])
        let (p1 = p(i, mrr))
        let (p2 = p(i+1, mrr))
        wi(p1, p2, 50, f_height/2, w_width, w_height)
        w(p1, p2, f_height);
}

// calculate constants
p1 = p(0, mrr);
p2 = p(1, mrr);
w1 = norm(p1 - p2);
h1 = fh;
d1 = sqrt(w1^2 + h1^2);
ww = sqrt(d1^2 - h1^2)/gr;
wh = sqrt(d1^2 - w1^2)/gr;
ratio = max(ww, wh)/min(ww, wh);
echo ("ratio =", ratio);
echo ("ratio in % to GR = ", 100*(ratio - gr)/gr);

// draw the house
for (i = [0:floors-1])
    translate([0, 0, i*(fh + 0.1)])
    floor(fh, ww, wh);
translate([0, 0, 2*(fh + 0.1)])
floor(fh/gr, ww/gr, wh/gr);