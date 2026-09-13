// Staketet på norra sidan av västra terrassen — utbrutet ur house.scad
// Alla mått i meter
//
// Fristående fil, parametriserad på antal virken i stället för på önskad
// öppning: antalet 2x4 totalt och antalet 2x2 i varje sektion mellan två 2x4.
// Öppningen mellan virkena faller ut ur det, så att staketet går jämnt ut
// över hela längden.
//
// Staketet står i origo, fristående från husmodellen:
//   x = 0  västra 2x4:ans västra sida, staketet går österut längs +X
//   y = 0  södra sidan av 2x4:orna, 95 mm-sidan går norrut längs +Y
//   z = 0  bottenregelns undersida
//
// Virkesmåtten är de verkliga hyvlade måtten (2x4 = 45x95, 2x2 = 48x48), inte
// de nominella som house.scad räknar med.
//
// Med kommer:
//  - 2x4 i båda ändarna och jämnt fördelade däremellan
//  - 2x2 i sektionerna mellan dem
//  - handledaren ovanpå
//  - bottenregeln under stolpfötterna

// === PARAMETRAR ===

// Indelning
railing_big_count     = 4;      // Antal 2x4 totalt, ändarna inräknade
railing_small_per_bay = 13;    // Antal 2x2 i varje sektion mellan två 2x4

// Virke
railing_post_size  = 0.048;     // 2x2, 48x48 mm
railing_top_width  = 0.095;     // 2x4, bredd 95 mm
railing_top_height = 0.045;     // 2x4, höjd 45 mm
railing_post_len   = 2.784;     // Stolparnas längd, 2x2 och 2x4 lika

// Bärande 2x4-stolpar i räcket — vridna 90° kring sin längsaxel, dvs
// 95 mm-sidan ligger tvärs räcket och 45 mm-sidan längs räckets riktning.
railing_big_across = 0.095;     // 2x4: 95 mm tvärs räcket
railing_big_along  = 0.045;     // 2x4: 45 mm längs räckets riktning
// Stolpen centreras över 2x2-linjen, i liv med den liggande handledaren
railing_big_offset = (railing_big_across - railing_post_size) / 2;

// Staketets utsträckning i öst-väst, från västra 2x4:ans västra sida till
// husväggen: 3934 minus 2x4:ans centrering över 2x2-linjen.
north_extent = 3.934 - (railing_big_across - railing_post_size) / 2;

// Beräknade värden

railing_bays = railing_big_count - 1;   // Sektioner mellan 2x4:orna

// CC mellan 2x4:orna. Den sista 2x4:an står utanför sektionerna, därför dras
// en 2x4 av innan längden delas.
railing_pitch = (north_extent - railing_big_along) / railing_bays;

// Öppningen, lika stor mellan alla virken i sektionen — även intill 2x4:orna
railing_gap = (railing_pitch - railing_big_along
               - railing_small_per_bay * railing_post_size)
              / (railing_small_per_bay + 1);

// 2x2-linjens södra sida. 2x4:orna är centrerade över den, så deras södra
// sida hamnar i y = 0.
railing_line_y = railing_big_offset;

// Stolparna står på bottenregeln och handledaren ligger på stolparna
railing_foot_z = railing_top_height;
railing_top_z  = railing_foot_z + railing_post_len;
railing_total_height = railing_top_z + railing_top_height;

// === STAKETET I NORR ===

// 2x4 med västra sidan i x
module railing_big_post(x) {
    translate([x, railing_line_y - railing_big_offset, railing_foot_z]) {
        cube([railing_big_along, railing_big_across, railing_post_len]);
    }
}

// 2x2 med västra sidan i x
module railing_small_post(x) {
    translate([x, railing_line_y, railing_foot_z]) {
        cube([railing_post_size, railing_post_size, railing_post_len]);
    }
}

// Alla stolpar i ordning från väster till öster, som [västra sidan, 2x4?].
// Både modellen och borrlistan läses härifrån, så de kan inte glida isär.
railing_post_list = [
    for (b = [0 : railing_bays - 1]) each concat(
        [[b * railing_pitch, true]],
        [for (i = [0 : railing_small_per_bay - 1])
            [b * railing_pitch + railing_big_along + railing_gap
             + i * (railing_post_size + railing_gap), false]]),
    [railing_bays * railing_pitch, true]
];

function railing_post_width(big) = big ? railing_big_along : railing_post_size;

module railing_posts() {
    for (p = railing_post_list) {
        if (p[1]) railing_big_post(p[0]);
        else      railing_small_post(p[0]);
    }
}

// Liggande 2x4 längs staketet — handledare på ovansidan eller bottenregel.
// Centreras över stolplinjen, precis som de bärande 2x4-stolparna.
// z = regelns underkant.
module railing_rail(z) {
    translate([0, railing_line_y - (railing_top_width - railing_post_size) / 2, z]) {
        cube([north_extent, railing_top_width, railing_top_height]);
    }
}

// === FÄRGER ===
organowood = [0.9, 0.88, 0.85];       // Silvergrå/vit (organowood-behandlat)
railing_farg = organowood;            // Räcket i samma ton som huset

// === MODELL ===
module norr_staket() {
    color(railing_farg) {
        railing_posts();
        railing_rail(railing_top_z);   // Handledare
        railing_rail(0);               // Bottenregel
    }
}

norr_staket();

echo("=== STAKETET I NORR ===");
echo(str("Längd: ", north_extent, " m"));
echo(str("Stolplängd: ", railing_post_len, " m"));
echo(str("Total höjd: ", railing_total_height, " m"));
echo(str("2x4: ", railing_big_count, " st, CC ", railing_pitch * 1000, " mm"));
echo(str("2x2: ", railing_bays, " sektioner á ", railing_small_per_bay, " st = ",
    railing_bays * railing_small_per_bay, " st"));
echo(str("Öppning: ", railing_gap * 1000, " mm, CC 2x2 ",
    (railing_gap + railing_post_size) * 1000, " mm"));

// === HÅLBORRNINGSLISTA ===
// Stolparnas centrum längs staketet, mätt från östra änden (husväggen) och
// västerut. Stolpe 1 är den östligaste. Hela mm; en halv mm avrundas alltid
// uppåt — utan tillägget avgör flyttalsfelet åt vilket håll 22,5 hamnar.
echo("=== HÅLBORRNINGSLISTA (från öster) ===");
for (n = [1 : len(railing_post_list)]) {
    p = railing_post_list[len(railing_post_list) - n];
    center = p[0] + railing_post_width(p[1]) / 2;
    echo(str("Stolpe ", n, ": ", round((north_extent - center) * 1000 + 1e-6), " mm",
             p[1] ? "  (2x4)" : ""));
}
