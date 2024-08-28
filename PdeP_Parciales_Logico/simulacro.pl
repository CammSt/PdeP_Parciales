juego(accion(doom), 500, 10).                     % precio final = 450
juego(accion(minecraft), 500, 50).                % precio final = 250
juego(accion(counterStrike), 500, 10).            % precio final = 450
juego(accion(fortnite), 2500, 0).                 % precio final = 2500
juego(accion(overwatch), 2000, 25).               % precio final = 1500

juego(rol(worldOfWarcraft, 1000000), 1000, 20).   % precio final = 800
juego(rol(leagueOfLegends, 2000000), 3000, 0).    % precio final = 3000
juego(rol(dota2, 1000000), 1200, 0).              % precio final = 1200
juego(rol(pathOfExile, 500000), 3400, 0).         % precio final = 3400
juego(rol(diablo3, 100000), 1000, 10).            % precio final = 900

juego(puzzle(candyCrush, 1000, facil), 100, 50).  % precio final = 50
juego(puzzle(tetris, 1000, dificil), 50, 60).     % precio final = 20
juego(puzzle(sudoku, 1000, dificil), 200, 10).    % precio final = 180
juego(puzzle(2048, 1000, facil), 4600, 0).        % precio final = 4600
juego(puzzle(babaIsYou, 25, dificil), 500, 25).   % precio final = 375
juego(puzzle(portal, 1000, dificil), 1000, 0).    % precio final = 1000


/* 1)  
    (a) Queremos saber cuánto sale un juego: debe considerarse el precio original para los juegos que no están en oferta, y su precio con descuento para los juegos que sí. 
    (b) Decimos que tiene un buen descuento un juego en oferta cuyo porcentaje de descuento es al menos del 50%. 
*/

buscadorJuego(NombreJuego, Precio, Descuento) :- juego(accion(NombreJuego), Precio, Descuento).
buscadorJuego(NombreJuego, Precio, Descuento) :- juego(rol(NombreJuego, _), Precio, Descuento).
buscadorJuego(NombreJuego, Precio, Descuento) :- juego(puzzle(NombreJuego, _, _), Precio, Descuento).

calculoDePrecioFinal(Precio, Descuento, PrecioFinal) :-
    PrecioFinal is Precio - (Precio * Descuento / 100).

cuantoSale(NombreJuego, PrecioFinal) :-
    buscadorJuego(NombreJuego, Precio, Descuento),
    calculoDePrecioFinal(Precio, Descuento, PrecioFinal).

/* --------------------------------------------------------------------------------------- */

esUnBuenDescuento(Porcentaje) :-
    Porcentaje >= 50.

tieneBuenDescuento(NombreJuego) :-
    buscadorJuego(NombreJuego, _, Descuento),
    esUnBuenDescuento(Descuento).

/* 2) Un juego es popular si cumple ciertas condiciones que dependen de su tipo. 
Los juegos de acción siempre son populares, los de rol cuando tienen más de un millón de usuarios activos, y los de puzzle cuando su dificultad es fácil o tienen exactamente 25 niveles. 
El Minecraft y el Counter Strike son siempre populares, independientemente de las otras condiciones. */

popular(minecraft).
popular(counterStrike).

popular(NombreJuego) :-
    juego(accion(NombreJuego),_,_).

popular(NombreJuego) :-
    juego(rol(NombreJuego, UsuariosActivos),_,_),
    UsuariosActivos >= 1000000.

popular(NombreJuego) :-
    juego(puzzle(NombreJuego, _, facil),_,_).

popular(NombreJuego) :-
    juego(puzzle(NombreJuego, Niveles, _),_,_),
    Niveles =:= 25.

/* 3) Un usuario puede ser adicto a los descuentos, si todo lo que planea adquirir tiene un descuento de al menos 50%; puede ser fanático de un género si tiene al menos dos juegos de ese género; 
o puede ser monotemático de un género si todos los juegos que posee son de ese género. */

usuario(romina).
usuario(martin).
usuario(juan).

posee(romina, [minecraft, worldOfWarcraft, portal]).
posee(martin, [counterStrike, fortnite, leagueOfLegends, tetris]).               % fanático de los juegos de acción - MARTIN
posee(juan,   [worldOfWarcraft, leagueOfLegends, dota2, pathOfExile]).           % fanático y monotemático de los juegos de rol - JUAN

planeaAdquirir(romina, [candyCrush, tetris, minecraft]).                         % adicta a los descuentos - ROMINA
planeaAdquirir(martin, [worldOfWarcraft, dota2, candyCrush, counterStrike]).
planeaAdquirir(juan,   [minecraft, counterStrike, tetris, candyCrush, sudoku]).  % adicto a los descuentos - JUAN                        

/* --------------------------------------------------------------------------------------- */

% es adicto si todos los juegos que quiere adquirir tienen un buen descuento
adictoALosDescuentos(Usuario) :-
    usuario(Usuario),
    planeaAdquirir(Usuario, ListaJuegos),
    forall(
        member(NombreJuego, ListaJuegos),
        tieneBuenDescuento(NombreJuego)
    ).
    
% es fanático si tiene al menos dos juegos de un género -- generalizar para todos los generos
fanaticoDe(Usuario, Genero) :-
    cantidadDeJuegosDeGeneroAdquiridos(Usuario, Genero, Cantidad),
    Cantidad >= 2.

juegoDeGenero(Genero, NombreJuego) :-
    (Genero = accion, juego(accion(NombreJuego), _, _));
    (Genero = rol, juego(rol(NombreJuego, _), _, _));
    (Genero = puzzle, juego(puzzle(NombreJuego, _, _), _, _)).

% es monotemático si todos los juegos que posee son de un género
monotematico(Usuario, Genero) :-
    cantidadDeJuegosDeGeneroAdquiridos(Usuario, Genero, CantidadGenero),
    cantidadDeJuegosAdquiridos(Usuario, CantidadTotal),
    CantidadTotal =:= CantidadGenero.


cantidadDeJuegosAdquiridos(Usuario, Cantidad) :-
    usuario(Usuario),
    posee(Usuario, JuegosPoseidos),
    length(JuegosPoseidos, Cantidad).

cantidadDeJuegosDeGeneroAdquiridos(Usuario, Genero, Cantidad) :-
    usuario(Usuario),
    posee(Usuario, JuegosPoseidos),
    include(juegoDeGenero(Genero), JuegosPoseidos, JuegosDeGenero),
    length(JuegosDeGenero, Cantidad).

/* --------------------------------------------------------------------------------------- */

/* 4) Dos usuarios son buenos amigos si entre sus futuras adquisiciones piensan regalarse juegos populares mutuamente.*/

regalar(juan, romina, candyCrush).
regalar(romina, juan, minecraft).
regalar(martin, juan, counterStrike).
regalar(juan, martin, sudoku).

/* ROMINA Y JUAN SON BUENOS AMIGOS - PERO MARTIN Y JUAN NO */

buenosAmigos(Usuario1, Usuario2) :-
    usuario(Usuario1), usuario(Usuario2), Usuario1 \= Usuario2,
    regalar(Usuario1, Usuario2, Juego1),
    regalar(Usuario2, Usuario1, Juego2),
    popular(Juego1), popular(Juego2). 
   
/* --------------------------------------------------------------------------------------- */

/* 5) Queremos saber cuánto gastará un usuario en función de sus futuras compras, regalos, o ambas. */

gastoTotal(Usuario, Gasto) :-
    usuario(Usuario),
    planeaAdquirir(Usuario, Juegos),
    findall(Precio, (member(NombreJuego, Juegos), cuantoSale(NombreJuego, Precio)), Precios),
    sum_list(Precios, Gasto).