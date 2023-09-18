/***********************************************************************
 *
 * PROJECT:       Raycast
 * FILE:          globals.h
 *
 * AUTHOR:        Marcus Gr”ber
 *
 ***********************************************************************/
//
// Globals.h
// Projekt-Raycast
// (C)1995 by Stefan Becker
//

#ifndef	GLOBALS_H
#define GLOBALS_H               // Pr„prozessor-Flagge gegen doppelte Verwendung

//
// Konstanten:
//

#define         TURN_LEFT               'a'     // Tasten, die fr Aktion gedrckt werden mssen
#define		TURN_RIGHT		'd'	// rechtsherum drehen
#define         WALK_FORW               'w'     // vorw„rts laufen
#define         WALK_BACKW              's'     // rckw„rts laufen

#define         TURN_INC                30      // Winkel„nderung beim Drehen des Spielers
#define         WALK_INC                30      // L„nge eines "Spieler-Schrittes"

#define         MAZE_X                  16      // Gr”áe des begehbaren Spielfeldes
#define		MAZE_Y			16	// 16x16 Felder

#define         TEX_SIZE                128     // Gr”áe der quadratischen Textur in Pixeln
#define         TEX_SHIFT               7       // lg2(TEX_SIZE)

#define         MAZE_MAX_X              (MAZE_X * TEX_SIZE)     // Gr”áte X-Position in Pixeln
#define         MAZE_MAX_Y              (MAZE_Y * TEX_SIZE)     // Gr”áte Y-Position in Pixeln

#define         XAUF                    240     // Gr”áe der im Fenster erzeugten Grafik in Pixeln
#define         YAUF                    200

#define		BLICK_WINKEL	60	// Blickwinkel der Person in Grad

#define         ANZ_WINKEL              ((360/BLICK_WINKEL)*XAUF) // So viele Drehwinkel gibt es

#define		TEXTURE_DEPTH	8	// Bit/Pixel der Textur

#define         EPSILON                 1.0E-8  // Schranke fr unscharfen Null-Test

#define		MAX_SICHT		10000	// Maximale Sichtweite

#define         PERSPEKTIVE             25000   // Wie groá sind Objekte in welcher Entfernung?

//
// Makros:
//
#define	ABS(x)		(((x)>=0) ? (x) : (-(x)))	// Standard-Abs-Makro
#define MIN(x,y)        (((x)<=(y)) ? (x) : (y))        // Standard-Min-Makro
#define MAX(x,y)        (((x)>=(y)) ? (x) : (y))        // Standard-Max-Makro

//
// Typen:
//

typedef char    MAZE[MAZE_X][MAZE_Y];   // Typ einer begehbaren Landschaft
										// (+1 wegen String-Terminierung)
typedef WWFixedAsDWord WINKEL_TAB[ANZ_WINKEL];
                                        // Typ einer Winkel-Tabelle
typedef WWFixedAsDWord SKIP_TAB[ANZ_WINKEL];
                                        // Typ einer Skip-Tabelle

extern WINKEL_TAB  x_winkel_tab,
                   y_winkel_tab;
extern MAZE        maze;

#endif                                  // Ende des Pr„prozessor-If

//
// Globals.h
//
