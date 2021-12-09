include <lib/element.scad>

function z(h) =
    [0, 0, h];

// Supporting structure

h = 2;
w = 6;
l = 9;

// Create a line of plinths
module beam_line(coord1, coord2, h, nbr, tag = "cc") {
    assert(nbr >= 2, "more than two plinths");
    let ( cc = (coord2 - coord1)/(nbr - 1)
        )
        echo(tag, norm(cc))
        for (i=[0:nbr - 1])
            let (p = coord1 + i*cc)
            beam(p, p + z(h), 0.3);
}

c1 = [0, 0, 0];
c2 = [w, 0, 0];
c3 = [w, l, 0];
c4 = [0, l, 0];

let ( th = 0.3
    , h = 2
    )
    union() {
        beam_line(c1, c2, h, 3);
        beam_line(c2, c3, h, 3);
        beam_line(c3, c4, h, 3);
        beam_line(c4, c1, h, 3);
    }