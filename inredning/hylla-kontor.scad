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
c1 = [ 690 // hurts
     , 200, 200
     , 250, 250, 250
     ];
c2 = [ 300, 300, 300 // 6st backar
     , 790 // bryggare
     , 200
     ];
c3 = [ 220, 220
     , 350, 350, 350, 350];
c4 = [250, 300, 300, 250, 250, 250, 250];

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

function accumulate(arr, i=0, total=th/2) =
    i < len(arr)
    ? let (acc = total + arr[i])
        concat([acc], accumulate(arr, i+1, acc + th))
    : [];

function merge_sorted(arr1, arr2, i=0, j=0, result=[]) =
    (i < len(arr1) && (j >= len(arr2) || arr1[i] < arr2[j]))
    ? merge_sorted(arr1, arr2, i+1, j, concat(result, [arr1[i]]))
    : (j < len(arr2))
    ? merge_sorted(arr1, arr2, i, j+1, concat(result, [arr2[j]]))
    : result;

module print_text( txt, x=0, y=0
                 , size=50, height=1
                 , font="Liberation Sans") {
    translate([x, -wd/2, y])
    rotate([90, 0, 0])
    linear_extrude(height)
    text(txt, size=size, font=font, halign="center", valign="center");
}

module print_text_array(arr, y=0) {
    let (a = accumulate(arr))
    for (i = [0 : len(a) - 1]) {
        print_text(str(a[i]), y, f2b - 50 + a[i]);
    }
}

print_text_array(c1, 300);
print_text_array(c2, 930);
print_text_array(c3, 1550);
print_text_array(c4, 2150);

echo("column 1");
echo(accumulate(c1));

echo("column 2");
echo(accumulate(merge_sorted(c1, c2)));

echo("column 3");
echo(accumulate(merge_sorted(c2, c3)));

echo("column 4");
echo(accumulate(merge_sorted(c3, c4)));

echo("column 5");
echo(accumulate(c4));