# Geo Raycast - a three-dimensional graphics demo

Based on the program "Labyrint" by Stefan Becker, published in c't 2/96

Adapted for Geos by Marcus Groeber 1996

This is my first program for Geos designed specifically with the OmniGo in
mind. I wrote it to get an estimate of how feasible a game with Doom-like
"first person" graphics would be on an 8086-based PDA like the OGo. This may
sound crazy at first, but it isn't that far fetched, keeping in mind that the
loss in cpu horsepower is partly compensated for by the reduction in screen
size and colors. [This doesn't mean that Raycast won't run on the desktop
version of Ensemble as well, it is just meant as an excuse for the unusual
restrictions placed on the display of the graphics.]

Nevertheless, a redraw rate of under 1 frame per second as achieved by this
program on an OmniGo is probably not acceptable for a fast-paced action game.
:-) Anyway, you can still use this program for a little walking exercise in a
maze of texture-mapped walls and to show that your brand-new OmniGo can be
used for other things than for storing appointments and phone numbers.

To install the program, just copy raycast.geo to the WORLD directory of your
Geos set-up (if you're using an OmniGo, you will have to employ some kind of
file-transfer software to do this, of course).

Usage is fairly straightforward: the menu bar items "Left/Right/Go" probably
speak for themselves, while the "?" menu contains an option to toggle between
a "view" and a "map" mode and a "Look" command to cause a 360-degree turn
consisting of 32 individual pictures. This full turn can be used to compare
the speed of the program on different machines - when compiled in EC mode, the
program adds a status bar to the bottom of the window showing the average time
required to calculate and draw one frame (making the window to big to fit onto
a regular OmniGo screen). It should be noted that the drawing speed decreases
somewhat when the player is looking at a wall that is very close.

The "raycasting engine" in render.goc is an adapted and streamlined version of
the code published in an article on that subject in the German "c't" magazine
(issue 2/96) - I have mainly replaced all the Macintosh-specific parts,
written an ESP-optimized texture-mapping routine and converted the entire
algorithm to Geos 16/16 "WWFixed" fixed-point arithmetics, which alone yielded
a factor 35 (!) improvement over the original floating-point based code on my
386/40 (no additional fpu).

Most of the comments in the code are still in German because I have taken them
from the original version with little modifications. If you would like to know
about a particular detail, just drop me a mail...

## German

Dies ist mein erstes Geos-Programm, das speziell im Hinblick auf den OmniGo
entwickelt worden ist. Sein Hauptzweck war, einen Eindrukc davon zu bekomme,
wie realistisch ein Spiel mit Doom-ähnlicher "subjektiver Kamera" auf einem
8086-PDA ist. Das ist nicht ganz so verrückt wie es auf den ersten Anschein
klingen mag, wenn man bedenkt, daß die mangelnde CPU-Leistung zumindest
teilweise durch den kleineren Bildschirm und die fehlende Farbigkeit
ausgeglichen wird. [Das bedeutet aber nicht, daß Raycast nicht auch auf dem
Desktop läuft - allerdings sollte sich auch niemand beschweren, daß es dort
nicht bunter ist...]

Es scheint jedoch so, als ob eine Rate von weniger als einem Bild pro Sekunde
für ein packendes Action-Spiel etwas zu niedrig ist... immerhin kann man mit
dem Programm aber schon durch ein Labyrint mit gemusterten Wänden traben und
außerdem auch noch beweisen, daß ein OmniGo doch zu mehr zu gebrauchen ist als
ein ledergebundener Terminplaner.

Um das Programm zu installieren, muß die Datei raycast.geo einfach ins
WORLD-Verzeichnis von Geos kopiert werden. (Auf einem OmniGo muß man dazu
natürlich irgendeine Art von Dateitransfer-Programm verwenden.)

Die Verwendung der Menüpunkte "Left/Right/Go" muß wohl nicht besonders erklärt
werden. Das "?"-Menü enthält eine Umschaltmöglichkeit zwischen Sicht- und
Kartenmodus und einen Menüpunkt "Look", der den Spieler einmal um die eigene
Achse dreht, wodurch insgesamt 32 Einzelbilder erzeugt werden. Diese Drehung
kann zum Geschwindigkeitsvergleich des Programms auf verschiedenen Rechnern
verwendet werden - wird das Programm als EC-Version übersetzt, enthält das
Fenster zusätzlich eine Statuszeile am unteren Rand, in der die mittlere Zeit
für das Berechnen und Zeichnen eines Bildes angegeben wird (dadurch wird das
Fenster zu groß für den OmniGo-Bildschirm). Zu beachten ist, daß Wände, die
sehr nahe vor den "Augen" der Spielfigur liegen, zu einer Verlangsamung des
Programms führen können.

Der eigentliche Raycasting-Code in render.goc ist eine angepaßte und
überarbeitete Version des Programms, das in der Ausgabe c't 2/96 veröffentlich
worden ist - für nähere Informationen zum Algorithmus sei auf dieses Heft
verwiesen. Ich habe für diese Version vor allem die Macintosh-spezifischen
Teile ersetzt, die Skalierung des Wandmusters in ESP-Assembler realisiert und
den Algorithmus auf Geos-typische 16/16 "WWFixed" Festkomma-Arithmetik
umgestellt. Allein der letzte Punkt ist für eine Geschwindigkeitssteigerung um
den Faktor 35 (!) auf meinem 386/40 (ohne Coprozessor) verantwortlich.


