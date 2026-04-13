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

// Beräknade värden
roof_drop = tan(roof_angle) * house_depth;
house_height_south = house_height_north - roof_drop;

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

// === KOMPLETT MODELL ===
module complete_house() {
    color("white") house_walls();
    color("darkgray") house_roof();
    color("lightblue", 0.5) porch();
    color("gray") porch_roof();
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
