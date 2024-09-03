/* 1) Pasos al costado */

% jockey(Nombre, Altura, Peso).
jockey(valdivieso, 155, 52).
jockey(leguisamo,  161, 49).
jockey(lezcano,    149, 50).
jockey(baratucci,  153, 55).
jockey(falero,     157, 52).

%% CORRECCION -- armar un generador para evitar tantos _ en las consultas
jockey(NombreJockey) :- jockey(NombreJockey, _, _).

% caballo(Nombre).
caballo(botafogo).
caballo(oldMan).
caballo(energica).
caballo(matBoy).
caballo(yatasto).

% preferencia(NombreCaballo, NombreJockey).
preferencia(botafogo, NombreJockey) :-
    jockey(NombreJockey, _, Peso),
    Peso < 52.
preferencia(botafogo, baratucci).

preferencia(oldMan, NombreJockey) :-
    jockey(NombreJockey, _, _),
    atom_length(NombreJockey, CantidadLetras),
    CantidadLetras > 7.

preferencia(energica, NombreJockey) :-
    jockey(NombreJockey, _, _),
    not(preferencia(botafogo, NombreJockey)).

preferencia(matBoy, NombreJockey) :-
    jockey(NombreJockey, Altura, _),
    Altura > 170.    

%stud(NombreJockey, Caballeriza).
stud(valdivieso, elTute).
stud(falero,     elTute).
stud(lezcano,    lasHormigas).
stud(baratucci,  elCharabon).
stud(leguisamo,  elCharabon).

%premio(NombreCaballo, Premio).
premio(botafogo, granPremioNacional).
premio(botafogo, granPremioRepublica).
premio(oldMan,   granPremioRepublica).
premio(oldMan,   campeonatoPalermoDeOro).
premio(matBoy,   granPremioCriadores).

/* 
    No es necesario modelar que energica y yatasto no ganaron premios, o que a yatasto no le gusta ningún jockey, ya que el paradigma funcional se basa en el concepto de universo cerrado,
    es decir, todo lo que no exista en la base de conocimiento se supone falso.
*/

/* 2) Para mí, para vos */

% CORRECCION - Para buscar si hay más de un elemento que cumpla una condición, no hace falta usar findall, es preferible encontrar dos y que sean distintos (\=)

prefiereMasDeUnJockey(NombreCaballo) :-
    caballo(NombreCaballo),
    preferencia(NombreCaballo, Jockey),
    preferencia(NombreCaballo, OtroJockey),
    Jockey \= OtroJockey.

/* prefiereMasDeUnJockey(NombreCaballo) :-
    caballo(NombreCaballo),
    findall(
        NombreJockey,
        preferencia(NombreCaballo, NombreJockey),
        ListaPreferencias
    ),
    length(ListaPreferencias, CantidadPreferencias),
    CantidadPreferencias > 1. */
    
/* 3) No se llama Amor */

noPrefiereJockeyDe(NombreCaballo, Caballeriza) :-
    caballo(NombreCaballo), stud(_, Caballeriza),
    forall(
        preferencia(NombreCaballo, NombreJockey),
        not(stud(NombreJockey, Caballeriza))
    ).

/* 4) Piolines */

/* Queremos saber quiénes son les jockeys "piolines", que son las personas preferidas de todos los caballos que ganaron un premio importante. */

premioImportante(granPremioNacional).
premioImportante(granPremioRepublica).

piolin(NombreJockey) :-
    jockey(NombreJockey, _, _),
    forall(
        /* (premio(NombreCaballo, Premio),
        premioImportante(Premio)) */
        caballoImportante(NombreCaballo) ,
        preferencia(NombreCaballo, NombreJockey)
    ).

%CORRECCION - delegar el primer parámetro del forall
caballoImportante(NombreCaballo) :-
    premio(NombreCaballo, Premio),
    premioImportante(Premio).

/* 5) El jugador */

resultado(botafogo, 1).
resultado(oldMan,   2).
resultado(energica, 3).
resultado(matBoy,   4).
resultado(yatasto,  5).

apuesta(aGanador, Caballo) :-
    resultado(Caballo, 1).

apuesta(aSegundo, Caballo) :-
    resultado(Caballo, 1); 
    resultado(Caballo, 2).

apuesta(exacta, Caballo1, Caballo2) :-
    resultado(Caballo1, 1),
    resultado(Caballo2, 2).

apuesta(imperfecta, Caballo1, Caballo2) :-
    apuesta(exacta, Caballo1, Caballo2);
    apuesta(exacta, Caballo2, Caballo1).


/* 6) Los colores */

% CORRECCION - esta resolucion tiene complicaciones cuando se quiere filtrar por el color (tordo, alazan, etc.)

/* color(botafogo, tordo,    negro).
color(oldMan,   alazan,   marron).
color(energica, ratonero, gris).
color(energica, ratonero, negro).
color(matBoy,   palomino, marron).
color(matBoy,   palomino, blanco).
color(yatasto,  pinto,    blanco).
color(yatasto,  pinto,    marron).


preferenciaDe(Color, Caballos) :-
    findall(Caballo, color(Caballo, _, Color), ListaPorColor),
    combinar(ListaPorColor, Caballos).

combinar([], []).
combinar([Caballo|ColaCaballos], [Caballo|Caballos]) :-
    combinar(ColaCaballos, Caballos).
combinar([_|ColaCaballos], Caballos) :-
    combinar(ColaCaballos, Caballos).
 */


color(tordo).
color(alazan).
color(ratonero).
color(palomino).
color(pinto).

tonalidades(tordo,    negro).
tonalidades(alazan,   marron).
tonalidades(ratonero, gris).
tonalidades(ratonero, negro).
tonalidades(palomino, marron).
tonalidades(palomino, negro).
tonalidades(pinto,    blanco).
tonalidades(pinto,    marron).

caballoDeColor(botafogo, tordo).
caballoDeColor(oldMan, alazan).
caballoDeColor(energica, ratonero).
caballoDeColor(matBoy, palomino).
caballoDeColor(yatasto, pinto).


preferenciaDe(Color, Caballos) :-  % FILTRA POR COLOR TORDO, ALAZAN, RATONERO, PALOMINO, PINTO
    color(Color),
    findall(Caballo, caballoDeColor(Caballo, Color), CaballosDeColor),
    combinar(CaballosDeColor, Caballos).

preferenciaDe(Tono, Caballos) :- % FILTRA POR COLOR NEGRO, MARRON, GRIS, BLANCO
    not(color(Tono)),
    findall(Caballo, tieneTonalidad(Caballo, Tono), CaballosDeColor),
    combinar(CaballosDeColor, Caballos).

tieneTonalidad(Caballo, Tono) :-
    caballoDeColor(Caballo, Color),
    tonalidades(Color, Tono).
    

combinar([], []).

combinar([ Caballo | ColaCaballos ], [ Caballo | Caballos ]) :-  % incluye el primer elemento
    combinar(ColaCaballos, Caballos).

combinar([ _ | ColaCaballos ], Caballos) :- % omite el primer elemento
    combinar(ColaCaballos, Caballos).

/* 
[botafogo, energica, matBoy]

Caballos = [botafogo, energica, matBoy] ;
Caballos = [botafogo, energica] ;
Caballos = [botafogo, matBoy] ;
Caballos = [botafogo] ;
Caballos = [energica, matBoy] ;
Caballos = [energica] ;
Caballos = [matBoy] ;
Caballos = [].


PRIMERA COMBINACION

Caballos = [ Caballos3 | Caballos2 | Caballos1 | Caballos ]

1)  combinar([botafogo, energica, matBoy], Caballos) -> Caballos = [botafogo | Caballos1] = [botafogo, energica, matBoy]
    Caballo       = botafogo

2)  combinar([energica, matBoy], Caballos1) -> Caballos1 = [energica | Caballos2] = [energica, matBoy]
    Caballo       = energica

3) combinar([matBoy], Caballos2) -> Caballos2 = [matBoy | Caballos3] = [matBoy]
    Caballo       = matBoy

4) combinar([], Caballos3) -> Caballos3 = [] vuelve al paso 3


SEGUNDA COMBINACION

Caballos = [ Caballos2 | Caballos1 | Caballos ]

1)  combinar([botafogo, energica], Caballos) -> Caballos = [botafogo | Caballos1] = [botafogo, energica]
    Caballo       = botafogo

2)  combinar([energica], Caballos1) -> Caballos1 = [energica | Caballos2] = [energica]
    Caballo       = energica

3) combinar([], Caballos2) -> Caballos2 = [] vuelve al paso 2


TERCERA COMBINACION

Caballos = [ Caballos2 | Caballos1 | Caballos ]

1)  combinar([botafogo, matBoy], Caballos) -> Caballos = [botafogo | Caballos1] = [botafogo, matBoy]
    Caballo       = botafogo

2)  combinar([matBoy], Caballos1) -> Caballos1 = [matBoy | Caballos2] = [matBoy]
    Caballo       = matBoy

3) combinar([], Caballos2) -> Caballos2 = [] vuelve al paso 2


CUARTA COMBINACION

Caballos = [ Caballos1 | Caballos ]

1)  combinar([botafogo], Caballos) -> Caballos = [botafogo | Caballos1] = [botafogo]
    Caballo       = botafogo

2) combinar([], Caballos1) -> Caballos1 = [] vuelve al paso 1


QUINTA COMBINACION

Caballos = [ Caballos2 | Caballos1 | Caballos ]

1)  combinar([energica, matBoy], Caballos) -> Caballos = [energica | Caballos1] = [energica, matBoy]
    Caballo       = energica

2)  combinar([matBoy], Caballos1) -> Caballos1 = [matBoy | Caballos2] = [matBoy]
    Caballo       = matBoy

3) combinar([], Caballos2) -> Caballos2 = [] vuelve al paso 2


SEXTA COMBINACION

Caballos = [ Caballos1 | Caballos ]

1)  combinar([energica], Caballos) -> Caballos = [energica | Caballos1] = [energica]
    Caballo       = energica

2) combinar([], Caballos1) -> Caballos1 = [] vuelve al paso 1


SEPTIMA COMBINACION

Caballos = [ Caballos1 | Caballos ]

1)  combinar([matBoy], Caballos) -> Caballos = [matBoy | Caballos1] = [matBoy]
    Caballo       = matBoy

2) combinar([], Caballos1) -> Caballos1 = [] vuelve al paso 1


OCTAVA COMBINACION

Caballos = [ Caballos1 | Caballos ]

1)  combinar([],  []) -> Caballos = [] = []

 */