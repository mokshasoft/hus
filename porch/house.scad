// Husmodell med pulpettak och inglasad veranda
// Alla mått i meter

// === PARAMETRAR ===
// Huvudhus
house_width = 10.2;      // Öst-väst (X)
house_depth = 8.3;       // Nord-syd (Y)
house_height_north = 6;  // Höjd på norra sidan
roof_angle = 11;         // Taklutning i grader mot syd

// Takutskjut
roof_overhang = 0.5;     // Takutskjut huvudhus (50 cm)
roof_thickness = 0.15;   // Taktjocklek (15 cm)

// Veranda
porch_width = 4;         // Öst-väst (X)
porch_depth = 3;         // Nord-syd (Y)
porch_height = 3.0;      // Höjd på verandan
porch_overhang = 0.2;    // Takutskjut veranda (20 cm)

// Terrass (västra sidan)
deck_height = 1.0;           // Höjd från mark
deck_board_width = 0.2;      // 8 tum ≈ 200 mm
deck_board_thickness = 0.05; // 2 tum ≈ 50 mm
deck_board_gap = 0.01;       // 1 cm mellanrum
deck_board_count = 19;       // Antal plankor

// Staket
railing_post_size = 0.05;    // 2x2 tum ≈ 50 mm
railing_top_width = 0.1;     // 2x4 tum, bredd 100 mm
railing_top_height = 0.05;   // 2x4 tum, höjd 50 mm
railing_height_low = 1.1;    // Låg del av staketet
railing_height_high = 2.2;   // Hög del (dubbla)
railing_transition = 3.0;    // 3 meter från norr börjar höga delen
railing_gap_low = 0.1;       // 10 cm öppning på låga delen
railing_cc_low = railing_gap_low + railing_post_size;  // CC-avstånd låg del
railing_cc_high = railing_cc_low / 2;                   // Halva CC på höga delen
railing_gap_high = railing_gap_low / 2;                 // Målöppning på höga delen

// Bärande 2x4-stolpar i räcket — vridna 90° kring sin längsaxel, dvs
// 100 mm-sidan ligger tvärs räcket och 50 mm-sidan längs räckets riktning.
railing_big_across = 0.1;          // 2x4 tum: 100 mm tvärs räcket
railing_big_along = 0.05;          // 2x4 tum: 50 mm längs räckets riktning
// Stolpen centreras över 2x2-linjen, i liv med den liggande handledaren
railing_big_offset = (railing_big_across - railing_post_size) / 2;
railing_small_per_bay_low = 8;     // Antal 2x2 mellan varje 2x4, låg del
railing_small_per_bay_high = 16;   // Antal 2x2 mellan varje 2x4, hög del
railing_small_per_bay_step = 3;    // Antal 2x2 mellan varje 2x4, trappstegen

railing_high_horizontal = false;  // true = liggande, false = stående
// Alla stolpar går ner till samma nivå. Hur långt varje stolpe sticker ner
// under sin egen nivå räknas därför ut, se railing_foot_z längre ner.

// Beräknade värden
roof_drop = tan(roof_angle) * house_depth;
house_height_south = house_height_north - roof_drop;
deck_total_width = deck_board_count * deck_board_width + (deck_board_count - 1) * deck_board_gap;
// Djupet på varje nivå söder om verandan (3 plankor i öst-västlig riktning)
deck_upper_depth = 3 * deck_board_width + 2 * deck_board_gap;
// Terrassens södra kant — dit räcket ska gå, inte bara till y = -porch_depth
deck_south_y = -porch_depth - deck_board_gap - deck_upper_depth;

// === MODULER ===

// Husväggar (utan tak)
module house_walls() {
    points = [
        // Golv (z=0)
        [0, 0, 0],                          // 0: SW
        [house_width, 0, 0],                // 1: SE
        [house_width, house_depth, 0],      // 2: NE
        [0, house_depth, 0],                // 3: NW
        // Toppen av väggarna
        [0, 0, house_height_south],         // 4: SW
        [house_width, 0, house_height_south], // 5: SE
        [house_width, house_depth, house_height_north], // 6: NE
        [0, house_depth, house_height_north]  // 7: NW
    ];

    faces = [
        [0, 1, 2, 3],   // Golv
        [4, 5, 6, 7],   // Övre kant
        [0, 4, 7, 3],   // Västra väggen
        [1, 2, 6, 5],   // Östra väggen
        [2, 3, 7, 6],   // Norra väggen
        [0, 1, 5, 4]    // Södra väggen
    ];

    polyhedron(points=points, faces=faces, convexity=2);
}

// Huvudhusets tak med utskjut
module house_roof() {
    // Takutskjutets extra höjdfall
    overhang_drop_south = tan(roof_angle) * roof_overhang;
    overhang_drop_north = tan(roof_angle) * roof_overhang;

    // Takytans höjder vid kanterna (med utskjut)
    z_south = house_height_south - overhang_drop_south;
    z_north = house_height_north + overhang_drop_north;

    translate([-roof_overhang, -roof_overhang, 0]) {
        total_width = house_width + 2 * roof_overhang;
        total_depth = house_depth + 2 * roof_overhang;

        points = [
            // Undersida av taket
            [0, 0, z_south],                    // 0: SW under
            [total_width, 0, z_south],          // 1: SE under
            [total_width, total_depth, z_north], // 2: NE under
            [0, total_depth, z_north],          // 3: NW under
            // Ovansida av taket
            [0, 0, z_south + roof_thickness],                    // 4: SW över
            [total_width, 0, z_south + roof_thickness],          // 5: SE över
            [total_width, total_depth, z_north + roof_thickness], // 6: NE över
            [0, total_depth, z_north + roof_thickness]           // 7: NW över
        ];

        faces = [
            [3, 2, 1, 0],   // Undersida
            [4, 5, 6, 7],   // Ovansida
            [0, 4, 7, 3],   // Västra kanten
            [1, 2, 6, 5],   // Östra kanten
            [2, 3, 7, 6],   // Norra kanten
            [0, 1, 5, 4]    // Södra kanten
        ];

        polyhedron(points=points, faces=faces, convexity=2);
    }
}

// Veranda (inglasad)
module porch() {
    porch_x_offset = (house_width - porch_width) / 2;

    translate([porch_x_offset, -porch_depth, 0]) {
        difference() {
            cube([porch_width, porch_depth, porch_height]);

            // Urgröpning för glaseffekt
            wall_thickness = 0.1;
            translate([wall_thickness, wall_thickness, wall_thickness]) {
                cube([
                    porch_width - 2*wall_thickness,
                    porch_depth - 2*wall_thickness,
                    porch_height
                ]);
            }
        }
    }
}

// Verandatak med utskjut
module porch_roof() {
    porch_x_offset = (house_width - porch_width) / 2;
    porch_roof_angle = 5;
    porch_roof_drop = tan(porch_roof_angle) * (porch_depth + porch_overhang);

    // Positionera med utskjut
    translate([porch_x_offset - porch_overhang, -porch_depth - porch_overhang, porch_height]) {
        total_width = porch_width + 2 * porch_overhang;
        total_depth = porch_depth + porch_overhang; // Bara utskjut åt söder och sidorna

        points = [
            // Undersida
            [0, 0, 0],                              // 0: SW
            [total_width, 0, 0],                    // 1: SE
            [total_width, total_depth, porch_roof_drop], // 2: NE
            [0, total_depth, porch_roof_drop],      // 3: NW
            // Ovansida
            [0, 0, roof_thickness],                              // 4: SW
            [total_width, 0, roof_thickness],                    // 5: SE
            [total_width, total_depth, porch_roof_drop + roof_thickness], // 6: NE
            [0, total_depth, porch_roof_drop + roof_thickness]   // 7: NW
        ];

        faces = [
            [3, 2, 1, 0],   // Undersida
            [4, 5, 6, 7],   // Ovansida
            [0, 4, 7, 3],   // Västra kanten
            [1, 2, 6, 5],   // Östra kanten
            [2, 3, 7, 6],   // Norra kanten
            [0, 1, 5, 4]    // Södra kanten
        ];

        polyhedron(points=points, faces=faces, convexity=2);
    }
}

// Terrass på västra sidan
module deck() {
    // Terrassen går från husets västra vägg (x=0) västerut
    // och från verandans södra linje (y=-porch_depth) till husets norra vägg
    deck_length = house_depth + porch_depth;  // Från y=-porch_depth till y=house_depth

    translate([0, -porch_depth, deck_height]) {
        for (i = [0 : deck_board_count - 1]) {
            // Varje planka går i nord-sydlig riktning (Y)
            x_pos = -(i * (deck_board_width + deck_board_gap) + deck_board_width);
            translate([x_pos, 0, 0]) {
                cube([deck_board_width, deck_length, deck_board_thickness]);
            }
        }
    }
}

// Plankor mellan terrassen och inglasade verandan
module deck_to_porch() {
    porch_x_offset = (house_width - porch_width) / 2;
    // Börja med 1 cm gap från terrassen (x=0)
    connection_width = porch_x_offset - deck_board_gap;
    board_count = floor(connection_width / (deck_board_width + deck_board_gap));

    translate([deck_board_gap, -porch_depth, deck_height]) {
        for (i = [0 : board_count - 1]) {
            // Varje planka går i nord-sydlig riktning (Y)
            x_pos = i * (deck_board_width + deck_board_gap);
            translate([x_pos, 0, 0]) {
                cube([deck_board_width, porch_depth, deck_board_thickness]);
            }
        }
    }
}

// Plankor i öst-västlig riktning söder om verandan och terrassen
module deck_south_edge() {
    porch_x_offset = (house_width - porch_width) / 2;
    // Från terrassens västra kant till verandans östra kant
    board_length = deck_total_width + porch_x_offset + porch_width;
    south_board_count = 3;

    translate([-deck_total_width, -porch_depth - deck_board_gap, deck_height]) {
        for (i = [0 : south_board_count - 1]) {
            // Varje planka går i öst-västlig riktning (X)
            y_pos = -(i * (deck_board_width + deck_board_gap) + deck_board_width);
            translate([0, y_pos, 0]) {
                cube([board_length, deck_board_width, deck_board_thickness]);
            }
        }
    }
}

// Gemensamma värden för trappsteg
step_drop = 0.3;              // 30 cm mellan nivåer
step_board_count = 3;         // 3 plankor per nivå
riser_thickness = 0.02;       // 20 mm tjocka vertikala brädor
riser_board_height = (step_drop - deck_board_gap) / 2;  // Två brädor med 1 cm mellanrum

// Plankor i öst-västlig riktning, första steget (30 cm ner)
module deck_step_1() {
    porch_x_offset = (house_width - porch_width) / 2;
    board_length = deck_total_width + porch_x_offset + porch_width;

    // Börja söder om deck_south_edge (3 plankor + mellanrum)
    y_start = -porch_depth - deck_board_gap - deck_upper_depth - deck_board_gap;

    translate([-deck_total_width, y_start, deck_height - step_drop]) {
        for (i = [0 : step_board_count - 1]) {
            y_pos = -(i * (deck_board_width + deck_board_gap) + deck_board_width);
            translate([0, y_pos, 0]) {
                cube([board_length, deck_board_width, deck_board_thickness]);
            }
        }
    }
}

// Plankor i öst-västlig riktning, andra steget (60 cm ner)
module deck_step_2() {
    porch_x_offset = (house_width - porch_width) / 2;
    board_length = deck_total_width + porch_x_offset + porch_width;

    // Börja söder om deck_step_1
    y_start = -porch_depth - deck_board_gap - 2 * (deck_upper_depth + deck_board_gap);

    translate([-deck_total_width, y_start, deck_height - 2 * step_drop]) {
        for (i = [0 : step_board_count - 1]) {
            y_pos = -(i * (deck_board_width + deck_board_gap) + deck_board_width);
            translate([0, y_pos, 0]) {
                cube([board_length, deck_board_width, deck_board_thickness]);
            }
        }
    }
}

// Vertikala plankor mellan nivåerna (sättsteg)
module deck_risers() {
    porch_x_offset = (house_width - porch_width) / 2;
    board_length = deck_total_width + porch_x_offset + porch_width;

    // Sättsteg 1: mellan deck_south_edge och deck_step_1
    y_pos_1 = -porch_depth - deck_board_gap - deck_upper_depth;
    translate([-deck_total_width, y_pos_1 - riser_thickness, deck_height - step_drop + deck_board_thickness]) {
        // Nedre bräda
        cube([board_length, riser_thickness, riser_board_height]);
        // Övre bräda
        translate([0, 0, riser_board_height + deck_board_gap]) {
            cube([board_length, riser_thickness, riser_board_height]);
        }
    }

    // Sättsteg 2: mellan deck_step_1 och deck_step_2
    y_pos_2 = -porch_depth - deck_board_gap - 2 * (deck_upper_depth + deck_board_gap);
    translate([-deck_total_width, y_pos_2 - riser_thickness, deck_height - 2 * step_drop + deck_board_thickness]) {
        // Nedre bräda
        cube([board_length, riser_thickness, riser_board_height]);
        // Övre bräda
        translate([0, 0, riser_board_height + deck_board_gap]) {
            cube([board_length, riser_thickness, riser_board_height]);
        }
    }

    // Sättsteg 3: under deck_step_2 (ner till marken)
    y_pos_3 = -porch_depth - deck_board_gap - 3 * (deck_upper_depth + deck_board_gap);
    translate([-deck_total_width, y_pos_3 - riser_thickness, deck_board_thickness]) {
        // Nedre bräda
        cube([board_length, riser_thickness, riser_board_height]);
        // Övre bräda
        translate([0, 0, riser_board_height + deck_board_gap]) {
            cube([board_length, riser_thickness, riser_board_height]);
        }
    }
}

// === RÄCKESSEKTIONER ===
// En sektion delas upp i fack ("bays"). Varje fack består av ett fritt fält
// med n_small st 2x2 följt av en bärande 2x4. Ett fack kan även inledas av en
// 2x4 (start_post) och sista fackets avslutande 2x4 kan utelämnas (end_post),
// t.ex. när nästa sektion tar över stolpen.
//
// Antalet fack väljs så att facklängden hamnar så nära den önskade
// (n_small 2x2 med target_gap emellan) som möjligt; öppningen justeras sedan
// så att sektionen går jämnt ut.

function rs_free(length, start_post) =
    length - (start_post ? railing_big_along : 0);

function rs_wanted_pitch(n_small, target_gap) =
    railing_big_along + n_small * railing_post_size + (n_small + 1) * target_gap;

function rs_bays(length, start_post, n_small, target_gap) =
    max(1, round(rs_free(length, start_post) / rs_wanted_pitch(n_small, target_gap)));

function rs_pitch(length, start_post, n_small, target_gap) =
    rs_free(length, start_post) / rs_bays(length, start_post, n_small, target_gap);

function rs_gap(length, start_post, n_small, target_gap) =
    (rs_pitch(length, start_post, n_small, target_gap) - railing_big_along
        - n_small * railing_post_size) / (n_small + 1);

// Bygger en räckessektion längs +Y från origo, med tjockleken åt +X.
// bays_override > 0 låser antalet fack istället för att räkna ut det; används
// på trappstegen som ska vara ett enda fack oavsett hur glest det blir.
module railing_section(length, height, below, n_small, target_gap,
                       start_post = true, end_post = true, horizontal = false,
                       bays_override = 0) {
    bays  = bays_override > 0
        ? bays_override
        : rs_bays(length, start_post, n_small, target_gap);
    pitch = rs_free(length, start_post) / bays;
    gap   = (pitch - railing_big_along - n_small * railing_post_size) / (n_small + 1);
    y0    = start_post ? railing_big_along : 0;

    // Inledande 2x4
    if (start_post) {
        translate([-railing_big_offset, 0, -below]) {
            cube([railing_big_across, railing_big_along, height + below]);
        }
    }

    for (b = [0 : bays - 1]) {
        bay_start = y0 + b * pitch;      // början på det fria fältet
        free_len  = pitch - railing_big_along;

        if (horizontal) {
            // Liggande 2x2-reglar över hela facket
            rail_count = floor(height / railing_cc_high) + 1;
            for (i = [0 : rail_count - 1]) {
                z = i * railing_cc_high;
                if (z <= height - railing_post_size) {
                    translate([0, bay_start, z]) {
                        cube([railing_post_size, free_len, railing_post_size]);
                    }
                }
            }
        } else {
            // Stående 2x2 i facket
            for (i = [0 : n_small - 1]) {
                translate([0, bay_start + gap + i * (railing_post_size + gap), -below]) {
                    cube([railing_post_size, railing_post_size, height + below]);
                }
            }
        }

        // Avslutande 2x4 på facket
        if (b < bays - 1 || end_post) {
            translate([-railing_big_offset, bay_start + pitch - railing_big_along, -below]) {
                cube([railing_big_across, railing_big_along, height + below]);
            }
        }
    }
}

// Beräknade sektionslängder (används även av materialåtgången längst ner)
railing_transition_y = house_depth - railing_transition;
// Låga delen går ända fram till terrassens södra kant, där trappan börjar
railing_west_low_len  = railing_transition_y - deck_south_y;
railing_west_high_len = house_depth - railing_transition_y;

// Trappans nivåer — norra kanten och ovansidans höjd för varje nivå.
// Översta nivån är terrassens sydkant, lika djup som ett trappsteg.
step_top_y_north = deck_south_y + deck_upper_depth;
step_1_y_north = deck_south_y - deck_board_gap;
step_1_top_z   = deck_height - step_drop + deck_board_thickness;
step_2_y_north = step_1_y_north - deck_upper_depth - deck_board_gap;
step_2_top_z   = deck_height - 2 * step_drop + deck_board_thickness;

// Alla stolpfötter hamnar på samma nivå: lägsta trappstegets ovansida.
// Hur långt en stolpe sticker ner under sin egen nivå är då bara skillnaden
// mellan den nivån och stolpfoten.
deck_top_z     = deck_height + deck_board_thickness;
railing_foot_z = step_2_top_z;
railing_below_deck = deck_top_z - railing_foot_z;

// Trappstegen sträcker sig från terrassens västra kant ända fram till
// verandans östra vägg. Östra kanten speglas kring trappans mittlinje:
// x -> step_mirror_dx - x
step_east_x    = (house_width - porch_width) / 2 + porch_width;
step_mirror_dx = step_east_x - deck_total_width;
// Bottenregel längs trappans östra kant — bara så lång som räcket där
railing_east_bottom_y   = step_2_y_north - deck_upper_depth;
railing_east_bottom_len = deck_south_y + railing_big_along - railing_east_bottom_y;

// Bottenregel att fästa stolpfötterna i — samma 2x4 som handledaren, men
// liggande under fötterna. Eftersom alla fötter ligger på railing_foot_z
// trappar den inte ner som handledaren gör, utan blir en genomgående regel
// per sida, från trappans sydligaste kant upp till husets norra vägg.
railing_bottom_z       = railing_foot_z - railing_top_height;
railing_bottom_west_y  = step_2_y_north - deck_upper_depth;
railing_bottom_west_len = house_depth - railing_bottom_west_y;

// Norra räcket börjar öster om hörnstolpen, som sticker ut railing_big_across
// minus centreringen väster om terrassens kant
railing_north_start   = -deck_total_width - railing_big_offset + railing_big_across;
railing_north_len     = -railing_north_start;

// Liggande 2x4 längs räcket — handledare på ovansidan eller bottenregel.
// Centreras över stolplinjen, precis som de bärande 2x4-stolparna.
// z = regelns underkant.
module railing_rail_y(x_pos, y_start, length, z) {
    translate([x_pos - (railing_top_width - railing_post_size)/2, y_start, z]) {
        cube([railing_top_width, length, railing_top_height]);
    }
}

module railing_rail_x(x_start, y_pos, length, z) {
    translate([x_start, y_pos - (railing_top_width - railing_post_size)/2, z]) {
        cube([length, railing_top_width, railing_top_height]);
    }
}

// Staket på västra sidan av terrassen
module railing_west() {
    base_z = deck_top_z;
    x_pos = -deck_total_width;

    // Låg del: från terrassens södra kant till y = railing_transition_y.
    // 2x4 i början; sista fackets 2x4 ritas separat nedan som övergångsstolpe.
    translate([x_pos, deck_south_y, base_z]) {
        railing_section(railing_west_low_len, railing_height_low, railing_below_deck,
                        railing_small_per_bay_low, railing_gap_low,
                        start_post = true, end_post = false);
    }

    // Räcke ovanpå låga delen (2x4 liggande)
    railing_rail_y(x_pos, deck_south_y, railing_west_low_len,
                   base_z + railing_height_low);

    // Övergångsstolpe (2x4) mellan låga och höga delen — full höjd
    translate([x_pos - railing_big_offset, railing_transition_y - railing_big_along,
               base_z - railing_below_deck]) {
        cube([railing_big_across, railing_big_along,
              railing_height_high + railing_below_deck]);
    }

    // Hög del: från övergången till norra hörnet.
    // Ingen inledande 2x4 (övergångsstolpen sitter direkt intill), men en
    // avslutande 2x4 som blir hörnstolpe i det höga hörnet.
    translate([x_pos, railing_transition_y, base_z]) {
        railing_section(railing_west_high_len, railing_height_high, railing_below_deck,
                        railing_small_per_bay_high, railing_gap_high,
                        start_post = false, end_post = true,
                        horizontal = railing_high_horizontal);
    }

    // Räcke ovanpå höga delen (2x4 liggande)
    railing_rail_y(x_pos, railing_transition_y, railing_west_high_len,
                   base_z + railing_height_high);
}

// Staket på norra sidan av terrassen (hög del)
module railing_north() {
    base_z = deck_top_z;
    y_pos = house_depth - railing_post_size;

    // Startar öster om hörnstolpen (som ritas av railing_west) och avslutas
    // med en 2x4 mot husväggen.
    translate([railing_north_start, house_depth, base_z]) {
        rotate([0, 0, -90]) {
            railing_section(railing_north_len, railing_height_high, railing_below_deck,
                            railing_small_per_bay_high, railing_gap_high,
                            start_post = false, end_post = true,
                            horizontal = railing_high_horizontal);
        }
    }

    // Räcke ovanpå (2x4 liggande)
    railing_rail_x(-deck_total_width, y_pos, deck_total_width,
                   base_z + railing_height_high);
}

// Räcke längs västra kanten av ett trappsteg.
// y_north = stegets norra kant, base_z = ovansidan på stegets plankor.
// 2x4 sätts bara i södra änden — i norr delas stolpen med nivån ovanför, så
// att varje nivåskillnad får en enda 2x4 och inte två sida vid sida.
// Handledaren dras därför fram till den stolpens norra sida.
//
// Sektionens längd mäts hela vägen fram till den delade stolpen, inte bara
// till stegkanten. Annars centreras 2x2:orna i ett fält som är för kort —
// mellanrummet till nivån ovanför och den stolpens tjocklek hör till fältet.
module railing_step(y_north, base_z) {
    x_pos = -deck_total_width;
    length = deck_upper_depth;
    sect_len = length + deck_board_gap + railing_big_along;
    below = base_z - railing_foot_z;   // ner till gemensam stolpfot

    translate([x_pos, y_north - length, base_z]) {
        railing_section(sect_len, railing_height_low, below,
                        railing_small_per_bay_step, railing_gap_low,
                        start_post = true, end_post = false,
                        bays_override = 1);
    }

    // Räcke ovanpå (2x4 liggande)
    railing_rail_y(x_pos, y_north - length, sect_len, base_z + railing_height_low);
}

// Räcken på de två lägre trappstegen, längs både västra och östra kanten
module railing_steps() {
    railing_step(step_1_y_north, step_1_top_z);
    railing_step(step_2_y_north, step_2_top_z);

    // Östra kanten är en spegelbild av den västra, men har tre nivåer i
    // stället för två: terrassens sydkant är lika djup som ett trappsteg och
    // får ett eget räcke här. I väster täcks den nivån av terrassräckets
    // låga del, som fortsätter norrut.
    // Bottenregeln ritas också här, eftersom östsidan inte har någon
    // genomgående sådan att ansluta till.
    translate([step_mirror_dx, 0, 0]) mirror([1, 0, 0]) {
        railing_step(step_top_y_north, deck_top_z);
        railing_step(step_1_y_north, step_1_top_z);
        railing_step(step_2_y_north, step_2_top_z);

        railing_rail_y(-deck_total_width, railing_east_bottom_y,
                       railing_east_bottom_len, railing_bottom_z);
    }
}

// Bottenregel under samtliga stolpfötter — en genomgående per sida
module railing_bottom() {
    railing_rail_y(-deck_total_width, railing_bottom_west_y,
                   railing_bottom_west_len, railing_bottom_z);
    railing_rail_x(-deck_total_width, house_depth - railing_post_size,
                   deck_total_width, railing_bottom_z);
}

// === FÄRGER ===
organowood = [0.9, 0.88, 0.85];       // Silvergrå/vit (organowood-behandlat)
burnt_wood = [0.25, 0.18, 0.12];      // Bränt trä (shou sugi ban)

// === KOMPLETT MODELL ===
module complete_house() {
    color(organowood) house_walls();
    color("darkgray") house_roof();
    color("lightblue", 0.5) porch();
    color("gray") porch_roof();
    color(organowood) deck();
    color(organowood) deck_to_porch();
    color(organowood) deck_south_edge();
    color(organowood) deck_step_1();
    color(organowood) deck_step_2();
    color(organowood) deck_risers();
    color(burnt_wood) railing_west();
    color(burnt_wood) railing_north();
    color(burnt_wood) railing_steps();
    color(burnt_wood) railing_bottom();
}

// Rendera huset
complete_house();

// Visa dimensioner i konsolen
echo("=== HUSETS DIMENSIONER ===");
echo(str("Bredd (Ö-V): ", house_width, " m"));
echo(str("Djup (N-S): ", house_depth, " m"));
echo(str("Höjd norr: ", house_height_north, " m"));
echo(str("Höjd söder: ", house_height_south, " m"));
echo(str("Takfall: ", roof_drop, " m"));
echo(str("Takutskjut: ", roof_overhang, " m"));
echo(str("Terrass bredd: ", deck_total_width, " m"));
echo(str("Terrass längd: ", house_depth + porch_depth, " m"));

// === MATERIALÅTGÅNG TILL RÄCKET ===
// Sektionsindelning (samma funktioner som geometrin använder)
mat_low_bays   = rs_bays(railing_west_low_len,  true,  railing_small_per_bay_low,  railing_gap_low);
mat_high_bays  = rs_bays(railing_west_high_len, false, railing_small_per_bay_high, railing_gap_high);
mat_north_bays = rs_bays(railing_north_len,     false, railing_small_per_bay_high, railing_gap_high);

mat_low_gap    = rs_gap(railing_west_low_len,  true,  railing_small_per_bay_low,  railing_gap_low);
mat_high_gap   = rs_gap(railing_west_high_len, false, railing_small_per_bay_high, railing_gap_high);
mat_north_gap  = rs_gap(railing_north_len,     false, railing_small_per_bay_high, railing_gap_high);

mat_high_free  = rs_pitch(railing_west_high_len, false, railing_small_per_bay_high, railing_gap_high) - railing_big_along;
mat_north_free = rs_pitch(railing_north_len,     false, railing_small_per_bay_high, railing_gap_high) - railing_big_along;
mat_horiz_rails = floor(railing_height_high / railing_cc_high) + 1;

// Trappstegsräckena (två lika sektioner, låsta till ett fack vardera)
mat_step_bays  = 1;
// Sektioner av trappstegstyp: steg 1 och steg 2 på båda sidor, plus trappans
// översta nivå i öster. I väster täcks den nivån av terrassräckets låga del.
mat_step_units = 5;
// Sektionen mäts fram till den delade 2x4:an på nivån ovanför
mat_step_rail  = deck_upper_depth + deck_board_gap + railing_big_along;
mat_step_pitch = rs_free(mat_step_rail, true) / mat_step_bays;
mat_step_gap   = (mat_step_pitch - railing_big_along
    - railing_small_per_bay_step * railing_post_size) / (railing_small_per_bay_step + 1);

// Stolplängder
mat_len_low_west   = railing_height_low  + railing_below_deck;
mat_len_high_west  = railing_height_high + railing_below_deck;
mat_len_high_north = railing_height_high + railing_below_deck;
// Stegens stolpar går olika långt ner eftersom de utgår från olika nivåer
mat_len_step_1     = railing_height_low  + (step_1_top_z - railing_foot_z);
mat_len_step_2     = railing_height_low  + (step_2_top_z - railing_foot_z);

// --- 2x2 (50x50 mm) ---
mat_2x2_low_count = mat_low_bays * railing_small_per_bay_low;
mat_2x2_low_total = mat_2x2_low_count * mat_len_low_west;

mat_2x2_high_count = railing_high_horizontal
    ? mat_high_bays * mat_horiz_rails
    : mat_high_bays * railing_small_per_bay_high;
mat_2x2_high_len = railing_high_horizontal ? mat_high_free : mat_len_high_west;
mat_2x2_high_total = mat_2x2_high_count * mat_2x2_high_len;

mat_2x2_north_count = railing_high_horizontal
    ? mat_north_bays * mat_horiz_rails
    : mat_north_bays * railing_small_per_bay_high;
mat_2x2_north_len = railing_high_horizontal ? mat_north_free : mat_len_high_north;
mat_2x2_north_total = mat_2x2_north_count * mat_2x2_north_len;

// Trappans sektioner, railing_small_per_bay_step st 2x2 per fack
mat_2x2_step_count = mat_step_units * mat_step_bays * railing_small_per_bay_step;
mat_2x2_step_total = mat_step_bays * railing_small_per_bay_step
    * (2 * mat_len_step_1 + 2 * mat_len_step_2 + mat_len_low_west);

mat_2x2_total = mat_2x2_low_total + mat_2x2_high_total + mat_2x2_north_total
    + mat_2x2_step_total;

// --- 2x4 (50x100 mm) ---
// Låga delen: en inledande stolpe + en i slutet av varje fack utom det sista
mat_2x4_low_count = mat_low_bays;
mat_2x4_low_total = mat_2x4_low_count * mat_len_low_west;
// Övergångsstolpen mellan låg och hög del
mat_2x4_trans_total = mat_len_high_west;
// Höga delen: en stolpe i slutet av varje fack (sista blir hörnstolpe)
mat_2x4_high_total = mat_high_bays * mat_len_high_west;
// Norr: en stolpe i slutet av varje fack (sista mot husväggen)
mat_2x4_north_total = mat_north_bays * mat_len_high_north;
// Trappstegen: en 2x4 i södra änden på varje steg (norr delas med nivån ovanför)
mat_2x4_step_count = mat_step_units * mat_step_bays;
mat_2x4_step_total = mat_step_bays
    * (2 * mat_len_step_1 + 2 * mat_len_step_2 + mat_len_low_west);

mat_2x4_posts_count = mat_2x4_low_count + 1 + mat_high_bays + mat_north_bays
    + mat_2x4_step_count;
mat_2x4_posts_total = mat_2x4_low_total + mat_2x4_trans_total
    + mat_2x4_high_total + mat_2x4_north_total + mat_2x4_step_total;

// Liggande handledare ovanpå räcket
mat_2x4_top_total = railing_west_low_len + railing_west_high_len + deck_total_width
    + mat_step_units * mat_step_rail;

// Bottenregel: en genomgående per sida
mat_2x4_bottom_total = railing_bottom_west_len + deck_total_width
    + railing_east_bottom_len;

mat_2x4_total = mat_2x4_posts_total + mat_2x4_top_total + mat_2x4_bottom_total;

echo("=== RÄCKETS INDELNING ===");
echo(str("Väst låg: ", mat_low_bays, " fack á ", railing_small_per_bay_low,
    " st 2x2, öppning ", mat_low_gap * 1000, " mm"));
echo(str("Väst hög: ", mat_high_bays, " fack á ", railing_small_per_bay_high,
    " st 2x2, öppning ", mat_high_gap * 1000, " mm"));
echo(str("Norr: ", mat_north_bays, " fack á ", railing_small_per_bay_high,
    " st 2x2, öppning ", mat_north_gap * 1000, " mm"));
echo(str("Trappsteg (2 st): ", mat_step_bays, " fack á ", railing_small_per_bay_step,
    " st 2x2, öppning ", mat_step_gap * 1000, " mm"));

echo("=== 2x2 ÅTGÅNG TILL RÄCKET ===");
echo(str("Väst låg: ", mat_2x2_low_count, " st á ", mat_len_low_west, " m = ", mat_2x2_low_total, " m"));
echo(str("Väst hög: ", mat_2x2_high_count, " st á ", mat_2x2_high_len, " m = ", mat_2x2_high_total, " m"));
echo(str("Norr: ", mat_2x2_north_count, " st á ", mat_2x2_north_len, " m = ", mat_2x2_north_total, " m"));
echo(str("Trappan: ", 2 * railing_small_per_bay_step, " st á ", mat_len_step_1, " m + ",
    2 * railing_small_per_bay_step, " st á ", mat_len_step_2, " m + ",
    railing_small_per_bay_step, " st á ", mat_len_low_west,
    " m (östra toppnivån) = ", mat_2x2_step_total, " m"));
echo(str("TOTALT 2x2: ", mat_2x2_total, " m"));

echo("=== 2x4 ÅTGÅNG TILL RÄCKET ===");
echo(str("Väst låg: ", mat_2x4_low_count, " stolpar á ", mat_len_low_west, " m = ", mat_2x4_low_total, " m"));
echo(str("Övergång låg/hög: 1 stolpe á ", mat_len_high_west, " m"));
echo(str("Väst hög: ", mat_high_bays, " stolpar á ", mat_len_high_west, " m = ", mat_2x4_high_total, " m"));
echo(str("Norr: ", mat_north_bays, " stolpar á ", mat_len_high_north, " m = ", mat_2x4_north_total, " m"));
echo(str("Trappan: 2 st á ", mat_len_step_1, " m + 2 st á ", mat_len_step_2,
    " m + 1 st á ", mat_len_low_west, " m (östra toppnivån) = ", mat_2x4_step_total, " m"));
echo(str("Stolpar totalt: ", mat_2x4_posts_count, " st = ", mat_2x4_posts_total, " m"));
echo(str("Handledare ovanpå: ", mat_2x4_top_total, " m"));
echo(str("Bottenregel: ", mat_2x4_bottom_total, " m"));
echo(str("TOTALT 2x4: ", mat_2x4_total, " m"));

// === KAPLISTA ===
// Samma virke som ovan, men grupperat per längd istället för per sektion.
// Längderna hålls i millimeter så att jämförelsen blir exakt — annars kan
// t.ex. 1.1 + 0.6 bli 1.7000000000000002 och räknas som en egen längd.

function kl_sum(v, i = 0) = i >= len(v) ? 0 : v[i] + kl_sum(v, i + 1);
function kl_has(v, x, i = 0) =
    i >= len(v) ? false : (v[i] == x ? true : kl_has(v, x, i + 1));
function kl_uniq(items, i = 0, acc = []) =
    i >= len(items) ? acc
    : kl_uniq(items, i + 1, kl_has(acc, items[i][0]) ? acc : concat(acc, [items[i][0]]));
function kl_max(v, i = 0, best = -1) =
    i >= len(v) ? best : kl_max(v, i + 1, v[i] > best ? v[i] : best);
function kl_sort_desc(v) =
    len(v) == 0 ? [] : let(m = kl_max(v)) concat([m], kl_sort_desc([for (e = v) if (e != m) e]));
// Antal respektive löpmeter för en given längd
function kl_count(items, L) = kl_sum([for (it = items) if (it[0] == L) it[1]]);
function kl_meters(items, L) = kl_count(items, L) * L / 1000;
function kl_total_count(items) = kl_sum([for (it = items) it[1]]);
function kl_total_meters(items) = kl_sum([for (it = items) it[1] * it[0] / 1000]);

// [längd i mm, antal]
kl_2x2 = [
    [round(mat_len_low_west  * 1000), mat_2x2_low_count],
    [round(mat_2x2_high_len  * 1000), mat_2x2_high_count],
    [round(mat_2x2_north_len * 1000), mat_2x2_north_count],
    [round(mat_len_step_1    * 1000), 2 * mat_step_bays * railing_small_per_bay_step],
    [round(mat_len_step_2    * 1000), 2 * mat_step_bays * railing_small_per_bay_step],
    [round(mat_len_low_west  * 1000), mat_step_bays * railing_small_per_bay_step]
];

kl_2x4_posts = [
    [round(mat_len_low_west   * 1000), mat_2x4_low_count],
    [round(mat_len_high_west  * 1000), 1 + mat_high_bays],  // övergångsstolpe + höga delen
    [round(mat_len_high_north * 1000), mat_north_bays],
    [round(mat_len_step_1     * 1000), 2 * mat_step_bays],
    [round(mat_len_step_2     * 1000), 2 * mat_step_bays],
    [round(mat_len_low_west   * 1000), mat_step_bays]
];

kl_2x4_rails = [
    [round(railing_west_low_len  * 1000), 1],
    [round(railing_west_high_len * 1000), 1],
    [round(deck_total_width      * 1000), 1],
    [round(mat_step_rail         * 1000), mat_step_units]
];

kl_2x4_bottom = [
    [round(railing_bottom_west_len  * 1000), 1],
    [round(deck_total_width         * 1000), 1],
    [round(railing_east_bottom_len  * 1000), 1]
];

echo("=== KAPLISTA: 2x2 (50x50 mm) ===");
for (L = kl_sort_desc(kl_uniq(kl_2x2)))
    echo(str("  ", kl_count(kl_2x2, L), " st  á ", L, " mm  = ", kl_meters(kl_2x2, L), " m"));
echo(str("  SUMMA: ", kl_total_count(kl_2x2), " st, ", kl_total_meters(kl_2x2), " m"));

echo("=== KAPLISTA: 2x4 (50x100 mm) STOLPAR ===");
for (L = kl_sort_desc(kl_uniq(kl_2x4_posts)))
    echo(str("  ", kl_count(kl_2x4_posts, L), " st  á ", L, " mm  = ", kl_meters(kl_2x4_posts, L), " m"));
echo(str("  SUMMA: ", kl_total_count(kl_2x4_posts), " st, ", kl_total_meters(kl_2x4_posts), " m"));

echo("=== KAPLISTA: 2x4 (50x100 mm) LIGGANDE HANDLEDARE ===");
for (L = kl_sort_desc(kl_uniq(kl_2x4_rails)))
    echo(str("  ", kl_count(kl_2x4_rails, L), " st  á ", L, " mm  = ", kl_meters(kl_2x4_rails, L), " m"));
echo(str("  SUMMA: ", kl_total_count(kl_2x4_rails), " st, ", kl_total_meters(kl_2x4_rails), " m"));

echo("=== KAPLISTA: 2x4 (50x100 mm) BOTTENREGEL ===");
for (L = kl_sort_desc(kl_uniq(kl_2x4_bottom)))
    echo(str("  ", kl_count(kl_2x4_bottom, L), " st  á ", L, " mm  = ", kl_meters(kl_2x4_bottom, L), " m"));
echo(str("  SUMMA: ", kl_total_count(kl_2x4_bottom), " st, ", kl_total_meters(kl_2x4_bottom), " m"));

echo(str("=== KAPLISTA SUMMA: 2x2 ", kl_total_meters(kl_2x2), " m, 2x4 ",
    kl_total_meters(kl_2x4_posts) + kl_total_meters(kl_2x4_rails)
        + kl_total_meters(kl_2x4_bottom), " m ==="));
