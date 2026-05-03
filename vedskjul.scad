// Vedskjul — skiss
// Enheter: meter
// Koordinatsystem: +x = öster, +y = norr, +z = upp.
// Vedskjulets långsida löper öst/väst (längs x).

// === Parametrar ===
// Bottenyta (ytterkant, inklusive golvreglarnas utstick i norr/söder)
section_length = 1.5;  // längd per sektion (m)
sections      = 6;     // antal sektioner längs långsidan
base_length   = sections * section_length;  // total längd (m)
base_width    = 1.5;   // djup (m)

// Höjd och tak
wall_height   = 2.4;   // höjd från bottenramens underkant till stolparnas ovankant (m)
roof_angle    = 3;     // takvinkel i grader (pulpet-tak, lutar söderut)
overhang      = 0.3;   // takutsprång (m) runt om
// Antalet sparrar = sections + 1 (en vid varje sektionsgräns — ändarna
// hamnar över V-hörnen, de inre över T-stammarna).

// 2-tum-8 (45 x 195 mm)
beam_t = 0.045; // tjocklek
beam_w = 0.195; // bredd

// Golvreglar (liggande 2x8 N-S)
joist_gap      = 0.02;  // mellanrum mellan reglarna (m)
joist_overhang = 0.05;  // utstick i norr respektive söder (m)

// Härledda mått
base_frame_depth = base_width - 2*joist_overhang; // bottenramens djup N-S

// === Hjälpmoduler ===

// Kanonisk 2x8-bit för virkeslistan. Ritar kub i standardorientering
// (på högkant, längd längs +x) och skriver en rad på formen
//   ECHO: "CUT", <desc>, <längd i m>
// som kan parsas fram ur openscad-körningens stderr:
//   openscad -o /dev/null vedskjul.scad 2>&1 \
//     | awk -F'"' '$2=="CUT"{print}'
// Callers sätter color och roterar/translaterar till rätt placering.
module tum2x8(length, desc = "2x8") {
    echo("CUT", desc, length);
    cube([length, beam_t, beam_w]);
}

// === Ramfyrkant ===
// Fyrkant av 2x8:or som står på högkant (195 mm vertikalt).
// Djupet (N-S) är mindre än base_width så att golvreglarna kan
// sticka ut joist_overhang i både norr och söder. Används som
// bottenram och som övre ram (grund för taket).
module rect_frame(l, d) {
    color("burlywood") {
        // södra långsidan (längs +x)
        tum2x8(l, "ram-lång");
        // norra långsidan
        translate([0, d - beam_t, 0]) tum2x8(l, "ram-lång");
        // västra kortsidan (längs +y, inpassad mellan långsidorna)
        translate([beam_t, beam_t, 0]) rotate([0, 0, 90])
            tum2x8(d - 2*beam_t, "ram-kort");
        // östra kortsidan
        translate([l, beam_t, 0]) rotate([0, 0, 90])
            tum2x8(d - 2*beam_t, "ram-kort");
    }
}

// === Golvreglar ===
// 2x8 liggande flatt (45 mm höjd, 195 mm bredd), riktade N-S.
// Placeras ovanpå bottenramen och sticker ut joist_overhang i norr/söder.
// Mellan reglarna är det joist_gap luft.
module floor_joists() {
    pitch = beam_w + joist_gap;
    n = floor((base_length + joist_gap) / pitch);
    used = n*beam_w + (n - 1)*joist_gap;
    margin = (base_length - used) / 2;
    z = beam_w; // ligger ovanpå bottenramen
    // liggande flatt, längd längs +y: cyklisk axelpermutation x→y→z→x via
    // rotate(120, [1,1,1]) ger cube([beam_w, length, beam_t]).
    color("sandybrown")
    for (i = [0 : n - 1]) {
        x = margin + i*pitch;
        translate([x, -joist_overhang, z])
        rotate(120, [1, 1, 1])
        tum2x8(base_width, "golvregel");
    }
    echo("antal golvreglar", n);
    echo("marginal i öst/väst", margin, "m");
}

// === Stolpar ===
// Stående 2x8-reglar från bottenramens överkant och upp till rätt höjd
// under sparren. Eftersom taket lutar är posterna på norra (höga) sidan
// högre än de på södra. Varje stolpes topp justeras så att sparrens
// underkant precis träffar stolpens sydkant — sparren vilar då på
// stolpens sydkant och sluttar upp norrut.
post_z      = beam_w;                      // stolpen står ovanpå bottenramen
post_height = wall_height - post_z;        // default: topp på z = wall_height

// Höjd för en stolpe vars södra kant ligger vid y = y_s. Toppen hamnar
// vid sparrens underkant-höjd för just det y.
function post_h_at(y_s) = post_height + y_s * tan(roof_angle);

module post(x, y, dx, dy, h = post_height) {
    color("peru")
    translate([x, y, post_z])
    if (dx > dy)
        // 195 mm längs x, 45 mm längs y: rotera tum2x8 runt y-axeln.
        translate([0, 0, h]) rotate([0, 90, 0])
        tum2x8(h, "stolpe");
    else
        // 45 mm längs x, 195 mm längs y: cyklisk permutation åt andra hållet.
        rotate(-120, [1, 1, 1])
        tum2x8(h, "stolpe");
}

// Hörn: två reglar i 90° (V/L i plan) — en längs långsidan, en längs kortsidan.
// Varje hörn får 195 mm "bredd-mot-väggen" på båda väggarna som möts.
// Höjden per stolpe beräknas från dess sydkant (y_s) så att toppen följer
// sparrens underkant.
module corner_posts(d) {
    // SV
    post(0,                  0,                   beam_w, beam_t, post_h_at(0));
    post(0,                  beam_t,              beam_t, beam_w, post_h_at(beam_t));
    // SÖ
    post(base_length-beam_w, 0,                   beam_w, beam_t, post_h_at(0));
    post(base_length-beam_t, beam_t,              beam_t, beam_w, post_h_at(beam_t));
    // NV
    post(0,                  d - beam_t,          beam_w, beam_t, post_h_at(d - beam_t));
    post(0,                  d - beam_t - beam_w, beam_t, beam_w, post_h_at(d - beam_t - beam_w));
    // NÖ
    post(base_length-beam_w, d - beam_t,          beam_w, beam_t, post_h_at(d - beam_t));
    post(base_length-beam_t, d - beam_t - beam_w, beam_t, beam_w, post_h_at(d - beam_t - beam_w));
}

// Sektionsavdelare: T-formation på både södra och norra långsidan vid varje
// inre sektionsgräns. "Toppen" på T:et ligger parallellt med långsidan (mot
// väggen), "stammen" sticker in vinkelrätt mot mitten av skjulet. Höjder
// anpassas så att ovankanten möter sparrens underkant.
module section_posts(d) {
    for (i = [1 : sections - 1]) {
        x = i * base_length / sections;
        // Söder: bas längs södra väggen, stam norrut.
        post(x - beam_w/2,  0,                   beam_w, beam_t, post_h_at(0));
        post(x - beam_t/2,  beam_t,              beam_t, beam_w, post_h_at(beam_t));
        // Norr: bas längs norra väggen, stam söderut.
        post(x - beam_w/2,  d - beam_t,          beam_w, beam_t, post_h_at(d - beam_t));
        post(x - beam_t/2,  d - beam_t - beam_w, beam_t, beam_w, post_h_at(d - beam_t - beam_w));
    }
}

// === Takreglar ===
// 2x8 på högkant, riktade N-S. En sparre per sektionsgräns — ändsparrarna
// vilar på V-hörnens västra/östra stolpe, de inre på T-stammarna.
// Lutar söderut med roof_angle grader, pivot vid (x, 0, wall_height).

// Geometri för en enstaka sparre (enbart formen), x = västra kanten.
module rafter_at(x, desc = "sparre") {
    h_total = base_frame_depth + 2*overhang;
    r_len   = h_total / cos(roof_angle);
    // Standardorienterad tum2x8 (längd längs +x) roteras 90° runt z så
    // längden hamnar längs +y; sedan tiltas hela ramen roof_angle runt x.
    translate([x, 0, wall_height])
    rotate([roof_angle, 0, 0])
    translate([beam_t, -overhang, 0])
    rotate([0, 0, 90])
    tum2x8(r_len, desc);
}

// x-positioner (vänsterkant) för alla sparrar. Ändsparrarna ligger
// flush mot öst/väst-kanten (över V-hörnets kortside-stolpe). De
// mellanliggande centreras över T-stammen vid varje sektionsgräns.
function rafter_xs() = concat(
    [0],
    [for (i = [1 : sections - 1]) i * base_length / sections - beam_t/2],
    [base_length - beam_t]
);

module rafters_geom() {
    for (x = rafter_xs())
        rafter_at(x);
}

module rafters() {
    color("saddlebrown") rafters_geom();
    echo("antal takreglar", len(rafter_xs()));
    echo("sparrlängd", (base_frame_depth + 2*overhang) / cos(roof_angle), "m");
}

// Gavelsparrar i öst och väst — en sparre vid vardera gavelns
// ytterkant, förskjuten med overhang utanför bottenytan (samma avstånd
// som takutsprånget i N/S). De följer samma profil och lutning som
// övriga sparrar.
module gable_rafters() {
    color("saddlebrown") {
        rafter_at(-overhang, "gavel-sparre");                         // väst
        rafter_at(base_length + overhang - beam_t, "gavel-sparre");   // öst
    }
}

// Takkant (fascia) i söder och norr — 2x8 på högkant som löper längs
// hela takets bredd (väst till öst gavel). Följer takets lutning så
// att ovankanten är koplanär med sparrarnas ovankant och bildar en
// jämn platform för takskivan. Dess insida ligger kant-i-kant mot
// sparrarnas ändträ och döljer det.
module roof_fascia() {
    h_total = base_frame_depth + 2*overhang;
    r_len   = h_total / cos(roof_angle);
    fx0     = -overhang;
    flen    = base_length + 2*overhang;
    // Fascia har exakt tum2x8:s standardorientering (längd längs +x).
    color("burlywood") {
        // Söder
        translate([0, 0, wall_height])
        rotate([roof_angle, 0, 0])
        translate([fx0, -overhang - beam_t, 0])
        tum2x8(flen, "takkant");
        // Norr
        translate([0, 0, wall_height])
        rotate([roof_angle, 0, 0])
        translate([fx0, -overhang + r_len, 0])
        tum2x8(flen, "takkant");
    }
}

// === Rendering ===
// Bottenram
rect_frame(base_length, base_frame_depth);
// Golvreglar ovanpå bottenramen
floor_joists();
// Stolpar (V i hörnen, T vid sektionsgränserna) — går upp till wall_height
corner_posts(base_frame_depth);
section_posts(base_frame_depth);
// Takreglar (en per sektionsgräns, vilar på V eller T) + gavelsparrar + takkant
rafters();
gable_rafters();
roof_fascia();

// === Info ===
echo("bottenyta (ytterkant)", base_length * base_width, "m2");
echo("bottenramens djup", base_frame_depth, "m");
echo("sektionslängd", base_length / sections, "m");
echo("norra takhöjd", wall_height + base_frame_depth * tan(roof_angle), "m");
echo("golvhöjd (över mark)", beam_w + beam_t, "m");
echo("fri höjd front (södra)", wall_height - (beam_w + beam_t), "m");
echo("fri höjd bak (norra)", wall_height + base_frame_depth * tan(roof_angle) - (beam_w + beam_t), "m");
