th = 50;
wd = 150;
sy = 2000;
sx = 2000;
h = 500 + wd;
nbr = 15;

module stick(l) {
    cube([th, th, l], center = true);
}

module plank(l) {
    cube([l, th, wd], center = true);
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