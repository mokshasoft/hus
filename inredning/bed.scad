th = 50;
wd = 150;
sy = 2000;
sx = 2000;
h = 500 + wd;
nbr = 20;
fh = 150;

module stick(l) {
    cube([th, th, l], center = true);
}

module plank(l) {
    cube([l, th, wd], center = true);
}

module foot(l) {
    cube([2*th, 2*th, l], center = true);
}

//stick(500);
// Head
translate([0, th/2, 0]) plank(sx - 2*th);
// Feet
translate([0, sy - th/2, 0]) plank(sx - 2*th);
// Left
translate([sx/2 - th/2, sy/2, 0]) rotate([0,0,90]) plank(sy);
// Right
translate([-sx/2 + th/2, sy/2, 0]) rotate([0,0,90]) plank(sy);

// Back-rest
for (i = [0:nbr - 1])
    translate( [i*(sx - th)/(nbr - 1) - sx/2 + th/2
             , -th/2
             , (h - wd)/2])
    stick(h);
// Back-rest top
translate([0, -th/2, h - th]) rotate([0, 90, 0]) stick(sx);

// Bed feet left
fl = fh + wd;
yoff = (wd - fl)/2;
translate([sx/2 - th, th, yoff]) foot(fl);
translate([sx/2 - th, sy - 2*th, yoff]) foot(fl);

// Bed feet right
translate([-sx/2 + th, th, yoff]) foot(fl);
translate([-sx/2 + th, sy - 2*th, yoff]) foot(fl);