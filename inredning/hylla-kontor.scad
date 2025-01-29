open_x = 2460;
open_y = 2430;
margin_x = 15;
margin_y = 15;
columns = 5;
th = 18;
wd = 450;
base = 100;
f2b = base + th;
offset_x = margin_x + th/2;
diff_x = (open_x - 2*offset_x)/(columns - 1);
st = [for (x = [0 : columns - 1]) offset_x + x*diff_x];
c1 = [ 250, 250, 250
     , 660 // hurts
     , 300
     ];
c2 = [ 300, 300, 300 // 6st backar
     , 750 // bryggare
     ];
c3 = [350, 350, 350, 350, 350];
c4 = [250, 250, 250, 250, 250, 250, 250];

function sum(v, i = 0, r = 0) = i < len(v) ? sum(v, i + 1, r + v[i]) : r;

module plank(l) {
    echo("plank l =", l);
    cube([l, wd, th], center = true);
}

module standing_plank(l) {
    rotate([0, 90, 0]) plank(l);
}

module section(s, c) {
    // Create shelves in column 1
    let ( x = st[s]
        , w = st[s + 1] - st[s] - th
        , t = [for (ii = [0 : 1]) c[ii]])
    translate([x + w/2 + th/2, 0, 0])
    for(i = [0:len(c)-1])
        let (v = [for (ii = [0 : i]) c[ii]])
        translate([0, 0, th*(len(v) - 1) + sum(v) + f2b + th/2])
        plank(w);
}

// Opening
color("gray", 0.5)
union() {
    translate([-th/2, 0, open_y/2])
        standing_plank(open_y);
    translate([th/2 + open_x, 0, open_y/2])
        standing_plank(open_y);
    translate([open_x/2, 0, -th/2])
        plank(open_x);
    translate([open_x/2, 0, open_y + th/2])
        plank(open_x);
}

// Create columns
let (l = open_y - margin_y - f2b)
translate([0, 0, l/2 + f2b])
for(i = st)
    translate([i, 0, 0])
    standing_plank(l);

// Create shelves
section(0, c1);
section(1, c2);
section(2, c3);
section(3, c4);

// Top shelves
section(0, [open_y - 350]);
section(1, [open_y - 350]);
section(2, [open_y - 350]);
section(3, [open_y - 350]);

// Create base
let (w = open_x - 2*margin_x)
    echo("bottom plank of length", w)
    translate([w/2 + margin_x, 0, base + th/2])
    plank(w);

// Material
let (nbr_shelves = len(c1) + len(c2) + len(c3) + len(c4))
echo( "nbr of shelves ", nbr_shelves
    , "of width", st[1] - st[0] - th
    );