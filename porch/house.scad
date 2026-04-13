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
railing_high_horizontal = false;  // true = liggande, false = stående
railing_below_west = 0.6;         // Hur långt stolparna går under terrassen (väst)
railing_below_north = 0.6;        // Hur långt stolparna går under terrassen (norr)

// Beräknade värden
roof_drop = tan(roof_angle) * house_depth;
house_height_south = house_height_north - roof_drop;
deck_total_width = deck_board_count * deck_board_width + (deck_board_count - 1) * deck_board_gap;

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
    upper_boards_depth = 3 * deck_board_width + 2 * deck_board_gap;
    y_start = -porch_depth - deck_board_gap - upper_boards_depth - deck_board_gap;

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
    upper_boards_depth = 3 * deck_board_width + 2 * deck_board_gap;
    y_start = -porch_depth - deck_board_gap - 2 * (upper_boards_depth + deck_board_gap);

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
    upper_boards_depth = 3 * deck_board_width + 2 * deck_board_gap;

    // Sättsteg 1: mellan deck_south_edge och deck_step_1
    y_pos_1 = -porch_depth - deck_board_gap - upper_boards_depth;
    translate([-deck_total_width, y_pos_1 - riser_thickness, deck_height - step_drop + deck_board_thickness]) {
        // Nedre bräda
        cube([board_length, riser_thickness, riser_board_height]);
        // Övre bräda
        translate([0, 0, riser_board_height + deck_board_gap]) {
            cube([board_length, riser_thickness, riser_board_height]);
        }
    }

    // Sättsteg 2: mellan deck_step_1 och deck_step_2
    y_pos_2 = -porch_depth - deck_board_gap - 2 * (upper_boards_depth + deck_board_gap);
    translate([-deck_total_width, y_pos_2 - riser_thickness, deck_height - 2 * step_drop + deck_board_thickness]) {
        // Nedre bräda
        cube([board_length, riser_thickness, riser_board_height]);
        // Övre bräda
        translate([0, 0, riser_board_height + deck_board_gap]) {
            cube([board_length, riser_thickness, riser_board_height]);
        }
    }

    // Sättsteg 3: under deck_step_2 (ner till marken)
    y_pos_3 = -porch_depth - deck_board_gap - 3 * (upper_boards_depth + deck_board_gap);
    translate([-deck_total_width, y_pos_3 - riser_thickness, deck_board_thickness]) {
        // Nedre bräda
        cube([board_length, riser_thickness, riser_board_height]);
        // Övre bräda
        translate([0, 0, riser_board_height + deck_board_gap]) {
            cube([board_length, riser_thickness, riser_board_height]);
        }
    }
}

// Staket på västra sidan av terrassen
module railing_west() {
    base_z = deck_height + deck_board_thickness;
    x_pos = -deck_total_width;
    transition_y = house_depth - railing_transition;  // Där höjden ökar

    // Låg del: från y = -porch_depth till y = transition_y
    low_length = transition_y - (-porch_depth);
    low_post_count = floor(low_length / railing_cc_low) + 1;

    for (i = [0 : low_post_count - 1]) {
        y = -porch_depth + i * railing_cc_low;
        if (y <= transition_y) {
            translate([x_pos, y, base_z - railing_below_west]) {
                cube([railing_post_size, railing_post_size, railing_height_low + railing_below_west]);
            }
        }
    }

    // Räcke ovanpå låga delen (2x4)
    translate([x_pos - (railing_top_width - railing_post_size)/2, -porch_depth, base_z + railing_height_low]) {
        cube([railing_top_width, low_length, railing_top_height]);
    }

    // Hög del: från y = transition_y till y = house_depth
    high_length = house_depth - transition_y;

    if (railing_high_horizontal) {
        // Liggande reglar
        high_board_count = floor(railing_height_high / railing_cc_high) + 1;

        // Hörnstolpar för höga delen
        translate([x_pos, transition_y, base_z - railing_below_west]) {
            cube([railing_post_size, railing_post_size, railing_height_high + railing_below_west]);
        }
        translate([x_pos, house_depth - railing_post_size, base_z - railing_below_west]) {
            cube([railing_post_size, railing_post_size, railing_height_high + railing_below_west]);
        }

        for (i = [0 : high_board_count - 1]) {
            z = i * railing_cc_high;
            if (z <= railing_height_high - railing_post_size) {
                translate([x_pos, transition_y, base_z + z]) {
                    cube([railing_post_size, high_length, railing_post_size]);
                }
            }
        }
    } else {
        // Stående reglar
        high_post_count = floor(high_length / railing_cc_high) + 1;

        for (i = [0 : high_post_count - 1]) {
            y = transition_y + i * railing_cc_high;
            if (y <= house_depth) {
                translate([x_pos, y, base_z - railing_below_west]) {
                    cube([railing_post_size, railing_post_size, railing_height_high + railing_below_west]);
                }
            }
        }
    }

    // Räcke ovanpå höga delen (2x4)
    translate([x_pos - (railing_top_width - railing_post_size)/2, transition_y, base_z + railing_height_high]) {
        cube([railing_top_width, high_length, railing_top_height]);
    }
}

// Staket på norra sidan av terrassen (hög del)
module railing_north() {
    base_z = deck_height + deck_board_thickness;
    y_pos = house_depth - railing_post_size;
    rail_length = deck_total_width;

    if (railing_high_horizontal) {
        // Liggande reglar
        high_board_count = floor(railing_height_high / railing_cc_high) + 1;

        // Hörnstolpe (västra hörnet hanteras av railing_west)
        translate([0 - railing_post_size, y_pos, base_z - railing_below_north]) {
            cube([railing_post_size, railing_post_size, railing_height_high + railing_below_north]);
        }

        for (i = [0 : high_board_count - 1]) {
            z = i * railing_cc_high;
            if (z <= railing_height_high - railing_post_size) {
                translate([-deck_total_width, y_pos, base_z + z]) {
                    cube([rail_length, railing_post_size, railing_post_size]);
                }
            }
        }
    } else {
        // Stående reglar
        post_count = floor(rail_length / railing_cc_high) + 1;

        for (i = [0 : post_count - 1]) {
            x = -deck_total_width + i * railing_cc_high;
            if (x <= 0) {
                translate([x, y_pos, base_z - railing_below_north]) {
                    cube([railing_post_size, railing_post_size, railing_height_high + railing_below_north]);
                }
            }
        }
    }

    // Räcke ovanpå (2x4)
    translate([-deck_total_width, y_pos - (railing_top_width - railing_post_size)/2, base_z + railing_height_high]) {
        cube([rail_length, railing_top_width, railing_top_height]);
    }
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
