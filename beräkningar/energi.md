# Energi- och Värmeförlustberäkningar för Byggnad

Detta dokument beskriver hur man kan beräkna värmeförluster och energiutgifter för en byggnad baserat på olika byggkomponenters U-värden, samt värmeförluster genom ventilation. Beräkningarna tar hänsyn till byggnadens olika ytor, volym, temperaturdifferenser och ventilationsflöde. Slutresultatet används för att uppskatta byggnadens primärenergifaktor (EPpet).

## Parametrar och Inledande Definiering

Först definieras de parametrar som behövs för att beräkna värmeförlusterna och den totala energiåtgången för byggnaden.

- **Boarea**: 80 m².
- **U-värden**:
  - Väggar: 0.131 W/m²K
  - Tak: 0.097 W/m²K
  - Golv: 0.105 W/m²K
  - Dörrar: 1.1 W/m²K
  - Fönster: 0.9 W/m²K

### Temperaturer och Temperaturdifferens

För att kunna beräkna temperaturdifferensen som används för att beräkna värmeförlusterna:

- **Inomhustemperatur**: 18°C
- **Årsmedeltemperatur utomhus**: 5.7°C
- **Temperaturdifferens**:  
  Temperaturdifferensen (delta_t) = 18°C - 5.7°C = 12.3°C

Temperaturdifferensen används som en grund för att räkna ut värmeförluster genom byggnadens olika delar.

### Ytor på Byggnaden

Ytorna på byggnadens olika komponenter definieras så här:

- **Väggyta**: 123 m²
- **Takyta**: 80 m²
- **Golvyta**: 80 m²
- **Dörryta**: 4 m²
- **Fönsteryta**: 12 m²

Dessa ytor används i beräkningarna för att avgöra hur mycket värme som går förlorad genom varje byggdel.

### Volym och Luftflöde

Volymen av byggnaden och ventilationsflödet definieras:

- **Volym av byggnaden**: 300 m³
- **Ventilationsflöde**: 0.35 l/s, vilket omvandlas till 1.26 m³/h (genom att multiplicera med 3.6)

Ventilationsflödet tas med i beräkningarna för att räkna ut värmeförluster genom luftomsättning.

### Värmeförluster genom Byggnadens Komponenter

Nu gör vi beräkningar för värmeförluster genom byggnadens olika delar:

#### Värmeförluster genom Väggar, Tak och Golv

Värmeförluster genom väggar, tak och golv beräknas med hjälp av temperaturdifferensen, U-värdena och ytorna för respektive byggdel:

`q_byggnad = delta_t * (u_vagg * yta_vagg + u_tak * yta_tak + u_golv * yta_golv)`

#### Värmeförluster genom Dörrar och Fönster

För dörrar och fönster beräknas värmeförluster på samma sätt:

`q_dorr_fonster = delta_t * (u_dorr * yta_dorr + u_fonster * yta_fonster)`

#### Värmeförluster genom Ventilation

För ventilationsförluster görs en beräkning baserad på byggnadens volym, ventilationsflödet och temperaturdifferensen:

`q_ventilation = volym_byggnad * ventilation_omsattning_m3_h * delta_t * 0.33`

Här används en konstant faktor (0.33) som är en uppskattning för luftens värmeöverföring.

### Total Värmeförlust

Den totala värmeförlusten beräknas genom att summera alla värmeförluster från byggnadens komponenter och ventilation:

`q_totalt = q_byggnad + q_dorr_fonster + q_ventilation`

### Primärenergifaktor och EPpet

För att beräkna byggnadens primärenergifaktor (EPpet) används en primärenergifaktor för ved (1,2):

- **Primärenergifaktor för ved**: 1.2  
  (Denna faktor används för att justera värmeförlusten till primärenergi.)

Den slutliga beräkningen av primärenergifaktorn per boarea `EP_pet` är:

`EP_pet = q_totalt * vedfaktor / atemp`

### Resultat

Efter att ha gjort alla beräkningar kommer här de slutgiltiga resultaten:

- **Total värmeförlust** (q_totalt): Detta är summan av värmeförluster genom väggar, tak, golv, dörrar, fönster och ventilation.
- **Primärenergifaktor (EPpet)**: Detta ger en uppskattning av byggnadens energieffektivitet, justerad för vedens primärenergifaktor.

## Slutsats

Genom att förstå och beräkna dessa olika komponenter kan vi bättre bedöma en byggnads energieffektivitet och förstå de faktorer som påverkar den totala energiåtgången för uppvärmning. Detta kan hjälpa till att göra informerade val när det gäller byggmaterial och energibesparande åtgärder för att minimera energiförbrukningen.
