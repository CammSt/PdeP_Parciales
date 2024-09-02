juego(doom, accion(), 500, 10).                     % precio final = 450
juego(minecraft, accion(), 500, 50).                % precio final = 250
juego(counterStrike, accion(), 500, 10).            % precio final = 450
juego(fortnite, accion(), 2500, 0).                 % precio final = 2500
juego(overwatch, accion(), 2000, 25).               % precio final = 1500

juego(worldOfWarcraft, rol(1000000), 1000, 20).     % precio final = 800
juego(leagueOfLegends, rol(2000000), 3000, 0).      % precio final = 3000
juego(dota2, rol(1000000), 1200, 0).                % precio final = 1200
juego(pathOfExile, rol(500000), 3400, 0).           % precio final = 3400
juego(diablo3, rol(100000), 1000, 10).              % precio final = 900

juego(candyCrush, puzzle(1000, facil), 100, 50).    % precio final = 50
juego(tetris, puzzle(1000, dificil), 50, 60).       % precio final = 20
juego(sudoku, puzzle(1000, dificil), 200, 10).      % precio final = 180
juego(2048, puzzle(1000, facil), 4600, 0).          % precio final = 4600
juego(babaIsYou, puzzle(25, dificil), 500, 25).     % precio final = 375
juego(portal, puzzle(1000, dificil), 1000, 0).      % precio final = 1000

/*1) Queremos saber cuánto sale un juego: debe considerarse el precio original para los juegos que no están en oferta, y su precio con descuento para los juegos que sí. 
Decimos que tiene un buen descuento un juego en oferta cuyo porcentaje de descuento es al menos del 50%.  */

precioFinal(NombreJuego, PrecioFinal) :-
    juego(NombreJuego, _, Precio, Descuento),
    PrecioFinal is (Precio - (Descuento*Precio/100)).

tieneBuenDescuento(NombreJuego) :-
    juego(NombreJuego, _, _, Descuento),
    Descuento >= 50.

/* 2) Un juego es popular si cumple ciertas condiciones que dependen de su tipo. 

Los juegos de acción siempre son populares, 
los de rol cuando tienen más de un millón de usuarios activos, 
y los de puzzle cuando su dificultad es fácil o tienen exactamente 25 niveles. 
El Minecraft y el Counter Strike son siempre populares, independientemente de las otras condiciones. */


esPopular(minecraft).
esPopular(counterStrike).

esPopular(NombreJuego) :-
    juego(NombreJuego, accion, _, _).

esPopular(NombreJuego) :-
    juego(NombreJuego, rol(Usuarios), _, _),
    Usuarios > 1000000.

esPopular(NombreJuego) :-
    juego(NombreJuego, puzzle(25, _), _, _).
esPopular(NombreJuego) :-
    juego(NombreJuego, puzzle(_, facil), _, _).

/* 3) Usuarios */

posee(romina, [minecraft, worldOfWarcraft, portal]).
posee(martin, [counterStrike, fortnite, leagueOfLegends, tetris]).               % fanático de los juegos de acción - MARTIN
posee(juan,   [worldOfWarcraft, leagueOfLegends, dota2, pathOfExile]).           % fanático y monotemático de los juegos de rol - JUAN

/* Esas futuras adquisiciones pueden ser de dos tipos: o es un juego que va a comprar para sí mismo, o es un juego que va a regalarle a otro usuario en particular. */

planeaAdquirir(romina, [candyCrush, tetris]).                                   % adicta a los descuentos - ROMINA
planeaAdquirir(martin, [worldOfWarcraft, dota2, candyCrush, counterStrike]).
planeaAdquirir(juan,   [minecraft, counterStrike, tetris, candyCrush, sudoku]).  % adicto a los descuentos - JUAN 

planeaRegalar(romina, juan, [minecraft]).        %POPULAR
planeaRegalar(juan, romina, [leagueOfLegends]).  %POPULAR
planeaRegalar(juan, martin, [2048]).             %POPULAR
planeaRegalar(martin, juan, [diablo3]).          %NO POPULAR


/* Un usuario puede ser adicto a los descuentos, si todo lo que planea adquirir tiene un descuento de al menos 50%; 
puede ser fanático de un género si tiene al menos dos juegos de ese género; o puede ser monotemático de un género si todos los juegos que posee son de ese género. */

usuario(Usuario) :- posee(Usuario, _).

todosTienenBuenDescuento(Lista) :-
    forall( 
        member(NombreJuego,Lista),
        tieneBuenDescuento(NombreJuego)
    ).

adictoALosDescuentos(Usuario) :-
    todasLasComprasTienenBuenDescuento(Usuario),
    todosLosRegalosTienenBuenDescuento(Usuario).

todasLasComprasTienenBuenDescuento(Usuario) :-
    planeaAdquirir(Usuario, ListaDeJuegosQuePlaneaAdquirir),
    todosTienenBuenDescuento(ListaDeJuegosQuePlaneaAdquirir).

todosLosRegalosTienenBuenDescuento(Usuario) :-
    planeaRegalar(Usuario, _, ListaDeJuegosQuePlaneaRegalar),
    todosTienenBuenDescuento(ListaDeJuegosQuePlaneaRegalar).

/* ---------------------------------------------------------------- */

fanaticoDe(Usuario, Genero) :-
    tieneJuego(Usuario, Juego1, Genero),
    tieneJuego(Usuario, Juego2, Genero),
    Juego1 \= Juego2.

tieneJuego(Usuario, NombreJuego, NombreGenero) :-
    posee(Usuario, ListaDeJuegosQuePosee),
    member(NombreJuego, ListaDeJuegosQuePosee),
    tipoDeJuego(NombreJuego, NombreGenero).

genero(accion, accion()).
genero(rol, rol(_)).
genero(puzzle, puzzle(_, _)).

/* ---------------------------------------------------------------- */

tipoDeJuego(NombreJuego, NombreGenero) :-
    juego(NombreJuego, Genero, _, _),
    genero(NombreGenero, Genero).

monotematico(Usuario) :-
    posee(Usuario, ListaDeJuegosQuePosee),
    tieneJuego(Usuario, _, NombreGenero),
    forall(member(Juego, ListaDeJuegosQuePosee), tipoDeJuego(Juego, NombreGenero)).


/* 4) Dos usuarios son buenos amigos si entre sus futuras adquisiciones piensan regalarse juegos populares mutuamente. */

buenosAmigos(Usuario1, Usuario2) :-
    planeaRegalar(Usuario1, Usuario2, ListaRegalos1),
    planeaRegalar(Usuario2, Usuario1, ListaRegalos2),

    contieneJuegoPopular(ListaRegalos1),
    contieneJuegoPopular(ListaRegalos2).

contieneJuegoPopular(Lista) :-
    member(Juego, Lista),
    esPopular(Juego).

/* Finalmente, queremos saber cuánto gastará un usuario en función de sus futuras compras, regalos, o ambas. */

tipoDeGasto(compra).
tipoDeGasto(regalo).
tipoDeGasto(ambas).

 gasta(Usuario, GastoFinal, TipoDeCompra) :-
    usuario(Usuario), tipoDeGasto(TipoDeCompra),
    filtroDeGastosPorTipo(Usuario, GastoFinal, TipoDeCompra).

filtroDeGastosPorTipo(Usuario, GastoFinal, compra) :-
    planeaAdquirir(Usuario, ListaDeJuegosQuePlaneaAdquirir),
    findall(Precio, ( member(NombreJuego, ListaDeJuegosQuePlaneaAdquirir), precioFinal(NombreJuego, Precio) ), Precios ),
    sum_list(Precios, GastoFinal).

filtroDeGastosPorTipo(Usuario, GastoFinal, regalo) :-
    findall(ListaDeJuegos, planeaRegalar(Usuario, _, ListaDeJuegos), ListasDeRegalos),
    append(ListasDeRegalos, TodosLosJuegos),
    findall(Precio, (member(NombreJuego, TodosLosJuegos), precioFinal(NombreJuego, Precio)), Precios),
    sum_list(Precios, GastoFinal).

filtroDeGastosPorTipo(Usuario, GastoFinal, ambas) :-
    usuario(Usuario), 
    filtroDeGastosPorTipo(Usuario, GastoCompra, compra),
    filtroDeGastosPorTipo(Usuario, GastoRegalo, regalo),
    GastoFinal is GastoCompra + GastoRegalo.