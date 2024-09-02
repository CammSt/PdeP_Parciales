
% pokemon(Nombre, Tipo).

pokemon(pikachu,   electrico). 
pokemon(charizard, fuego).
pokemon(venusaur,  planta).       %UNICO EN SU TIPO
pokemon(blatoise,  agua).
pokemon(totodile,  agua).         %NO TIENE ENTRENADOR
pokemon(snorlax,   normal).       %UNICO EN SU TIPO
pokemon(rayquaza,  dragon).       %UNICO EN SU TIPO  Y NO TIENE ENTRENADOR
pokemon(rayquaza,  volador).      %UNICO EN SU TIPO  Y NO TIENE ENTRENADOR

pokemon(pruebita,  agua).         %NO TIENE ENTRENADOR
pokemon(pruebita,  fuego).
pokemon(pruebita,  electrico).

pokemon(arceus,    desconocido).  %UNICO EN SU TIPO

% entrenador(Nombre, ListaPokemones).
entrenador(ash,   pikachu).
entrenador(ash,   charizard).
entrenador(brock, snorlax).
entrenador(misty, blatoise).
entrenador(misty, venusaur).
entrenador(misty, arceus).

/* 1) Saber si un pokémon es de tipo múltiple, esto ocurre cuando tiene más de un tipo. */

tipoMultiple(NombrePokemon) :-
    pokemon(NombrePokemon, Tipo1),
    pokemon(NombrePokemon, Tipo2),
    Tipo1 \= Tipo2.

/* 2) Saber si un pokemon es legendario, lo cual ocurre si es de tipo múltiple y ningún entrenador lo tiene. */
legendario(NombrePokemon) :-
    tipoMultiple(NombrePokemon),
    not(tieneEntrenador(NombrePokemon)).

tieneEntrenador(NombrePokemon) :-
    entrenador(_, NombrePokemon).
    
/* 3) Saber si un pokemon es misterioso, lo cual ocurre si es el único en su tipo o ningún entrenador lo tiene. */

misterioso(NombrePokemon) :-
    pokemon(NombrePokemon, _),
    not(tipoRepetido(NombrePokemon)).
misterioso(NombrePokemon) :-
    pokemon(NombrePokemon, _),
    not(tieneEntrenador(NombrePokemon)).

tipoRepetido(NombrePokemon) :-
    pokemon(NombrePokemon, Tipo),
    pokemon(OtroPokemon, Tipo),
    NombrePokemon \= OtroPokemon.    


/* PARTE 2*/

% movimiento(Pokemon, fisico(Nombre, Potencia)).
% movimiento(Pokemon, especial(Nombre, Tipo, Potencia)).
% movimiento(Pokemon, defensivo(Nombre, PorcentajeReduccion)).

movimiento(pikachu,   fisico(mordedura, 95)).
movimiento(pikachu,   especial(impactrueno, electrico, 40)).

movimiento(charizard, especial(garraDragon, dragon, 100)).
movimiento(charizard, fisico(mordedura, 95)).

movimiento(blatoise,  defensivo(proteccion, 10)).
movimiento(blatoise,  fisico(placaje, 50)).

movimiento(arceus,    especial(impactrueno, electrico, 40)).
movimiento(arceus,    especial(garraDragon, dragon, 100)).
movimiento(arceus,    defensivo(proteccion, 10)).
movimiento(arceus,    fisico(placaje, 50)).
movimiento(arceus,    defensivo(alivio, 100)).


/* 1) El daño de ataque de un movimiento */

% danioDeAtaque(TipoAtaque, Danio).

tipoBasico(fuego).
tipoBasico(agua).
tipoBasico(planta).
tipoBasico(normal).

danioDeAtaque(fisico(_, Potencia), Potencia).
danioDeAtaque(defensivo(_, _), 0).

danioDeAtaque(especial(_, Tipo, Potencia), Danio) :-
    multiplicadorPorTipo(Tipo, Multiplicador),
    Danio is Multiplicador * Potencia.


multiplicadorPorTipo(dragon, 3).
multiplicadorPorTipo(Tipo, Multiplicador) :-
    Tipo \= dragon,
    tipoBasico(Tipo),
    Multiplicador is 1.5.

multiplicadorPorTipo(Tipo, Multiplicador) :-
    Tipo \= dragon,
    not(tipoBasico(Tipo)),
    Multiplicador is 1.


/* 2) La capacidad ofensiva de un pokémon, la cual está dada por la sumatoria de los daños de ataque de los movimientos que puede usar. */

capacidadOfensiva(NombrePokemon, DanioTotal) :-
    pokemon(NombrePokemon, _),
    findall(Danio, (movimiento(NombrePokemon, Movimiento), danioDeAtaque(Movimiento, Danio)), ListaDanio),
    sum_list(ListaDanio, DanioTotal).
    
/* 3) Si un entrenador es picante, lo cual ocurre si todos sus pokemons tienen una capacidad ofensiva total superior a 200 o son misteriosos. */

picante(NombreEntrenador):-
    entrenador(NombreEntrenador, _),
    forall(entrenador(NombreEntrenador, NombrePokemon), pokemonPicante(NombrePokemon)).

pokemonPicante(NombrePokemon):-
    capacidadOfensiva(NombrePokemon, Danio),
    Danio > 200.

pokemonPicante(NombrePokemon):-
    misterioso(NombrePokemon).