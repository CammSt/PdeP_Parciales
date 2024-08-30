
responsable(dodain).
responsable(lucas).
responsable(juanC).
responsable(juanFdS).
responsable(leoC).
responsable(martu).

responsable(vale).
responsable(maiu).

horario(dodain,  lunes,      9, 15).
horario(dodain,  miercoles,  9, 15).
horario(dodain,  viernes,    9, 15).
horario(lucas,   martes,    10, 20).
horario(juanC,   sabados,   18, 22).
horario(juanC,   domingos,  18, 22).
horario(juanFdS, jueves,    10, 20).
horario(juanFdS, viernes,   12, 20).
horario(leoC,    lunes,     14, 18).
horario(leoC,    miercoles, 14, 18).
horario(martu,   miercoles, 23, 24).

/* 1) Calentando motores  */
/* (a) vale atiende los mismos días y horarios que dodain y juanC. */

horario(vale, Dia, Inicio, Final) :- 
    horario(dodain, Dia, Inicio, Final).

horario(vale, Dia, Inicio, Final) :- 
    horario(juanC, Dia, Inicio, Final).

/* (b) nadie hace el mismo horario que leoC*/
/* No es necesario plantear una cláusula para este caso ya que el paradigma lógico se basa en el planteo de universo cerrado,
es decir, cualquier cosa que no se especifique dentro de la base de conocimiento se considera falsa. Entonces si no hay ningún hecho que
relacione un responsable con el horario de juanC, se supone que nadie tiene el mismo horario que él. */

/* (c) maiu está pensando si hace el horario de 0 a 8 los martes y miércoles */
/* horario(maiu, martes, 0, 8).
horario(maiu, miercoles, 0, 8). */

/* No haría falta incluir esta información de maiu porque lo está pensando, y se considera lo desconocido como falso, como se explicó previamente. */

/* 2) Quién atiende el kiosko  */
atiende(Persona, Dia, Hora) :-
    horario(Persona, Dia, Inicio, Final),
    between(Inicio, Final, Hora).


/* 3) Forever alone */
foreverAlone(Persona, Dia, Horario) :-
    atiende(Persona, Dia, Horario),
    not( (atiende(OtraPersona, Dia, Horario), Persona \= OtraPersona) ).

/* 4) Posibilidades de atención */
/* Dado un día, queremos relacionar qué personas podrían estar atendiendo el kiosko en algún momento de ese día */

/* RESOLUCION -- NO ME SALIO */
/* puedenAtender(Dia, Personas):-
    findall(Persona, distinct(Persona, atiende(Persona, Dia, _)), PersonasPosibles),
    combinar(PersonasPosibles, Personas).
  
  combinar([], []).
  combinar([Persona|PersonasPosibles], [Persona|Personas]):-combinar(PersonasPosibles, Personas).
  combinar([_|PersonasPosibles], Personas):-combinar(PersonasPosibles, Personas). */


/* 5) Ventas / suertudas */

venta(dodain, fecha(lunes, 10, 8),      [golosinas(1200), cigarrillos(jockey), golosinas(50)]).
venta(dodain, fecha(miercoles, 12, 8),  [bebidas(alcoholicas, 8), bebidas(noAlcoholica, 1), golosinas(10)]).
venta(martu,  fecha(miercoles, 12, 8),  [golosinas(1000), cigarrillos(chesterfield), cigarrillos(colorado), cigarrillos(parisiennes)]).
venta(lucas,  fecha(martes, 11, 8),     [golosinas(600)]).
venta(lucas,  fecha(martes, 18, 8),     [bebidas(noAlcoholica, 2), cigarrillos(derby)]).

/* Queremos saber si una persona vendedora es suertuda, esto ocurre si para todos los
días en los que vendió, la primera venta que hizo fue importante. Una venta es
importante:
● en el caso de las golosinas, si supera los $ 100.
● en el caso de los cigarrillos, si tiene más de dos marcas.
● en el caso de las bebidas, si son alcohólicas o son más de 5. */

vendedor(Persona) :- venta(Persona, _, _).

esSuertuda(Persona) :-
    vendedor(Persona),
    forall(
        venta(Persona, _, Ventas),
        ( nth1(1, Ventas, Venta), ventaImportante(Venta) )
    ).

ventaImportante(golosinas(Monto)) :- Monto > 100.

ventaImportante(cigarrillos(Marca1, Marca2)) :- Marca1 \= Marca2.
ventaImportante(cigarrillos(Marca1, Marca2, Marca3)) :- Marca1 \= Marca2, Marca1 \= Marca3, Marca2 \= Marca3.

ventaImportante(bebidas(alcoholicas, _)).
ventaImportante(bebidas(_, Cantidad)) :- Cantidad > 5.

