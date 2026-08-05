// Husmodell med pulpettak och inglasad veranda
// Alla mått i meter

// === PARAMETRAR ===

// Ytterväggens skikt utanför grundstommen. Stommen är referensen när man
// bygger och mäter, medan modellens fasadliv är panelens utsida. Skillnaden
// är summan här, och den används både för att sätta husets yttermått och för
// att räkna om uppmätta fönsterlägen till modellkoordinater.
wall_vindskydd = 0.06;   // Komprimerad halm
wall_luftspalt = 0.05;   // Ventilerad spalt bakom panelen
wall_panel     = 0.03;   // Fasadpanel
wall_utanfor_stomme = wall_vindskydd + wall_luftspalt + wall_panel;

// Huvudhus. Grundstommens yttermått är det som mäts på bygget; husets
// yttermått blir stommen plus ett skikt på varje sida.
//
// frame_width är bara huvuddelen, alltså längden på den nordligaste väggen.
// Ritningens 10050 är byggnadens totala stommått i öst-väst och innehåller
// även utbyggnadens utskjut på 1700 — se ext_frame_width nedan.
frame_width = 8.35;      // Stommen öst-väst, huvuddelen
frame_depth = 8.15;      // Stommen nord-syd
house_width = frame_width + 2 * wall_utanfor_stomme;   // Öst-väst (X)
house_depth = frame_depth + 2 * wall_utanfor_stomme;   // Nord-syd (Y)
// Stommens höjd på norra sidan, mätt från färdigt golv. Husets höjd över mark
// räknas ut i Beräknade värden, när golvnivån är känd.
frame_height_north = 4.985;
roof_angle = 11;         // Taklutning i grader mot syd

// Takutskjut
roof_overhang = 0.5;     // Takutskjut huvudhus (50 cm)

// Takets uppbyggnad ovanpå stommen, nerifrån och upp. Underkanten ligger i
// takplanet roof_z(), så hela paketet reser sig därifrån.
roof_isolering = 0.51;   // Isolering
roof_bradlager = 0.03;   // Brädlager ovanpå isoleringen
roof_lakt      = 0.06;   // Läkt som bär plåten
roof_plat      = 0.001;  // Plåttak
roof_thickness = roof_isolering + roof_bradlager + roof_lakt + roof_plat;

// Utskjutet har ingen isolering. Där bär en stående 2x4 upp samma ytskikt,
// så utskjutet blir betydligt tunnare än taket över huskroppen. Plåten är
// gemensam och ligger i ett plan, så det är ovansidorna som möts — utskjutets
// undersida hamnar därför en bit ovanför stommens överkant.
roof_utskjut_regel = 0.10;   // 2x4 stående, 100 mm på höjden
roof_utskjut_panel = 0.03;   // Panel ovanpå regeln
roof_utskjut_spalt = 0.06;   // Luftspalt under plåten
roof_utskjut_thickness = roof_utskjut_regel + roof_utskjut_panel
                       + roof_utskjut_spalt + roof_plat;

// Fasadskiktet slutar inte vid stommens överkant utan fortsätter upp förbi
// takets isolering och möter takfotens undersida. Utifrån syns därför vägg
// ända dit, och bara takfoten ovanför är taktäckt. Isolerpaketets kant ligger
// bakom fasaden och syns inte.
wall_over_frame = roof_thickness - roof_utskjut_thickness;

// Verandataket är en egen, lätt konstruktion och följer inte huvudtakets
// uppbyggnad.
porch_roof_thickness = 0.15;

// Utbyggnad på sydöstra sidan. De 1700 är stommens utskjut; utanpå det kommer
// samma skikt som på övriga väggar, så utskjutet räknat från fasadlivet blir
// stommåttet plus skaltjockleken.
ext_frame_width = 1.7;   // Stommens utskjut åt öst
ext_width = ext_frame_width + wall_utanfor_stomme;   // Hur långt byggnaden går ut

// Utbyggnadens norra vägg ligger 5200 mm söder om stommens norra vägg. Båda
// de väggarna har skalet utanpå sig, så ext_depth räknas hela vägen från
// södra fasadlivet: in till stommens norra liv, 5200 söderut, och ut igen
// genom utbyggnadens eget skal.
ext_fran_norra_stomvaggen = 5.2;
ext_depth = (wall_utanfor_stomme + frame_depth - ext_fran_norra_stomvaggen)
          + wall_utanfor_stomme;

// Ytterväggen. Huset var tidigare en solid kloss; för att fönstren ska sitta
// i ett genomgående hål gröps huset ur och väggen får en tjocklek.
house_wall_thickness = 0.55;

// Golvbjälklaget, lika tjockt som väggen. Färdigt golv ligger i liv med
// terrassen, så bjälklaget hamnar en bit upp i huskroppen och det som blir
// kvar under det är grund. Nivån sätts vid deck_top_z längre ner, eftersom
// terrassmåtten definieras först där.
house_floor_thickness = 0.55;

// Fönster. Måtten i window_list är hålets mått i väggen — fönstret tillverkas
// mindre än så, med en spalt runt om som drevas.
window_gap        = 0.015;  // Spalt mellan karm och hålkant, runt om
window_karm       = 0.05;   // Karmens synliga bredd runt glaset
window_karm_depth = 0.12;   // Karmens djup in i väggen
window_inset      = 0.17;   // Karmens utsida indragen från fasadliv
window_glass_t    = 0.03;   // Glaspaketets tjocklek
// Färgen på ett tätt dörrblad. Hör egentligen hemma i FÄRGER längre ner, men
// window_list använder den och filnivåns tilldelningar utvärderas i ordning —
// en framåtreferens ger undef och dörren hade ritats som glas.
door_white        = [1, 1, 1];

// Tak över östra terrassen (altanen på framsidan). Går från utbyggnadens
// norra vägg och norrut, en bit under takutskjutet ovanför, och lutar med
// samma vinkel som huvudtaket fast åt andra hållet — dvs fall mot norr.
// Måttet räknas från takplanet, dvs stommens överkant. Takfoten ovanför
// ligger högre än så — utskjutet har ingen isolering och hänger i plåtens
// plan — så den fria höjden upp till takfoten blir större än det här talet.
deck_east_roof_below     = 0.5;   // Under takplanet vid utbyggnaden
deck_east_roof_span      = 2.5;   // Från utbyggnaden fram till stolpen
deck_east_roof_overhang  = 0.3;   // Utskjut norr om stolpen
deck_east_roof_joist_w   = 0.05;  // 2x6 tum: 50 mm tvärs regeln
deck_east_roof_joist_h   = 0.15;  // 2x6 tum: 150 mm på höjden
deck_east_roof_joist_cc  = 0.6;   // Önskat CC mellan takreglarna
deck_east_roof_post_size = 0.15;  // Stolpe 6x6 tum ≈ 150 mm
deck_east_roof_sheet_t   = 0.022; // Takskiva ovanpå reglarna, 22 mm råspont

// Veranda. Bredden och läget i öst-väst räknas ut ur sydfasadens öppningar,
// se porch_x_offset längre ner — verandan är inte inmätt utan avläst ur var
// den står i förhållande till fönstren.
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

// Räcket på östra terrassen — L-format plus en stump i söder
railing_east_stub_len  = 0.5;      // Från utbyggnadens vägg och norrut
// Östra kanten går från nordöstra hörnet och söderut fram till takstolpen.
// Längden följer därför av var stolpen står, se railing_east_south_len nedan.

railing_high_horizontal = false;  // true = liggande, false = stående
// Alla stolpar går ner till samma nivå. Hur långt varje stolpe sticker ner
// under sin egen nivå räknas därför ut, se railing_foot_z längre ner.

// Beräknade värden

// Färdigt golv ligger i liv med terrassen, så man går rakt ut utan steg.
// Bjälklaget ligger mellan house_floor_z - house_floor_thickness och golvnivån.
// Nivån behövs redan här, eftersom stommens höjd mäts från golvet.
deck_top_z    = deck_height + deck_board_thickness;
house_floor_z = deck_top_z;

// Stommen står på bjälklaget, så husets höjd över mark är golvnivån plus
// stomhöjden. Takplanet roof_z() ligger i stommens överkant och takpaketet
// ovanpå det.
house_height_north = house_floor_z + frame_height_north;

roof_drop = tan(roof_angle) * house_depth;
house_height_south = house_height_north - roof_drop;
deck_total_width = deck_board_count * deck_board_width + (deck_board_count - 1) * deck_board_gap;
// Djupet på varje nivå söder om verandan (3 plankor i öst-västlig riktning)
deck_upper_depth = 3 * deck_board_width + 2 * deck_board_gap;
// Terrassens södra kant — dit räcket ska gå, inte bara till y = -porch_depth
deck_south_y = -porch_depth - deck_board_gap - deck_upper_depth;

// Terrass öster om huset, i den tomma delen norr om utbyggnaden. Den går
// lika långt österut som utbyggnaden, alltså mellan husväggen och
// utbyggnadens östra liv.
deck_east_y0 = ext_depth;
deck_east_len = house_depth - ext_depth;
// Så många hela plankor som ryms med normalt mellanrum. Bredden är låst av
// utbyggnaden, så mellanrummet justeras i stället för att lämna en stump
// vid kanten — samma princip som räckets fackindelning.
deck_east_count = floor((ext_width + deck_board_gap)
                        / (deck_board_width + deck_board_gap));
deck_east_gap = (ext_width - deck_east_count * deck_board_width)
                / (deck_east_count - 1);

// Taket över östra terrassen. Det går lika långt österut som resten av
// byggnaden, dvs husets utskjut räknat från utbyggnadens östra liv, och
// norrut till stolpen plus utskjutet där.
deck_east_roof_x0     = house_width;                    // Mot husets östra vägg
deck_east_roof_x_post = house_width + ext_width;        // Stolplinjen = utbyggnadens liv
deck_east_roof_x1     = deck_east_roof_x_post + roof_overhang;
deck_east_roof_y_post = deck_east_y0 + deck_east_roof_span;
deck_east_roof_y1     = deck_east_roof_y_post + deck_east_roof_overhang;
deck_east_roof_width  = deck_east_roof_x1 - deck_east_roof_x0;

// Takreglarna går i nord-sydlig riktning, dvs med fallet. Den västra ligger
// mot husväggen och den östra i takets yttre kant, så antalet väljs så att
// CC hamnar så nära det önskade som möjligt och kanterna går jämnt ut.
deck_east_roof_joists = max(2, round((deck_east_roof_width - deck_east_roof_joist_w)
                                     / deck_east_roof_joist_cc) + 1);
deck_east_roof_pitch  = (deck_east_roof_width - deck_east_roof_joist_w)
                        / (deck_east_roof_joists - 1);
// Längd längs lutningen — reglarna är längre än det vågräta måttet
deck_east_roof_rake   = (deck_east_roof_y1 - deck_east_y0) / cos(roof_angle);

// Räcket längs östra kanten går söderut från nordöstra hörnet och slutar mot
// takstolpen, som tar över rollen som avslutande stolpe. Trappöppningen blir
// därmed allt söder om stolpen, ner till stumpen vid utbyggnaden.
railing_east_south_len = house_depth - deck_east_roof_y_post;

// === MODULER ===

// Husets yttre form (utan tak) — solid kloss, gröps ur av house_walls()
module house_shell() {
    points = [
        // Golv (z=0)
        [0, 0, 0],                          // 0: SW
        [house_width, 0, 0],                // 1: SE
        [house_width, house_depth, 0],      // 2: NE
        [0, house_depth, 0],                // 3: NW
        // Toppen av väggarna — fasaden går upp till takfotens undersida,
        // wall_over_frame ovanför stommens överkant
        [0, 0, house_height_south + wall_over_frame],         // 4: SW
        [house_width, 0, house_height_south + wall_over_frame], // 5: SE
        [house_width, house_depth, house_height_north + wall_over_frame], // 6: NE
        [0, house_depth, house_height_north + wall_over_frame]  // 7: NW
    ];

    faces = [
        [3, 2, 1, 0],   // Golv (vänd som takens undersidor, annars blir
                        // formen inte sluten och difference() ger tomt)
        [4, 5, 6, 7],   // Övre kant
        [0, 4, 7, 3],   // Västra väggen
        [1, 2, 6, 5],   // Östra väggen
        [2, 3, 7, 6],   // Norra väggen
        [0, 1, 5, 4]    // Södra väggen
    ];

    polyhedron(points=points, faces=faces, convexity=2);
}

// === FÖNSTER ===
// Ett fönster anges med hålets mått i väggen, inte fönstrets. Fönstret görs
// window_gap mindre runt om, och glaset ligger window_karm innanför det.
//
//   [vägg, läge, underkant, hålets bredd, hålets höjd, typ, fyllning]
//
// vägg   "S" syd, "N" norr, "O" öst, "V" väst på huvudhuset,
//        "UO" utbyggnadens östvägg
// typ    valfri text till beställningslistan; utelämnad blir posten "Fönster".
//        Geometrin är densamma — en glasdörr är ett hål med karm och glas,
//        bara med underkanten i golvnivå.
// fyllning  valfri färg på det som sitter innanför karmen; utelämnad ger
//        genomskinligt glas. En tät dörr får sitt dörrblad här i stället.
// läge   hålets mittlinje, i husets koordinater (x för syd/norr, y för öst/väst)
// underkant  hålets underkant över färdigt golv
//
// Nordfasaden ritas sedd utifrån, så "höger" i den vyn är väster, dvs mot
// x = 0. Måtten tas därifrån och in till fönstrets högra kant; mittlinjen
// blir då avståndet plus halva hålbredden.
//
// Måtten är tagna från grundstommens liv, inte från panelens utsida som är
// modellens x = 0. Hela fönsterpaketet skjuts därför wall_utanfor_stomme
// inåt (åt vänster i fasadvyn). Inbördes avstånd påverkas inte, eftersom
// samma tillägg görs på alla fönster på väggen.
function n_x(fran_hoger_gavel, w) = wall_utanfor_stomme + fran_hoger_gavel + w / 2;

// Norra väggen — riktiga mått. Måtten löper från fasadvyns högra kant, dvs
// västra gaveln, och vidare åt vänster fönster för fönster. Varje fönster
// placeras relativt det föregående i stället för med ett eget absolutmått,
// så att kedjan håller ihop om ett mått ändras.

// 1-2: två lika fönster över varandra, längst till höger
n1_b          = 1.308;  // Hålets bredd
n1_h          = 0.610;  // Hålets höjd
n1_fran_hoger = 1.400;  // Höger gavel till hålets högra kant
n1_underkant  = 1.200;  // Undre fönstrets underkant över färdigt golv
n1_mellanrum  = 1.190;  // Undre fönstrets översida till övre fönstrets underkant

// De nedre fönstren har hålens överkant på exakt samma höjd
n_overkant_nedre = n1_underkant + n1_h;

// 3: ett högre fönster till vänster om dem, med överkanten i liv
n2_b          = 1.308;
n2_h          = 1.210;
n2_underkant  = n_overkant_nedre - n2_h;
n2_avstand    = 2.955;  // Fönster 1-2:s vänstra kant till detta fönsters högra kant
n2_fran_hoger = n1_fran_hoger + n1_b + n2_avstand;

// === ÖVRE RADEN ===
// Två fönster som delar både underkant och höjd. Underkanten är den som det
// befintliga övre fönstret redan har, dvs given av mellanrummet upp från det
// undre högra. Höjden är gemensam och sätts på ett ställe.
n_ovre_underkant = n1_underkant + n1_h + n1_mellanrum;

// Gemensam hålhöjd för båda fönstren i övre raden — ändra bara här.
// Underkanten ligger på 3000 över golv och stommens överkant på 4985, så
// taket för den här siffran är 1985 mm.
n_ovre_h = 1.210;

// Höger: samma bredd och sidoläge som det undre fönstret rakt under
n3_b          = n1_b;
n3_h          = n_ovre_h;
n3_fran_hoger = n1_fran_hoger;

// Vänster: nytt fönster, med högerkanten i liv med det stora under det
n4_b          = 0.675;
n4_h          = n_ovre_h;
n4_fran_hoger = n2_fran_hoger;

window_list_north = [
    ["N", n_x(n1_fran_hoger, n1_b), n1_underkant, n1_b, n1_h],
    ["N", n_x(n3_fran_hoger, n3_b), n_ovre_underkant, n3_b, n3_h],
    ["N", n_x(n2_fran_hoger, n2_b), n2_underkant, n2_b, n2_h],
    ["N", n_x(n4_fran_hoger, n4_b), n_ovre_underkant, n4_b, n4_h]
];

// Västfasaden ses också utifrån. Där är "höger" i vyn söder, dvs mot y = 0,
// och måtten löper norrut därifrån. Samma skaltillägg som på nordfasaden,
// eftersom stommens södra liv ligger wall_utanfor_stomme in från fasadlivet.
function v_y(fran_hoger_horn, w) = wall_utanfor_stomme + fran_hoger_horn + w / 2;

// Västra väggen — riktiga mått

// 1: stort fönster närmast södra hörnet
v1_b          = 1.808;  // Hålets bredd
v1_h          = 1.210;  // Hålets höjd
v1_fran_hoger = 0.600;  // Stommens södra liv till hålets högra kant
v1_underkant  = 0.800;  // Underkant över färdigt golv

// 2: mindre fönster högre upp, norr om det första. Sidoläget är givet som en
// måttkedja från ritningen och står kvar som en summa: 600 fram till v1, 1850
// för v1:s stomöppning, och 255 därifrån hit. Att 1850 är 42 mm mer än v1:s
// hålmått 1808 beror på plywooden som klär öppningen, 21 mm på varje sida —
// måtten i window_list är alltid det färdiga hålet, inte stomöppningen.
v2_b          = 0.908;
v2_h          = 0.610;
v2_fran_hoger = 0.255 + 1.850 + 0.600;
v2_underkant  = 3.000;

// 3: samma underkant som v2, längre norrut. Sidoläget är givet från stommens
// norra ände, så det räknas om till avstånd från höger genom att dras från
// stommens djup.
v3_b          = 1.308;
v3_h          = 0.610;
v3_fran_norr  = 1.955;  // Stommens norra liv till hålets högra kant
v3_fran_hoger = frame_depth - v3_fran_norr;
v3_underkant  = v2_underkant;

// 4: glasdörr rakt under v2, med underkanten i golvnivå
v4_b          = 0.908;
v4_h          = 2.010;
v4_fran_hoger = v2_fran_hoger;   // Exakt under fönster 2
v4_underkant  = 0;

window_list_west = [
    ["V", v_y(v1_fran_hoger, v1_b), v1_underkant, v1_b, v1_h],
    ["V", v_y(v2_fran_hoger, v2_b), v2_underkant, v2_b, v2_h],
    ["V", v_y(v3_fran_hoger, v3_b), v3_underkant, v3_b, v3_h],
    ["V", v_y(v4_fran_hoger, v4_b), v4_underkant, v4_b, v4_h, "Glasdörr"]
];

// Östfasaden ses utifrån, så "höger" i den vyn är norr och vänster söder.
// Måtten på den här fasaden är tagna från båda hållen, så det finns en
// funktion per riktning. Båda lägger på skalet, eftersom stommens liv ligger
// wall_utanfor_stomme innanför fasaden.
function o_y_vanster(fran_vanster, w) =
    wall_utanfor_stomme + fran_vanster + w / 2;
function o_y_hoger(fran_hoger, w) =
    wall_utanfor_stomme + frame_depth - fran_hoger - w / 2;

// Utbyggnadens östvägg — enda fönstret på östsidan
o1_b            = 0.558;  // Hålets bredd
o1_h            = 1.050;  // Hålets höjd
o1_fran_vanster = 1.175;  // Utbyggnadens södra stomliv till hålets vänstra kant
o1_underkant    = 0.900;  // Underkant över färdigt golv

// Huvudhusets östvägg — en tät vit dörr ut mot östra terrassen, norr om
// utbyggnaden. Sidoläget är mätt från stommens norra liv.
o2_b          = 1.013;  // Hålets bredd
o2_h          = 2.115;  // Hålets höjd
o2_fran_hoger = 3.600;  // Stommens norra liv till hålets högra kant
o2_underkant  = 0;      // Dörr, alltså golvnivå

window_list_east = [
    ["UO", o_y_vanster(o1_fran_vanster, o1_b), o1_underkant, o1_b, o1_h],
    ["O",  o_y_hoger(o2_fran_hoger, o2_b), o2_underkant, o2_b, o2_h,
           "Dörr", door_white]
];

// Sydfasaden ses utifrån, så "höger" i den vyn är öster och vänster väster.
// Måtten är tagna från stommens västra liv och löper österut.
function s_x(fran_vanster, w) = wall_utanfor_stomme + fran_vanster + w / 2;

// Södra väggen — två lika öppningar i golvnivå med en smal spalt emellan
s1_b            = 0.908;  // Hålets bredd
s1_h            = 2.010;  // Hålets höjd
s1_fran_vanster = 1.495;  // Stommens västra liv till hålets vänstra kant
s1_underkant    = 0;      // Golvnivå

// 2: likadan, placerad utifrån spalten till den första i stället för med ett
// eget mått från gaveln. Ligger innanför verandan.
s2_b            = s1_b;
s2_h            = s1_h;
s2_spalt        = 0.360;  // Mellan hålens kanter
s2_fran_vanster = s1_fran_vanster + s1_b + s2_spalt;
s2_underkant    = s1_underkant;

// 3: mindre fönster högre upp, öster om de två. Placerat utifrån spalten till
// nummer 2, så kedjan hänger ihop hela vägen från västra gaveln.
s3_b            = 0.558;  // Hålets bredd
s3_h            = 1.040;  // Hålets höjd
s3_spalt        = 2.915;  // Mellan hålens kanter
s3_fran_vanster = s2_fran_vanster + s2_b + s3_spalt;
s3_underkant    = 0.900;  // Underkant över färdigt golv

window_list_south = [
    ["S", s_x(s1_fran_vanster, s1_b), s1_underkant, s1_b, s1_h],
    ["S", s_x(s2_fran_vanster, s2_b), s2_underkant, s2_b, s2_h],
    ["S", s_x(s3_fran_vanster, s3_b), s3_underkant, s3_b, s3_h]
];

window_list = concat(window_list_north, window_list_west, window_list_east,
                     window_list_south);

// === VERANDANS LÄGE ===
// Verandan har inga egna inmätta mått. Läget är avläst ur sydfasaden: västra
// väggen står i spalten mellan de två vänstra öppningarna, och östra väggen
// slutar porch_ost_fore_s3 innan den högra öppningens vänstra kant. Måtten
// binds därför till fönsterkedjan i stället för att centreras på huset — då
// följer verandan med om fönstren flyttas.
//
// OBS: ungefärligt. Byt mot stommått när de finns.
porch_ost_fore_s3 = 0.200;   // Från verandans östra vägg till s3:s vänstra kant

porch_x_offset = s_x(s1_fran_vanster, s1_b) + s1_b / 2 + s2_spalt / 2;
porch_x1       = s_x(s3_fran_vanster, s3_b) - s3_b / 2 - porch_ost_fore_s3;
porch_width    = porch_x1 - porch_x_offset;

// Fönstrets tillverkningsmått (karmyttermått) och glasets fria mått
function win_outer_w(w) = w - 2 * window_gap;
function win_outer_h(h) = h - 2 * window_gap;
function win_glass_w(w) = win_outer_w(w) - 2 * window_karm;
function win_glass_h(h) = win_outer_h(h) - 2 * window_karm;

// Ställer barnen i väggens plan: fasadliv i y = 0, väggen inåt mot +y,
// hålets underkant i z = 0 och hålet centrerat kring x = 0.
// Höjden i window_list räknas från färdigt golv, inte från mark.
module window_place(win) {
    v = win[0];
    p = win[1];
    z = house_floor_z + win[2];

    if (v == "S")      translate([p, 0, z]) children();
    else if (v == "N") translate([p, house_depth, z]) rotate([0, 0, 180]) children();
    else if (v == "O") translate([house_width, p, z]) rotate([0, 0, 90]) children();
    else if (v == "V") translate([0, p, z]) rotate([0, 0, -90]) children();
    else if (v == "UO") translate([house_width + ext_width, p, z])
                            rotate([0, 0, 90]) children();
}

// Hålet i väggen, genomgående
module window_opening(w, h) {
    eps = 0.001;
    translate([-w / 2, -eps, 0])
        cube([w, house_wall_thickness + 2 * eps, h]);
}

// Själva fönstret: karm som ram runt glaset, centrerat i hålet
// fyllning = färg på det som sitter innanför karmen. Utelämnad ger
// genomskinligt glas; en tät dörr skickar in sitt dörrblad i stället.
module window_unit(w, h, fyllning = undef) {
    eps = 0.001;
    ow = win_outer_w(w);
    oh = win_outer_h(h);
    gw = win_glass_w(w);
    gh = win_glass_h(h);

    translate([-ow / 2, window_inset, window_gap]) {
        color(window_frame) difference() {
            cube([ow, window_karm_depth, oh]);
            translate([window_karm, -eps, window_karm])
                cube([gw, window_karm_depth + 2 * eps, gh]);
        }
        // Fyllningen mitt i karmdjupet
        color(is_undef(fyllning) ? "lightblue" : fyllning,
              is_undef(fyllning) ? 0.5 : 1)
            translate([window_karm, (window_karm_depth - window_glass_t) / 2, window_karm])
                cube([gw, window_glass_t, gh]);
    }
}

module windows() {
    for (win = window_list) window_place(win) window_unit(win[3], win[4], win[6]);
}

// Hålrummet innanför ytterväggen. Börjar ovanpå bjälklaget och går ända upp
// genom väggkrönet, så att väggarna blir en ram och taket vilar ovanpå.
// Det som blir kvar under hålrummet är golvet.
module house_cavity() {
    t = house_wall_thickness;
    translate([t, t, house_floor_z])
        cube([house_width - 2 * t, house_depth - 2 * t, house_height_north + 1]);
}

// Husväggar (utan tak) — urgröpta och med hål för fönstren.
//
// render(convexity) behövs för snabbpreviewen (F5). Den ritar difference()
// med djuptest i stället för att räkna ut geometrin, och måste veta hur många
// ytor en blick som mest korsar. Ett urgröpt hus med fönsterhål ger många
// fler än polyhedrons convexity=2, och utan det här ser väggarna genomskinliga
// ut — man ser bortre väggens insida rakt igenom den närmaste.
module house_walls() {
    render(convexity = 12)
    difference() {
        house_shell();
        house_cavity();
        for (win = window_list) window_place(win) window_opening(win[3], win[4]);
    }
}

// Takplanets underkant vid en given y. Samma plan över hela byggnaden, så
// både huvudtaket och utbyggnadens tak ligger i liv med varandra.
function roof_z(y) = house_height_south + tan(roof_angle) * y;

// Utbyggnad i sydöstra hörnet — väggarna toppar mot samma takplan.
// Yttre form; gröps ur av house_east_ext().
module house_east_ext_shell() {
    x0 = house_width;
    x1 = house_width + ext_width;

    points = [
        // Golv (z=0)
        [x0, 0, 0],                     // 0: SW
        [x1, 0, 0],                     // 1: SE
        [x1, ext_depth, 0],             // 2: NE
        [x0, ext_depth, 0],             // 3: NW
        // Toppen av väggarna — upp till takfotens undersida, som på huvudhuset
        [x0, 0, roof_z(0) + wall_over_frame],             // 4: SW
        [x1, 0, roof_z(0) + wall_over_frame],             // 5: SE
        [x1, ext_depth, roof_z(ext_depth) + wall_over_frame], // 6: NE
        [x0, ext_depth, roof_z(ext_depth) + wall_over_frame]  // 7: NW
    ];

    faces = [
        [3, 2, 1, 0],   // Golv (vänd som takens undersidor, annars blir
                        // formen inte sluten och difference() ger tomt)
        [4, 5, 6, 7],   // Övre kant
        [0, 4, 7, 3],   // Västra väggen (mot huvudhuset)
        [1, 2, 6, 5],   // Östra väggen
        [2, 3, 7, 6],   // Norra väggen
        [0, 1, 5, 4]    // Södra väggen
    ];

    polyhedron(points=points, faces=faces, convexity=2);
}

// Hålrummet i utbyggnaden. Öppet mot huvudhuset i väster, så det börjar i
// husets fasadliv och lämnar bara utbyggnadens tre egna väggar.
module house_east_ext_cavity() {
    t = house_wall_thickness;
    translate([house_width, t, house_floor_z])
        cube([ext_width - t, ext_depth - 2 * t, house_height_north + 1]);
}

// Utbyggnaden, urgröpt och med hål för sina fönster
module house_east_ext() {
    render(convexity = 12)
    difference() {
        house_east_ext_shell();
        house_east_ext_cavity();
        for (win = window_list) window_place(win) window_opening(win[3], win[4]);
    }
}

// Ett skivstycke i takplanet. z0 och z1 är under- respektive ovansidans
// avstånd från takplanet roof_z(), så skivan följer lutningen av sig själv.
module roof_slab(x0, x1, y0, y1, z0, z1) {
    points = [
        [x0, y0, roof_z(y0) + z0],   // 0: SW under
        [x1, y0, roof_z(y0) + z0],   // 1: SE under
        [x1, y1, roof_z(y1) + z0],   // 2: NE under
        [x0, y1, roof_z(y1) + z0],   // 3: NW under
        [x0, y0, roof_z(y0) + z1],   // 4: SW över
        [x1, y0, roof_z(y0) + z1],   // 5: SE över
        [x1, y1, roof_z(y1) + z1],   // 6: NE över
        [x0, y1, roof_z(y1) + z1]    // 7: NW över
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

// Utbyggnadens tak — samma plan och samma utskjut som huvudtaket.
// Inget utskjut i väster, där möter det huvudtaket.
module house_east_ext_roof() {
    // Tunn skiva över hela ytan, inklusive utskjutet
    roof_slab(house_width, house_width + ext_width + roof_overhang,
              -roof_overhang, ext_depth + roof_overhang,
              roof_thickness - roof_utskjut_thickness, roof_thickness);

    // Isolerpaketet, bara över utbyggnadens egen kropp. Indraget bakom
    // fasaden på de tre fria sidorna; i väster möter det huvudhuset.
    t = house_wall_thickness;
    roof_slab(house_width, house_width + ext_width - t,
              t, ext_depth - t,
              0, roof_thickness);
}

// Huvudhusets tak med utskjut. Två skivor: en tunn som går ut över kanterna
// och bär plåten, och isolerpaketet som bara ligger över huskroppen.
module house_roof() {
    // Tunn skiva över hela ytan, inklusive utskjutet
    roof_slab(-roof_overhang, house_width + roof_overhang,
              -roof_overhang, house_depth + roof_overhang,
              roof_thickness - roof_utskjut_thickness, roof_thickness);

    // Isolerpaketet, bara över huskroppen. Indraget en väggtjocklek så att
    // dess kant hamnar bakom fasaden i stället för i liv med den — annars
    // ligger två olikfärgade ytor i samma plan och strider om vem som syns.
    t = house_wall_thickness;
    roof_slab(t, house_width - t, t, house_depth - t, 0, roof_thickness);
}

// Veranda (inglasad)
module porch() {

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
            [0, 0, porch_roof_thickness],                              // 4: SW
            [total_width, 0, porch_roof_thickness],                    // 5: SE
            [total_width, total_depth, porch_roof_drop + porch_roof_thickness], // 6: NE
            [0, total_depth, porch_roof_drop + porch_roof_thickness]   // 7: NW
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

// Terrass öster om huset, norr om utbyggnaden.
// Plankorna går i nord-sydlig riktning som på västsidan.
module deck_east() {
    translate([house_width, deck_east_y0, deck_height]) {
        for (i = [0 : deck_east_count - 1]) {
            translate([i * (deck_board_width + deck_east_gap), 0, 0]) {
                cube([deck_board_width, deck_east_len, deck_board_thickness]);
            }
        }
    }
}

// Trappa från östra terrassen ner till marken. Öppna steg, ett 2x8 per steg,
// som löper i nord-sydlig riktning över hela öppningens bredd.
module stair_east() {
    x0 = house_width + ext_width;

    for (i = [1 : stair_east_treads]) {
        z_top  = deck_top_z - i * stair_east_rise;
        x_step = x0 + (i - 1) * stair_east_run;
        for (b = [0 : stair_east_boards - 1]) {
            translate([x_step + b * (deck_board_width + stair_east_gap),
                       stair_east_y0, z_top - deck_board_thickness]) {
                cube([deck_board_width, stair_east_width, deck_board_thickness]);
            }
        }
    }
}

// Taket över östra terrassen. Ovansidan av takskivan är ett eget takplan som
// börjar deck_east_roof_below under takplanet vid utbyggnadens norra vägg
// och faller mot norr med husets taklutning.
function deck_east_roof_top_z(y) =
    roof_z(deck_east_y0) - deck_east_roof_below
    - tan(roof_angle) * (y - deck_east_y0);

// Takreglarnas ovansida — takskivan ligger ovanpå dem
function deck_east_roof_joist_top_z(y) =
    deck_east_roof_top_z(y) - deck_east_roof_sheet_t;

// Undersidan av takreglarna vid ett givet y
function deck_east_roof_soffit_z(y) =
    deck_east_roof_joist_top_z(y) - deck_east_roof_joist_h;

// Skiva eller balk i takplanet, byggd liggande längs +Y och vriden ner i
// lutningen kring sin södra ände. z_top = ovansidan vid södra änden.
module deck_east_roof_raked(width, height, z_top) {
    translate([0, deck_east_y0, z_top]) {
        rotate([-roof_angle, 0, 0]) {
            translate([0, 0, -height]) {
                cube([width, deck_east_roof_rake, height]);
            }
        }
    }
}

// En takregel, 2x6 på högkant, med ovansidan mot takskivan
module deck_east_roof_joist(x) {
    translate([x, 0, 0]) {
        deck_east_roof_raked(deck_east_roof_joist_w, deck_east_roof_joist_h,
                             deck_east_roof_joist_top_z(deck_east_y0));
    }
}

// Takskivan, hela takytan i ett stycke ovanpå reglarna
module deck_east_roof_sheet() {
    translate([deck_east_roof_x0, 0, 0]) {
        deck_east_roof_raked(deck_east_roof_width, deck_east_roof_sheet_t,
                             deck_east_roof_top_z(deck_east_y0));
    }
}

// Vågrät bärande regel under takreglarna, tvärs över hela takets bredd:
// väggregeln mot utbyggnaden i söder och bärlinan över stolpen i norr.
// y_north = regelns norra sida; ovansidan läggs i liv med takreglarnas
// undersida där, dvs i regelns lägsta punkt.
module deck_east_roof_beam(y_north) {
    z_top = deck_east_roof_soffit_z(y_north);
    translate([deck_east_roof_x0, y_north - deck_east_roof_joist_w,
               z_top - deck_east_roof_joist_h]) {
        cube([deck_east_roof_width, deck_east_roof_joist_w,
              deck_east_roof_joist_h]);
    }
}

// Stolpen som bär upp det fria hörnet. Norra och östra sidan ligger i liv
// med bärlinans respektive takets stolplinje, så utskjuten mäts från stolpen.
// I modellen står den på terrassen; i verkligheten fortsätter den ner till
// en plint under terrassen.
module deck_east_roof_post() {
    z_top = deck_east_roof_soffit_z(deck_east_roof_y_post)
            - deck_east_roof_joist_h;
    translate([deck_east_roof_x_post - deck_east_roof_post_size,
               deck_east_roof_y_post - deck_east_roof_post_size, deck_top_z]) {
        cube([deck_east_roof_post_size, deck_east_roof_post_size,
              z_top - deck_top_z]);
    }
}

module deck_east_roof() {
    // Takreglar, från husväggen och österut till takets yttre kant
    for (i = [0 : deck_east_roof_joists - 1]) {
        deck_east_roof_joist(deck_east_roof_x0 + i * deck_east_roof_pitch);
    }

    // Väggregel mot utbyggnadens norra vägg, och bärlina över stolpen.
    // Båda går ut i takets östra kant, dvs de kragar ut roof_overhang
    // förbi utbyggnadens liv.
    deck_east_roof_beam(deck_east_y0 + deck_east_roof_joist_w);
    deck_east_roof_beam(deck_east_roof_y_post);

    deck_east_roof_post();
}

// Plankor mellan terrassen och inglasade verandan
module deck_to_porch() {
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

// Antal 2x2 som ger en öppning så nära målet som möjligt i ett givet fält.
function rs_fit_small(free_len, target_gap) =
    max(1, round((free_len - target_gap) / (railing_post_size + target_gap)));

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

// Räckessektion där antalet 2x2 anpassas till fackets bredd i stället för att
// vara fast. Korta sektioner behöver det: åtta 2x2 i ett halvmeterfack skulle
// ge noll öppning, medan samma antal i ett brett fack blir för glest.
function rs_fit_bays(length, start_post) =
    rs_bays(length, start_post, railing_small_per_bay_low, railing_gap_low);
function rs_fit_clear(length, start_post) =
    rs_free(length, start_post) / rs_fit_bays(length, start_post) - railing_big_along;
function rs_fit_n(length, start_post) =
    rs_fit_small(rs_fit_clear(length, start_post), railing_gap_low);

module railing_section_fit(length, height, below, start_post = true, end_post = true) {
    railing_section(length, height, below,
                    rs_fit_n(length, start_post), railing_gap_low,
                    start_post = start_post, end_post = end_post,
                    bays_override = rs_fit_bays(length, start_post));
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
// deck_top_z och house_floor_z definieras bland de beräknade värdena längre
// upp, eftersom stommens höjd mäts från golvnivån.
railing_foot_z = step_2_top_z;
railing_below_deck = deck_top_z - railing_foot_z;

// På östra terrassen går inga stolpar ner under däcket. Bottenregeln ligger
// i stället ovanpå plankorna och stolparna står på den, så stolparna blir
// kortare medan handledaren hamnar på samma höjd över däcket som i väster.
railing_east_foot_z = deck_top_z + railing_top_height;  // ovansidan på bottenregeln
railing_east_top_z  = deck_top_z + railing_height_low;  // undersidan på handledaren
railing_east_height = railing_east_top_z - railing_east_foot_z;

// Trappa ner från östra terrassen, i öppningen mellan räckessektionerna.
// Dimensionerad efter trappformeln (Blondel): 2 x stighöjd + steg ska ligga
// i intervallet 600-640 mm. Planstegen byggs av 2x8, och stegdjupet följer
// av hur många brädor som läggs per steg — det är den enda fria variabeln,
// eftersom brädbredden är given.
stair_east_formula = 0.63;              // Målvärde för 2h + b
stair_east_boards  = 1;                 // Antal 2x8 per plansteg
stair_east_gap     = deck_board_gap;    // Mellanrum mellan brädorna i ett steg
stair_east_run     = stair_east_boards * deck_board_width
                   + (stair_east_boards - 1) * stair_east_gap;
// Stighöjden ur formeln. Antalet avrundas så att trappan landar exakt på
// marken; stighöjden justeras då marginellt och summan hamnar fortfarande
// inom intervallet.
stair_east_rise_ideal = (stair_east_formula - stair_east_run) / 2;
stair_east_risers = max(1, round(deck_top_z / stair_east_rise_ideal));
stair_east_rise   = deck_top_z / stair_east_risers;
stair_east_treads = stair_east_risers - 1;   // marken är sista steget
stair_east_sum    = 2 * stair_east_rise + stair_east_run;
stair_east_y0     = deck_east_y0 + railing_east_stub_len;
stair_east_y1     = house_depth - railing_east_south_len;
stair_east_width  = stair_east_y1 - stair_east_y0;

// Trappstegen sträcker sig från terrassens västra kant ända fram till
// verandans östra vägg. Östra kanten speglas kring trappans mittlinje:
// x -> step_mirror_dx - x
step_east_x    = porch_x1;   // Verandans östra liv
step_mirror_dx = step_east_x - deck_total_width;
// Bottenregel längs trappans östra kant — från trappans sydligaste kant och
// norrut ända in till verandans södra vägg, så att även översta stegets
// stolpfötter får något att stå på. Motsvarar den genomgående regeln i väster.
railing_east_bottom_y   = step_2_y_north - deck_upper_depth;
railing_east_bottom_len = -porch_depth - railing_east_bottom_y;

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

// Räcke på östra terrassen. Tre sektioner:
//  - en stump från utbyggnadens vägg och railing_east_stub_len norrut
//  - norra kanten, från husets nordöstra hörn och österut till hörnstolpen
//  - östra kanten, söderut från hörnet fram till takets stolpe
// Hörnstolpen hör till den östra sektionen; den norra går fram till den.
// Varje sektion får handledare på ovansidan och bottenregel under fötterna.
// Här ligger bottenregeln ovanpå terrassen och stolparna står på den, så
// inget virke går ner under däcket.
module railing_deck_east() {
    base_z  = railing_east_foot_z;
    x_edge  = house_width + ext_width;
    x_line  = x_edge - railing_post_size;   // 2x2-linjen, indragen från kanten
    y_south = house_depth - railing_east_south_len;
    north_len = x_edge - (railing_big_across - railing_big_offset) - house_width;

    // Stump i söder, längs östra kanten
    translate([x_line, deck_east_y0, base_z]) {
        railing_section_fit(railing_east_stub_len, railing_east_height, 0);
    }
    railing_rail_y(x_line, deck_east_y0, railing_east_stub_len,
                   railing_east_top_z);
    railing_rail_y(x_line, deck_east_y0, railing_east_stub_len, deck_top_z);

    // Östra kanten, söderut från nordöstra hörnet fram till takstolpen.
    // Ingen egen 2x4 i södra änden — där står takets stolpe.
    translate([x_line, y_south, base_z]) {
        railing_section_fit(railing_east_south_len, railing_east_height, 0,
                            start_post = false);
    }
    railing_rail_y(x_line, y_south, railing_east_south_len, railing_east_top_z);
    railing_rail_y(x_line, y_south, railing_east_south_len, deck_top_z);

    // Norra kanten, från husväggen och österut
    translate([house_width, house_depth, base_z]) {
        rotate([0, 0, -90]) {
            railing_section_fit(north_len, railing_east_height, 0,
                                start_post = true, end_post = false);
        }
    }
    railing_rail_x(house_width, house_depth - railing_post_size, ext_width,
                   railing_east_top_z);
    railing_rail_x(house_width, house_depth - railing_post_size, ext_width,
                   deck_top_z);
}

// Räcke längs trappan, ett per sida. Handledaren följer trappans lutning
// medan 2x2 står lodrätt, från gånglinjen (nosningarnas linje) upp till
// handledarens undersida. Överst ansluter handledaren till terrassräckets
// stolpe, som redan står där och har rätt höjd.
// y_line = södra kanten på 2x2-linjen; 2x4 centreras över den som i övrigt.
module stair_east_railing(y_line) {
    x_top = house_width + ext_width;
    x_bot = x_top + stair_east_risers * stair_east_run;
    angle = atan(stair_east_rise / stair_east_run);
    rake  = sqrt(pow(x_bot - x_top, 2) + pow(deck_top_z, 2));

    // Nedre stolpe, står på marken
    translate([x_bot - railing_big_along, y_line - railing_big_offset, 0]) {
        cube([railing_big_along, railing_big_across,
              railing_height_low + railing_top_height]);
    }

    // Handledare längs lutningen. Roteras kring sin övre ände, så att
    // undersidan hela vägen ligger railing_height_low lodrätt över gånglinjen.
    translate([x_top, y_line - railing_big_offset,
               deck_top_z + railing_height_low]) {
        rotate([0, angle, 0]) {
            cube([rake, railing_big_across, railing_top_height]);
        }
    }

    // Stående 2x2 mellan terrassräckets stolpe och den nedre stolpen
    x0 = x_top + railing_big_offset;          // östra sidan av övre stolpen
    x1 = x_bot - railing_big_along;           // västra sidan av nedre stolpen
    clear = x1 - x0;
    n = rs_fit_small(clear, railing_gap_low);
    g = (clear - n * railing_post_size) / (n + 1);
    for (i = [0 : n - 1]) {
        x = x0 + g + i * (railing_post_size + g);
        z = deck_top_z - (x - x_top) * stair_east_rise / stair_east_run;
        translate([x, y_line, z]) {
            cube([railing_post_size, railing_post_size, railing_height_low]);
        }
    }
}

module stair_east_railings() {
    stair_east_railing(stair_east_y0);                       // södra sidan
    stair_east_railing(stair_east_y1 - railing_post_size);   // norra sidan
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
window_frame = [1, 1, 1];             // Vitmålad fönsterkarm
// door_white hör hemma här men definieras bland fönsterparametrarna, eftersom
// window_list refererar till den och filnivåns tilldelningar körs i ordning.

// === KOMPLETT MODELL ===
module complete_house() {
    color(organowood) house_walls();
    windows();
    color("darkgray") house_roof();
    color(organowood) house_east_ext();
    color("darkgray") house_east_ext_roof();
    color("lightblue", 0.5) porch();
    color("gray") porch_roof();
    color(organowood) deck();
    color(organowood) deck_east();
    color(burnt_wood) deck_east_roof();
    color("darkgray") deck_east_roof_sheet();
    color(organowood) stair_east();
    color(organowood) deck_to_porch();
    color(organowood) deck_south_edge();
    color(organowood) deck_step_1();
    color(organowood) deck_step_2();
    color(organowood) deck_risers();
    color(burnt_wood) railing_west();
    color(burnt_wood) railing_north();
    color(burnt_wood) railing_steps();
    color(burnt_wood) railing_bottom();
    color(burnt_wood) railing_deck_east();
    color(burnt_wood) stair_east_railings();
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
echo(str("Utbyggnad öst: ", ext_width, " x ", ext_depth, " m, vägghöjd ",
    roof_z(0), " m (syd) till ", roof_z(ext_depth), " m (norr)"));
echo(str("Terrass öst: ", ext_width, " x ", deck_east_len, " m, ", deck_east_count,
    " plankor, mellanrum ", deck_east_gap * 1000, " mm"));
echo(str("Tak över östra terrassen: ", deck_east_roof_width, " x ",
    deck_east_roof_y1 - deck_east_y0, " m, fall mot norr ", roof_angle, " grader"));
echo(str("  ovansida ", deck_east_roof_top_z(deck_east_y0), " m vid utbyggnaden till ",
    deck_east_roof_top_z(deck_east_roof_y1), " m i norra kanten"));
echo(str("  fri höjd över terrassen ",
    deck_east_roof_soffit_z(deck_east_roof_y1) - deck_top_z, " m i norra kanten"));
echo(str("  ", deck_east_roof_joists, " takreglar 2x6 á ", deck_east_roof_rake,
    " m, CC ", deck_east_roof_pitch * 1000, " mm"));
echo(str("  2 st 2x6 tvärs á ", deck_east_roof_width, " m (väggregel + bärlina)"));
echo(str("  takskiva ", deck_east_roof_sheet_t * 1000, " mm, ",
    deck_east_roof_width * deck_east_roof_rake, " m2 längs lutningen"));
echo(str("  stolpe ", deck_east_roof_post_size * 1000, " mm, längd ",
    deck_east_roof_soffit_z(deck_east_roof_y_post) - deck_east_roof_joist_h - deck_top_z,
    " m ovan terrassen"));
echo(str("Trappa öst: ", stair_east_treads, " plansteg á ", stair_east_boards,
    " st 2x8, bredd ", stair_east_width, " m"));
echo(str("  stigning ", stair_east_rise * 1000, " mm, steg ", stair_east_run * 1000,
    " mm, vinkel ", atan(stair_east_rise / stair_east_run), " grader"));
echo(str("  trappformeln 2h+b = ", stair_east_sum * 1000, " mm (ska ligga 600-640)"));
echo(str("  utsprång ", stair_east_treads * stair_east_run, " m österut"));
echo(str("Yttervägg: ", house_wall_thickness * 1000, " mm, bjälklag ",
    house_floor_thickness * 1000, " mm"));
echo(str("  färdigt golv ", house_floor_z, " m över mark, i liv med terrassen"));
echo(str("  bjälklag ", house_floor_z - house_floor_thickness, " till ",
    house_floor_z, " m, grund därunder"));

echo("=== FÖNSTER ===");
echo(str("Karm ", window_karm * 1000, " mm, spalt ", window_gap * 1000,
    " mm runt om, väggtjocklek ", house_wall_thickness * 1000, " mm"));
for (win = window_list)
    echo(str("  ", is_undef(win[5]) ? "Fönster" : win[5],
        " ", win[0], " vid ", win[1], " m, hålet ", round(win[2] * 1000),
        "-", round((win[2] + win[4]) * 1000), " mm ö golv:",
        "  hål ", round(win[3] * 1000), "x", round(win[4] * 1000),
        "  karmyttermått ", round(win_outer_w(win[3]) * 1000), "x",
        round(win_outer_h(win[4]) * 1000),
        "  glas ", round(win_glass_w(win[3]) * 1000), "x",
        round(win_glass_h(win[4]) * 1000), " mm"));

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

// Räcket på östra terrassen — alla tre sektionerna har samma stolplängd.
// Stolparna står på bottenregeln ovanpå däcket och går upp till handledaren,
// alltså kortare än i väster där de fortsätter ner under terrassen.
mat_len_east       = railing_east_height;
mat_east_north_len = ext_width - (railing_big_across - railing_big_offset);
mat_east_stub_bays = rs_fit_bays(railing_east_stub_len, true);
mat_east_side_bays = rs_fit_bays(railing_east_south_len, false);
mat_east_nort_bays = rs_fit_bays(mat_east_north_len, true);
// 2x2: antal fack gånger antal per fack
mat_east_2x2_count = mat_east_stub_bays * rs_fit_n(railing_east_stub_len, true)
    + mat_east_side_bays * rs_fit_n(railing_east_south_len, false)
    + mat_east_nort_bays * rs_fit_n(mat_east_north_len, true);
// 2x4: stumpen har stolpe i båda ändar. Östra kanten och norra bara i ena —
// hörnstolpen hör till östra kanten, och i söder tar takstolpen vid.
mat_east_2x4_count = (mat_east_stub_bays + 1) + mat_east_side_bays
    + mat_east_nort_bays;
mat_east_2x2_total = mat_east_2x2_count * mat_len_east;
mat_east_2x4_total = mat_east_2x4_count * mat_len_east;
// Handledare och bottenregel, en av varje per sektion
mat_east_rail_total = railing_east_stub_len + railing_east_south_len + ext_width;

// Trappräcket, en sektion per sida. Alla 2x2 är lika långa eftersom de står
// lodrätt mellan gånglinjen och den lutande handledaren.
mat_stair_x_top   = house_width + ext_width;
mat_stair_x_bot   = mat_stair_x_top + stair_east_risers * stair_east_run;
mat_stair_clear   = (mat_stair_x_bot - railing_big_along)
                  - (mat_stair_x_top + railing_big_offset);
mat_stair_2x2_per = rs_fit_small(mat_stair_clear, railing_gap_low);
mat_stair_2x2_count = 2 * mat_stair_2x2_per;
mat_stair_2x2_len   = railing_height_low;
mat_stair_2x2_total = mat_stair_2x2_count * mat_stair_2x2_len;
// Nedre stolpe per sida
mat_stair_post_len   = railing_height_low + railing_top_height;
mat_stair_post_total = 2 * mat_stair_post_len;
// Lutande handledare per sida
mat_stair_rail_len   = sqrt(pow(mat_stair_x_bot - mat_stair_x_top, 2)
                          + pow(deck_top_z, 2));
mat_stair_rail_total = 2 * mat_stair_rail_len;

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
    + mat_2x2_step_total + mat_east_2x2_total + mat_stair_2x2_total;

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
    + mat_2x4_step_count + mat_east_2x4_count + 2;
mat_2x4_posts_total = mat_2x4_low_total + mat_2x4_trans_total
    + mat_2x4_high_total + mat_2x4_north_total + mat_2x4_step_total
    + mat_east_2x4_total + mat_stair_post_total;

// Liggande handledare ovanpå räcket
mat_2x4_top_total = railing_west_low_len + railing_west_high_len + deck_total_width
    + mat_step_units * mat_step_rail + mat_east_rail_total + mat_stair_rail_total;

// Bottenregel: en genomgående per sida
mat_2x4_bottom_total = railing_bottom_west_len + deck_total_width
    + railing_east_bottom_len + mat_east_rail_total;

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
echo(str("Östra terrassen: ", mat_east_2x2_count, " st á ", mat_len_east,
    " m = ", mat_east_2x2_total, " m"));
echo(str("Trappräcket: ", mat_stair_2x2_count, " st á ", mat_stair_2x2_len,
    " m = ", mat_stair_2x2_total, " m"));
echo(str("TOTALT 2x2: ", mat_2x2_total, " m"));

echo("=== 2x4 ÅTGÅNG TILL RÄCKET ===");
echo(str("Väst låg: ", mat_2x4_low_count, " stolpar á ", mat_len_low_west, " m = ", mat_2x4_low_total, " m"));
echo(str("Övergång låg/hög: 1 stolpe á ", mat_len_high_west, " m"));
echo(str("Väst hög: ", mat_high_bays, " stolpar á ", mat_len_high_west, " m = ", mat_2x4_high_total, " m"));
echo(str("Norr: ", mat_north_bays, " stolpar á ", mat_len_high_north, " m = ", mat_2x4_north_total, " m"));
echo(str("Trappan: 2 st á ", mat_len_step_1, " m + 2 st á ", mat_len_step_2,
    " m + 1 st á ", mat_len_low_west, " m (östra toppnivån) = ", mat_2x4_step_total, " m"));
echo(str("Östra terrassen: ", mat_east_2x4_count, " stolpar á ", mat_len_east,
    " m = ", mat_east_2x4_total, " m"));
echo(str("Trappräcket: 2 stolpar á ", mat_stair_post_len, " m = ", mat_stair_post_total, " m"));
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
    [round(mat_len_east      * 1000), mat_east_2x2_count],
    [round(mat_2x2_high_len  * 1000), mat_2x2_high_count],
    [round(mat_2x2_north_len * 1000), mat_2x2_north_count],
    [round(mat_len_step_1    * 1000), 2 * mat_step_bays * railing_small_per_bay_step],
    [round(mat_len_step_2    * 1000), 2 * mat_step_bays * railing_small_per_bay_step],
    [round(mat_len_low_west  * 1000), mat_step_bays * railing_small_per_bay_step],
    [round(mat_stair_2x2_len * 1000), mat_stair_2x2_count]
];

kl_2x4_posts = [
    [round(mat_len_low_west   * 1000), mat_2x4_low_count],
    [round(mat_len_east       * 1000), mat_east_2x4_count],
    [round(mat_len_high_west  * 1000), 1 + mat_high_bays],  // övergångsstolpe + höga delen
    [round(mat_len_high_north * 1000), mat_north_bays],
    [round(mat_len_step_1     * 1000), 2 * mat_step_bays],
    [round(mat_len_step_2     * 1000), 2 * mat_step_bays],
    [round(mat_len_low_west   * 1000), mat_step_bays],
    [round(mat_stair_post_len * 1000), 2]
];

kl_2x4_rails = [
    [round(railing_west_low_len  * 1000), 1],
    [round(railing_west_high_len * 1000), 1],
    [round(deck_total_width      * 1000), 1],
    [round(mat_step_rail            * 1000), mat_step_units],
    [round(railing_east_stub_len    * 1000), 1],
    [round(railing_east_south_len   * 1000), 1],
    [round(ext_width                * 1000), 1],
    [round(mat_stair_rail_len       * 1000), 2]   // lutande, mätt längs lutningen
];

kl_2x4_bottom = [
    [round(railing_bottom_west_len  * 1000), 1],
    [round(deck_total_width         * 1000), 1],
    [round(railing_east_bottom_len  * 1000), 1],
    [round(railing_east_stub_len    * 1000), 1],
    [round(railing_east_south_len   * 1000), 1],
    [round(ext_width                * 1000), 1]
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

// === VIRKESÅTGÅNG I HELA LÄNGDER ===
// Kaplistan säger hur många bitar som behövs, men virket köps i hela längder.
// Här packas bitarna i så få längder som möjligt med "first fit decreasing":
// längsta biten först, ner i den första längden där den får plats, annars
// bryts en ny längd. Metoden är inte garanterat optimal, men ligger nära och
// är lätt att följa med kapsågen i handen.
//
// Bitar som är längre än en hel längd (de genomgående rakorna i väster) måste
// skarvas ändå och delas därför upp i hela längder plus en stump.

stock_len = 4.8;      // Längd på virket som köps in
saw_kerf  = 0.005;    // Sågsnitt, 5 mm

bp_stock = round(stock_len * 1000);
bp_kerf  = round(saw_kerf * 1000);

// En för lång bit blir hela längder plus resten
function bp_chunks(L) =
    L <= bp_stock ? [L] : concat([bp_stock], bp_chunks(L - bp_stock));

function bp_repeat(v, n) = n <= 0 ? [] : concat(v, bp_repeat(v, n - 1));

// Kaplistan [längd, antal] -> en post per bit
function bp_flat(items, i = 0, acc = []) =
    i >= len(items) ? acc
    : bp_flat(items, i + 1, concat(acc, bp_repeat(bp_chunks(items[i][0]), items[i][1])));

// Quicksort fallande. kl_sort_desc duger inte här — den tappar dubletter.
function bp_sort_desc(v) =
    len(v) <= 1 ? v
    : let(p = v[0])
      concat(bp_sort_desc([for (e = v) if (e > p) e]),
             [for (e = v) if (e == p) e],
             bp_sort_desc([for (e = v) if (e < p) e]));

// Ett fack är [kvar i mm, [bitar]]. Sågsnittet dras av tillsammans med biten,
// utom när biten går ut hela längden — då behövs inget snitt.
function bp_fit(bins, L, i = 0) =
    i >= len(bins) ? -1 : (bins[i][0] >= L ? i : bp_fit(bins, L, i + 1));

function bp_place(bins, L) =
    let(j = bp_fit(bins, L))
    j < 0
        ? concat(bins, [[bp_stock - min(L + bp_kerf, bp_stock), [L]]])
        : [for (i = [0 : len(bins) - 1])
              i == j ? [bins[i][0] - min(L + bp_kerf, bins[i][0]),
                        concat(bins[i][1], [L])]
                     : bins[i]];

function bp_pack(pieces, i = 0, bins = []) =
    i >= len(pieces) ? bins : bp_pack(pieces, i + 1, bp_place(bins, pieces[i]));

function bp_bins(items) = bp_pack(bp_sort_desc(bp_flat(items)));

// Identiska kapmönster slås ihop i utskriften. Mönstret jämförs som sträng.
function bp_join(v, i = 0) =
    i >= len(v) ? ""
    : str(v[i], i == len(v) - 1 ? "" : " + ", bp_join(v, i + 1));

function bp_uniq(v, i = 0, acc = []) =
    i >= len(v) ? acc
    : bp_uniq(v, i + 1, kl_has(acc, v[i]) ? acc : concat(acc, [v[i]]));

function bp_count(v, x) = kl_sum([for (e = v) e == x ? 1 : 0]);

module bp_report(name, items) {
    bins   = bp_bins(items);
    n      = len(bins);
    need   = kl_total_meters(items);
    bought = n * bp_stock / 1000;
    pats   = [for (b = bins) str(bp_join(b[1]), "   (rest ", b[0], " mm)")];

    echo(str("=== VIRKE I ", stock_len, " m-LÄNGDER: ", name, " ==="));
    for (p = bp_uniq(pats))
        echo(str("  ", bp_count(pats, p), " st: ", p));
    echo(str("  SUMMA: ", n, " st á ", stock_len, " m = ", bought, " m",
        ", varav ", bought - need, " m spill (",
        round(1000 * (bought - need) / bought) / 10, " %)"));
}

kl_2x4 = concat(kl_2x4_posts, kl_2x4_rails, kl_2x4_bottom);

bp_report("2x2 (50x50 mm)", kl_2x2);
bp_report("2x4 (50x100 mm)", kl_2x4);
