
/* BASE DE CONOCIMIENTO */

casa(gryffindor).
casa(slytherin).
casa(ravenclaw).
casa(hufflepuff).

sangre(harry, mestiza).
sangre(draco, pura).
sangre(hermione, impura).
sangre(ron, pura).

caracter(harry, corajudo).
caracter(harry, amistoso).
caracter(harry, orgulloso).
caracter(harry, inteligente).
caracter(draco, inteligente).
caracter(draco, orgulloso).
caracter(hermione, inteligente).
caracter(hermione, orgulloso).
caracter(hermione, responsable).

casaOdiada(harry, slytherin).
casaOdiada(draco, hufflepuff).

preferencias(gryffindor, corajudo).
preferencias(slytherin, orgulloso).
preferencias(slytherin, inteligente).
preferencias(ravenclaw, inteligente).
preferencias(ravenclaw, responsable).
preferencias(hufflepuff, amistoso).

mago(Mago) :-
    sangre(Mago, _).

/* ---------------------------------------------------------------------------------------- */
/* Parte 1 - Sombrero Seleccionador */

/* 1) Saber si una casa permite entrar a un mago, lo cual se cumple para cualquier mago y cualquier casa excepto en el caso de Slytherin, que no permite entrar a magos de sangre impura. */
% permiteEntrar(Casa, Mago)

permiteEntrar(slytherin, Mago) :-
    mago(Mago),
    not(sangre(Mago, impura)).

permiteEntrar(Casa, Mago) :-
    casa(Casa), mago(Mago),
    Casa \= slytherin.

/* 2) Saber si un mago tiene el carácter apropiado para una casa, lo cual se cumple para cualquier mago si sus características incluyen todo lo que se busca para los integrantes de esa casa, independientemente de si la casa le permite la entrada. */
% tieneCaracterApropiado(Mago, Casa)

tieneCaracterApropiado(Mago, Casa) :-
    mago(Mago), casa(Casa),
    forall(preferencias(Casa, Caracter), caracter(Mago, Caracter)).

/* 3) Determinar en qué casa podría quedar seleccionado un mago sabiendo que tiene que tener el carácter adecuado para la casa, la casa permite entrar al mago y el mago no odiar a la casa. 
Además Hermione puede quedar seleccionada en Gryffindor, porque al parecer el sombrero seleccionador tuvo en cuenta el coraje de ella. */
% puedeQuedarSeleccionado(Casa, Mago)

puedeQuedarSeleccionado(gryffindor, hermione).

puedeQuedarSeleccionado(Casa, Mago) :-
    tieneCaracterApropiado(Mago, Casa),
    permiteEntrar(Casa, Mago),
    not(casaOdiada(Mago, Casa)).

/* 4) Definir un predicado cadenaDeAmistades/1 que se cumple para una lista de magos si todos ellos se caracterizan por ser amistosos y cada uno podría estar en la misma casa que el siguiente. No hace falta que sea inversible, se consultará de forma individual. */
% cadenaDeAmistades(ListaMagos)

cadenaDeAmistades(ListaMagos) :-
    todosAmistosos(ListaMagos),
    cadenaDeCasas(ListaMagos).

cadenaDeCasas([_]).
cadenaDeCasas([Mago1, Mago2 | Cola]) :-
    puedeQuedarSeleccionado(Casa, Mago1),
    puedeQuedarSeleccionado(Casa, Mago2),
    cadenaDeCasas([Mago2 | Cola]).

todosAmistosos([]).
todosAmistosos(ListaMagos) :-
    forall(member(Mago, ListaMagos), caracter(Mago, amistoso)).

/* ---------------------------------------------------------------------------------------- */
/* Parte 2 - La copa de las casas */

/*
Se pide incorporar a la base de conocimiento la información sobre las acciones realizadas y agregar la siguiente lógica a nuestro programa:

    1- a) Saber si un mago es buen alumno, que se cumple si hizo alguna acción y ninguna de las cosas que hizo se considera una mala acción (que son aquellas que provocan un puntaje negativo).
    1- b) Saber si una acción es recurrente, que se cumple si más de un mago hizo esa misma acción.
    2) Saber cuál es el puntaje total de una casa, que es la suma de los puntos obtenidos por sus miembros.
    3) Saber cuál es la casa ganadora de la copa, que se verifica para aquella casa que haya obtenido una cantidad mayor de puntos que todas las otras.
    4) Queremos agregar la posibilidad de ganar puntos por responder preguntas en clase. La información que nos interesa de las respuestas en clase son: cuál fue la pregunta, cuál es la dificultad de la pregunta y qué profesor la hizo.
*/

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

accion(harry, andarDeNoche).
accion(hermione, irA(tercerPiso)).
accion(hermione, irA(seccionRestringidaBiblioteca)).
accion(harry, irA(bosque)).
accion(harry, irA(tercerPiso)).
accion(draco, irA(mazmorras)).
accion(hermione, responderPregunta(dondeSeEncuentraUnBezoar, snape, 20)).
accion(hermione, responderPregunta(comoLevitarUnaPluma, flitwick, 25)).
accion(ron, buenaAccion(50, ganarAjedrezMagico)).
accion(hermione, buenaAccion(50, salvarASusAmigos)).
accion(harry, buenaAccion(60, vencerAVoldemort)).

lugarProhibido(bosque, 50).
lugarProhibido(tercerPiso, 75).
lugarProhibido(seccionRestringidaBiblioteca, 10).

puntaje(buenaAccion(Puntaje, _), Puntaje).
puntaje(andarDeNoche, -50).
puntaje(irA(Lugar), PuntajeQueResta) :-
    lugarProhibido(Lugar, Puntos),
    PuntajeQueResta is Puntos * -1.
puntaje(responderPregunta(snape, _, Puntaje), Puntaje / 2).
puntaje(responderPregunta(_, _, Puntaje), Puntaje).


/* 1) (a) Saber si un mago es buen alumno, que se cumple si hizo alguna acción y ninguna de las cosas que hizo se considera una mala acción (que son aquellas que provocan un puntaje negativo). */

esBuenAlumno(Mago) :-
    mago(Mago),
    hizoAlgunaAccion(Mago),
    not(hizoAlgoMalo(Mago)).

hizoAlgunaAccion(Mago) :-
    mago(Mago),
    accion(Mago, _).

hizoAlgoMalo(Mago) :-
    accion(Mago, Accion),
    puntaje(Accion, Puntaje),
    Puntaje < 0.

/* 1) (b) Saber si una acción es recurrente, que se cumple si más de un mago hizo esa misma acción. */

esRecurrente(Accion) :-
    accion(Mago, Accion),
    accion(OtroMago, Accion),
    Mago \= OtroMago.

/* 2) Saber cuál es el puntaje total de una casa, que es la suma de los puntos obtenidos por sus miembros. */

puntajeTotal(Casa, PuntajeFinal) :-
    casa(Casa),
    findall(Puntos, 
        (esDe(Mago, Casa), accion(Mago, Accion), puntaje(Accion, Puntos)),
        ListaPuntos
    ),
    sum_list(ListaPuntos, PuntajeFinal).

/* 3) Saber cuál es la casa ganadora de la copa, que se verifica para aquella casa que haya obtenido una cantidad mayor de puntos que todas las otras. */

ganadoraDeLaCopa(Casa) :-
    puntajeTotal(Casa, Puntaje),
    forall(
        (puntajeTotal(OtraCasa, OtroPuntaje), Casa \= OtraCasa),
        Puntaje > OtroPuntaje 
    ). 


/* 4) Queremos agregar la posibilidad de ganar puntos por responder preguntas en clase. La información que nos interesa de las respuestas en clase son: cuál fue la pregunta, cuál es la dificultad de la pregunta y qué profesor la hizo. */

/* 
    Por ejemplo, sabemos que Hermione respondió a la pregunta de dónde se encuentra un Bezoar, de dificultad 20, realizada por el profesor Snape, y cómo hacer levitar una pluma, de dificultad 25, realizada por el profesor Flitwick.

    Modificar lo que sea necesario para que este agregado funcione con lo desarrollado hasta ahora, teniendo en cuenta que los puntos que se otorgan equivalen a la dificultad de la pregunta, 
    a menos que la haya hecho Snape, que da la mitad de puntos en relación a la dificultad de la pregunta.
*/

% se agrego al listado de acciones y de puntajes