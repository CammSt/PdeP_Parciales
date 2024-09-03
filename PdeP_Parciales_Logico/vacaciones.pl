/* 1) El destino es así, lo se... */

vacacionesEn(dodain, pehuenia).
vacacionesEn(dodain, sanMartinDeLosAndes).
vacacionesEn(dodain, esquel).
vacacionesEn(dodain, sarmiento).
vacacionesEn(dodain, camarones).
vacacionesEn(dodain, playasDoradas).
vacacionesEn(alf, bariloche).
vacacionesEn(alf, sanMartinDeLosAndes).
vacacionesEn(alf, elBolson).
vacacionesEn(nico, marDelPlata).
vacacionesEn(vale, calafate).
vacacionesEn(vale, elBolson).
vacacionesEn(martu, Destino) :- vacacionesEn(nico, Destino).
vacacionesEn(martu, Destino) :- vacacionesEn(alf, Destino).

vacacionesEn(sofia, santaClara).

/* 
    No es necesario agregar las cláusulas de "Juan no sabe si va a ir a Villa Gesell o a Federación" y de "Carlos no se va a tomar vacaciones por ahora" porque el paradigma lógico
    funciona en base al principio de universo cerrado, es decir que todo lo que no sea verdad o esté en duda se considera falso
*/

/* 2) Vacaciones copadas */

%atraccion(NombreAtraccion, TipoAtraccion)
atraccion(losAlerces,   parqueNacional()).
atraccion(trochita,     excursion(trochita)).
atraccion(travelin,     excursion(travelin)).
atraccion(bateaMahuida, cerro(2000)).
atraccion(moquehue,     cuerpoDeAgua(sePuedePescar, 14)).
atraccion(alumine,      cuerpoDeAgua(sePuedePescar, 19)).

atraccion(costaMarDelPlata,          cuerpoDeAgua(sePuedePescar, 25)).  % PARA vacacionesCopadas

%seEncuentraEn(NombreAtraccion, Destino)
seEncuentraEn(losAlerces,   esquel).
seEncuentraEn(trochita,     esquel).
seEncuentraEn(travelin,     esquel).
seEncuentraEn(bateaMahuida, pehuenia).
seEncuentraEn(moquehue,     pehuenia).
seEncuentraEn(alumine,      pehuenia).

seEncuentraEn(costaMarDelPlata,      marDelPlata). % PARA vacacionesCopadas

viajero(Viajero) :- vacacionesEn(Viajero, _).
destino(Destino) :- vacacionesEn(_, Destino).

vacacionesCopadas(Viajero) :- 
    viajero(Viajero),
    forall( vacacionesEn(Viajero, Destino), tieneAtraccionCopada(Destino) ).

tieneAtraccionCopada(Destino) :-
    seEncuentraEn(NombreAtraccion, Destino),
    atraccion(NombreAtraccion, TipoAtraccion),
    atraccionCopada(TipoAtraccion).

atraccionCopada(parqueNacional).
atraccionCopada(cerro(Altura)) :- Altura >= 2000.
atraccionCopada(cuerpoDeAgua(sePuedePescar, _)).
atraccionCopada(cuerpoDeAgua(_, Temperatura)) :- Temperatura > 20.
atraccionCopada(playa(DiferenciaDeMareas)) :- DiferenciaDeMareas < 5.

atraccionCopada(excursion(Nombre)) :- 
    atom_length(Nombre, CantidadLetras),
    CantidadLetras > 7.

/* 3) Ni se me cruzó por la cabeza */

noSeCruzaron(Viajero1, Viajero2) :- 
    viajero(Viajero1), viajero(Viajero2),
    Viajero1 \= Viajero2,
    not(seCruzaron(Viajero1, Viajero2)).

seCruzaron(Viajero1, Viajero2) :-
    viajero(Viajero1), viajero(Viajero2),
    Viajero1 \= Viajero2,
    vacacionesEn(Viajero1, Destino),
    vacacionesEn(Viajero2, Destino).

/* 4) Vacaciones gasoleras */

costoDeVidaEn(sarmiento,           100).
costoDeVidaEn(esquel,              150).
costoDeVidaEn(pehuenia,            180).
costoDeVidaEn(sanMartinDeLosAndes, 150).
costoDeVidaEn(camarones,           135).
costoDeVidaEn(playasDoradas,       170).
costoDeVidaEn(bariloche,           140).
costoDeVidaEn(calafate,            240).
costoDeVidaEn(elBolson,            145).
costoDeVidaEn(marDelPlata,         140).

vacacionesGasoleras(Viajero) :-
    viajero(Viajero),
    forall(
        vacacionesEn(Viajero, Destino),
        destinoGasolero(Destino)
    ).

destinoGasolero(Destino) :-
    costoDeVidaEn(Destino, CostoDeVida),
    CostoDeVida < 160.

/* 5) Itinerarios posibles */

/* Queremos conocer todas las formas de armar el itinerario de un viaje para una persona
sin importar el recorrido. Para eso todos los destinos tienen que aparecer en la
solución (no pueden quedar destinos sin visitar).
Por ejemplo, para Alf las opciones son
[bariloche, sanMartin, elBolson]
[bariloche, elBolson, sanMartin]
[sanMartin, bariloche, elBolson]
[sanMartin, elBolson, bariloche]
[elBolson, bariloche, sanMartin]
[elBolson, sanMartin, bariloche] */

