// configure
bt = 43;
bt2 = 83;
bh = 1550;
fh = 1565;
fw = 3285;
fbw = 200;
fbt = 17;

// center => 1854.61
//l = 12;
//r = 10;
//dist = 98.47;

// center => 1713.14
l = 11;
r = 11;
dist = 98.47;

// center => 1777,91
//l = 12;
//r = 11;
//dist = 92.57;

cc = dist + bt;

// Trästolpar
module stick() {
    cube([bt, bt, 200], center = true);
}

module support() {
    cube([bt2, bt2, 200], center = true);
}

// Botten
cube([fbw, fw, fbt]);

// Kanter
if (true) {
    translate([0, 0, 50])
    union() {
        cube([fbw, fbt, 200]);
        translate([0, fw - fbt, 0]) cube([fbw, fbt, 200]);
    }
}

// Koordinater
ls = [for (i = [0:l - 1])
      fbt + dist + bt/2 +  i*(dist + bt)];
last = ls[l - 1];
center = last + dist + bt/2 + bt2/2;
rs = [for (i = [0:r-1])
      center + bt2/2 + dist + bt/2 + i*(dist + bt)];

// Skriv ut koordinater
echo("vänster/höger", l, r - 1);
echo("vänster", ls);
echo(last);
echo("center", center);
echo("höger", rs);
echo("5x7", 3*cc + bt);
echo("9x5", 6*cc + bt);

// Rendera
for (i = ls)
    translate([fbw/2, i, 150])
    stick();

translate([fbw/2, center, 150])
support();

for (i = rs)
    translate([fbw/2, i, 150])
    stick();
