/* 1) Pasos al costado */

% jockey(Nombre, Altura, Peso).
jockey(valdivieso, 155, 52).
jockey(leguisamo,  161, 49).
jockey(lezcano,    149, 50).
jockey(baratucci,  153, 55).
jockey(falero,     157, 52).

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

prefierenMasDeUnJockey(NombreCaballo) :-
    caballo(NombreCaballo),
    findall(
        NombreJockey,
        preferencia(NombreCaballo, NombreJockey),
        ListaPreferencias
    ),
    length(ListaPreferencias, CantidadPreferencias),
    CantidadPreferencias > 1.
    
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
        (premio(NombreCaballo, Premio),
        premioImportante(Premio)),
        preferencia(NombreCaballo, NombreJockey)
    ).

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
    (resultado(Caballo1, 1), resultado(Caballo2, 2));
    (resultado(Caballo2, 1), resultado(Caballo1, 2)).


/* 6) Los colores */

color(botafogo, tordo,    negro).
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
