// Staketet på västra sidan av västra terrassen — utbrutet ur house.scad
// Alla mått i meter
//
// Fristående fil, byggd på samma sätt som norr-staket.scad: parametriserad på
// antal virken i stället för på önskad öppning, så att öppningen faller ut och
// staketet går jämnt ut över hela längden.
//
// Västra sidan är längre än norra och har fyra höjder. Söderifrån:
//   - de två nedersta trappstegen, ett kort fack vardera
//   - låg del längs terrassen
//   - hög del i norr, en exakt likadan sektion som norr-staket.scad
// Terrassens södra nivå är lika djup som ett trappsteg men får inget eget
// räcke — där fortsätter den låga delen, precis som i house.scad.
//
// Varje nivåskillnad får en enda 2x4, delad mellan nivån under och nivån över.
// Stolpen ritas i den övre nivåns höjd och handledaren nedanför dras fram över
// den. Övergången mellan låg och hög del fungerar likadant: den höga delens
// södra 2x4 går i full höjd och är samtidigt låga delens avslutande stolpe.
//
// Alla stolpfötter står på samma nivå, på den genomgående bottenregeln.
// Handledaren trappar i stället ner ett trappsteg i taget.
//
// Staketet står i origo, fristående från husmodellen:
//   x = 0  södra 2x4:ans södra sida, vid nedersta trappstegets södra kant,
//          staketet går norrut längs +X
//   y = 0  västra sidan av 2x4:orna, 95 mm-sidan går österut längs +Y
//   z = 0  bottenregelns undersida
//
// Virkesmåtten är de verkliga hyvlade måtten (2x4 = 45x95, 2x2 = 48x48), inte
// de nominella som house.scad räknar med.

// === PARAMETRAR ===

// Virke — samma verkliga mått som i norr
railing_post_size  = 0.048;     // 2x2, 48x48 mm
railing_top_width  = 0.095;     // 2x4, bredd 95 mm
railing_top_height = 0.045;     // 2x4, höjd 45 mm

// Bärande 2x4-stolpar i räcket — vridna 90° kring sin längsaxel, dvs
// 95 mm-sidan ligger tvärs räcket och 45 mm-sidan längs räckets riktning.
railing_big_across = 0.095;     // 2x4: 95 mm tvärs räcket
railing_big_along  = 0.045;     // 2x4: 45 mm längs räckets riktning
// Stolpen centreras över 2x2-linjen, i liv med den liggande handledaren
railing_big_offset = (railing_big_across - railing_post_size) / 2;

// Hög del i norr — exakt samma sektion som norr-staket.scad, med samma
// indelning, samma stolplängd och samma längd.
high_big_count     = 4;         // Antal 2x4 totalt, ändarna inräknade
high_small_per_bay = 13;        // Antal 2x2 i varje sektion mellan två 2x4
high_post_len      = 2.784;     // Stolparnas längd, 2x2 och 2x4 lika
high_extent        = 3.934 - railing_big_offset;

// Låg del längs terrassen. Höjdskillnaden mot den höga delen är den nominella
// 1100 mm ur house.scad (railing_height_high - railing_height_low), så
// stolplängden följer av den höga delens.
low_bays          = 6;          // Antal sektioner mellan 2x4:orna
low_small_per_bay = 8;          // Antal 2x2 i varje sektion
low_post_len      = high_post_len - 1.100;

// Trappstegen. Ett fack per steg, oavsett hur glest det blir — facket är för
// kort för den låga delens indelning. Måtten är nominella ur house.scad:
// steget är tre terrassplankor djupt och nivåskillnaden 300 mm.
step_count          = 2;        // Antal trappsteg med eget räcke i väster
step_pitch          = 0.630;    // CC mellan stegens 2x4 (deck_upper_depth + spalt)
step_drop           = 0.300;    // Nivåskillnad per steg
step_small_per_bay  = 3;        // Antal 2x2 i varje stegfack

// Terrassens längd, från dess södra kant till norra hörnet. Nominellt mått ur
// house.scad (house_depth - deck_south_y); byt mot det inmätta när västra
// sidan är uppmätt på plats, precis som 3934 i norr.
terrace_extent = 12.06;

// Beräknade värden

// Trappan ligger söder om terrassen och förlänger staketet med ett fack
// per steg. Nedersta stegets 2x4 står i x = 0.
stair_extent = step_count * step_pitch;
west_extent  = stair_extent + terrace_extent;

// Den låga delens utsträckning slutar där den höga delens södra 2x4 börjar.
// Den stolpen hör till den höga sektionen och räknas därför inte med här.
low_extent = terrace_extent - high_extent;

// CC mellan 2x4:orna. I den höga delen står den sista 2x4:an utanför
// sektionerna, därför dras en 2x4 av innan längden delas. I den låga delen
// är den avslutande stolpen övergångsstolpen, som ligger utanför low_extent.
high_bays  = high_big_count - 1;
high_pitch = (high_extent - railing_big_along) / high_bays;
low_pitch  = low_extent / low_bays;

// Öppningen, lika stor mellan alla virken i sektionen — även intill 2x4:orna
function bay_gap(pitch, n_small) =
    (pitch - railing_big_along - n_small * railing_post_size) / (n_small + 1);

high_gap = bay_gap(high_pitch, high_small_per_bay);
low_gap  = bay_gap(low_pitch, low_small_per_bay);
step_gap = bay_gap(step_pitch, step_small_per_bay);

// Stolplängd på trappsteg nr i, räknat från det nedersta (i = 0). Fötterna
// ligger i samma nivå hela vägen, så varje steg upp förlänger stolpen.
function step_post_len(i) = low_post_len - (step_count - i) * step_drop;

// 2x2-linjens västra sida. 2x4:orna är centrerade över den, så deras västra
// sida hamnar i y = 0.
railing_line_y = railing_big_offset;

// Stolparna står på bottenregeln och handledaren ligger på stolparna
railing_foot_z = railing_top_height;
low_top_z      = railing_foot_z + low_post_len;
high_top_z     = railing_foot_z + high_post_len;
low_total_height  = low_top_z + railing_top_height;
high_total_height = high_top_z + railing_top_height;

// === STAKETET I VÄSTER ===

// 2x4 med södra sidan i x
module railing_big_post(x, len) {
    translate([x, railing_line_y - railing_big_offset, railing_foot_z]) {
        cube([railing_big_along, railing_big_across, len]);
    }
}

// 2x2 med södra sidan i x
module railing_small_post(x, len) {
    translate([x, railing_line_y, railing_foot_z]) {
        cube([railing_post_size, railing_post_size, len]);
    }
}

// En sektionsrad: 2x4 först i varje fack och 2x2 jämnt fördelade efter den.
// Utan avslutande 2x4 — den hör till nästa rad eller ritas som sista stolpe.
function post_row(x0, bays, pitch, n_small, gap, len) = [
    for (b = [0 : bays - 1]) each concat(
        [[x0 + b * pitch, true, len]],
        [for (i = [0 : n_small - 1])
            [x0 + b * pitch + railing_big_along + gap
             + i * (railing_post_size + gap), false, len]])
];

// Alla stolpar i ordning från söder till norr, som [södra sidan, 2x4?, längd].
// Både modellen och borrlistan läses härifrån, så de kan inte glida isär.
// Varje rad avslutas av nästa rads första 2x4, som därmed står i den övre
// nivåns höjd: trappstegens delade stolpar och övergångsstolpen mellan låg
// och hög del kommer alla in den vägen.
railing_post_list = concat(
    [for (i = [0 : step_count - 1]) each
        post_row(i * step_pitch, 1, step_pitch, step_small_per_bay, step_gap,
                 step_post_len(i))],
    post_row(stair_extent, low_bays, low_pitch, low_small_per_bay, low_gap,
             low_post_len),
    post_row(stair_extent + low_extent, high_bays, high_pitch,
             high_small_per_bay, high_gap, high_post_len),
    [[stair_extent + low_extent + high_bays * high_pitch, true, high_post_len]]
);

function railing_post_width(big) = big ? railing_big_along : railing_post_size;

module railing_posts() {
    for (p = railing_post_list) {
        if (p[1]) railing_big_post(p[0], p[2]);
        else      railing_small_post(p[0], p[2]);
    }
}

// Liggande 2x4 längs staketet — handledare på ovansidan eller bottenregel.
// Centreras över stolplinjen, precis som de bärande 2x4-stolparna.
// z = regelns underkant.
module railing_rail(x, length, z) {
    translate([x, railing_line_y - (railing_top_width - railing_post_size) / 2, z]) {
        cube([length, railing_top_width, railing_top_height]);
    }
}

// Handledaren på en nivå. Den dras fram över den delade stolpen i norra änden,
// så att nivån ovanför får börja i samma stolpes norra sida.
module railing_handrail(x, length, post_len) {
    railing_rail(x, length, railing_foot_z + post_len);
}

// === FÄRGER ===
organowood = [0.9, 0.88, 0.85];       // Silvergrå/vit (organowood-behandlat)
railing_farg = organowood;            // Räcket i samma ton som huset

// === MODELL ===
module vast_staket() {
    color(railing_farg) {
        railing_posts();

        // Handledare, en per nivå. Trappstegens går fram över den delade
        // stolpen; den låga delens slutar mot övergångsstolpen.
        for (i = [0 : step_count - 1]) {
            railing_handrail(i * step_pitch, step_pitch + railing_big_along,
                             step_post_len(i));
        }
        railing_handrail(stair_extent, low_extent, low_post_len);
        railing_handrail(stair_extent + low_extent, high_extent, high_post_len);

        // Bottenregel, genomgående hela längden inklusive trappan
        railing_rail(0, west_extent, 0);
    }
}

vast_staket();

echo("=== STAKETET I VÄSTER ===");
echo(str("Längd: ", west_extent, " m (trappa ", stair_extent,
         " + låg ", low_extent, " + hög ", high_extent, ")"));
echo("--- Trappstegen (söder) ---");
echo(str(step_count, " steg á 1 fack, CC ", step_pitch * 1000, " mm"));
for (i = [0 : step_count - 1]) {
    echo(str("Steg ", i + 1, " nerifrån: stolplängd ", step_post_len(i), " m"));
}
echo(str("2x2: ", step_count, " fack á ", step_small_per_bay, " st = ",
    step_count * step_small_per_bay, " st"));
echo(str("Öppning: ", step_gap * 1000, " mm, CC 2x2 ",
    (step_gap + railing_post_size) * 1000, " mm"));
echo("--- Låg del (terrassen) ---");
echo(str("Stolplängd: ", low_post_len, " m, total höjd ", low_total_height, " m"));
echo(str("2x4: ", low_bays, " st, CC ", low_pitch * 1000, " mm"));
echo(str("2x2: ", low_bays, " sektioner á ", low_small_per_bay, " st = ",
    low_bays * low_small_per_bay, " st"));
echo(str("Öppning: ", low_gap * 1000, " mm, CC 2x2 ",
    (low_gap + railing_post_size) * 1000, " mm"));
echo("--- Hög del (norr), samma som norr-staket ---");
echo(str("Stolplängd: ", high_post_len, " m, total höjd ", high_total_height, " m"));
echo(str("2x4: ", high_big_count, " st, CC ", high_pitch * 1000, " mm"));
echo(str("2x2: ", high_bays, " sektioner á ", high_small_per_bay, " st = ",
    high_bays * high_small_per_bay, " st"));
echo(str("Öppning: ", high_gap * 1000, " mm, CC 2x2 ",
    (high_gap + railing_post_size) * 1000, " mm"));

// === HÅLBORRNINGSLISTA ===
// Stolparnas centrum längs staketet, mätt från norra änden (hörnet mot norra
// staketet) och söderut. Stolpe 1 är den nordligaste. Hela mm; en halv mm
// avrundas alltid uppåt — utan tillägget avgör flyttalsfelet åt vilket håll
// 22,5 hamnar.
echo("=== HÅLBORRNINGSLISTA (från norr) ===");
for (n = [1 : len(railing_post_list)]) {
    p = railing_post_list[len(railing_post_list) - n];
    center = p[0] + railing_post_width(p[1]) / 2;
    echo(str("Stolpe ", n, ": ", round((west_extent - center) * 1000 + 1e-6), " mm",
             p[1] ? str("  (2x4, ", round(p[2] * 1000), " mm)") : ""));
}
