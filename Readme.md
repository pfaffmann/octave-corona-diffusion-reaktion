# Corona Modellierung mit Octave

##Installation

* Laden Sie sich dieses Repo herunter oder clonen Sie es.

## Nutzung

* Öffnen Sie "CoronaModell.m"
* Passen Sie gegebenenfalls Parameter an
* Führen Sie das Skript aus

## Parameter

* methode: wählt die Art der Diffusionskoeffizentenmatrix aus (linear, nicht-linear, stückweise stetig)
* Rasterlaenge: Legt das Untesuchungsraster in Metern fest (50 entspricht Rastergröße von 50m x 50m)
* maxTage: Wie lange soll die Berechnung maximal gehen
* delta_t: In welchen Zeitschritten soll gerechnet werden (0.05 bedeutet das ein Zeitschritt 72min bzw. 1/20 Tag dauert)
* global plotten: *true* -> Plots werden angefertig oder *false* -> keine Plots
* global speichern: *true* -> Plots werden gespeichert oder *false* -> werden nicht gespeichert
* global fileDir: Ordnerpfad zum speichern der Plots angeben
* BasisErkrankungsrate: std. Wert 0.33
* Wechselrate: std. Wert 1/14 (nach 14 Tagen wird ein Infizierter wieder gesund)
* c_0: Ausbreitungskoeffizient beschreibt die Ausbreitungsgeschwindigkeit
* B: *Dies ist die Ausgangsmatrix der Bevölkerungsdichte Raster 1km x 1km*
* k, c_1, c_2, B_0, a, Basiskoeffizientfaktor: können je nach Methode angepasst werden

## Berechnungsdauer
```javascript
while(sum(u_i_alt(:))*h^2 >= 0 && t*delta_t <= maxTage )
```
Diese while-Schleife legt die Berechnungdauer fest. Standartmäßig wird solange gerechnet bis entweder maxTage erreicht wurde oder die Summe der aktuell Infizierten kleiner als 0 ist <- wird nicht passieren.

<hr>
Viel Spaß beim Ausprobieren
