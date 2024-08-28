/* 1) Diseñar la base de conocimiento. Incluir los puestos de comida, las atracciones, los visitantes del grupo Viejitos y dos personas que hayan venido solas. */

comida(hamburguesa,      2000).
comida(panchitoConPapas, 1500).
comida(lomitoCompleto,   2500).
comida(caramelo,         0).

atraccion(autitosChocadores, tranquila(chicosYAdultos)).
atraccion(casaEmbrujada,     tranquila(chicosYAdultos)).
atraccion(laberinto,         tranquila(chicosYAdultos)).

atraccion(tobogan,  tranquila(chicos)).
atraccion(calesita, tranquila(chicos)).

atraccion(barcoPirata, intensa(adultos, 14)).
atraccion(tazasChinas, intensa(adultos, 6)).
atraccion(simulador3D, intensa(adultos, 2)).

% montañas rusas
atraccion(abismoMoralRecargada, montaniaRusa(3, 134)).
atraccion(paseoPorElBosque,     montaniaRusa(0, 45)).

% atracciones acuaticas
atraccion(torpedoSalpicon,                     acuatica).
atraccion(esperoQueTeHayasTraidoUnaMudaDeRopa, acuatica).

% visitante(nombre, superficial(edad, dinero), sentimental(hambre, aburrimiento)).
visitante(eusebio, superficial(80, 0),    sentimental(0,  0)).
visitante(carmela, superficial(80, 0),    sentimental(0, 25)).

visitante(mariana, superficial(47, 4500),   sentimental(15,  20)).
visitante(juan,    superficial(30, 20),     sentimental(0, 0)).

visitante(eduardo, superficial(37, 4670),   sentimental(10, 0)).
visitante(maria,   superficial(10, 300),    sentimental(40, 0)).

%grupo(nombre, integrante).
grupo(viejitos, eusebio).
grupo(viejitos, carmela).
grupo(lopez, eduardo).
grupo(lopez, maria).

/* 2)  Saber el estado de bienestar de un visitante.
    a. Si su hambre y aburrimiento son 0, siente felicidad plena.
    b. Si suman entre 1 y 50, podría estar mejor.
    c. Si suman entre 51 y 99, necesita entretenerse.
    d. Si suma 100 o más, se quiere ir a casa.

    Hay una excepción para los visitantes que vienen solos al parque: nunca pueden sentir felicidad plena, sino que podrían estar mejor también cuando su hambre y aburrimiento suman 0.
*/

bienestar(Visitante, felicidadPlena) :-
    visitante(Visitante, superficial(_, _), sentimental(0, 0)),
    vieneAcompaniado(Visitante).

bienestar(Visitante, podriaEstarMejor) :-
    visitante(Visitante, superficial(_, _), sentimental(0, 0)),
    not(vieneAcompaniado(Visitante)).

bienestar(Visitante, podriaEstarMejor) :-
    sumaEntre(1, 50, Visitante).

bienestar(Visitante, necesitaEntretenerse) :-
    sumaEntre(51, 90, Visitante).

bienestar(Visitante, seQuiereIrACasa) :-
    visitante(Visitante, superficial(_, _), sentimental(Hambre, Aburrimiento)),
    SumaSentimientos is Hambre + Aburrimiento,
    SumaSentimientos >= 100.

visitante(Visitante) :- visitante(Visitante, _, _).

sumaEntre(Inferior, Superior, Visitante) :-
    visitante(Visitante, superficial(_, _), sentimental(Hambre, Aburrimiento)),
    SumaSentimientos is Hambre + Aburrimiento,
    between(Inferior, Superior, SumaSentimientos).

vieneAcompaniado(Visitante) :-
    grupo(_, Visitante).
    

/* 3) Saber si un grupo familiar puede satisfacer su hambre con cierta comida. 
    Cada integrante del grupo debe tener dinero suficiente como para comprarse esa comida y esa comida, a la vez, debe poder quitarle el hambre a cada persona.
*/

% TODO - SE PUEDE UNIFICAR EL aTodosLesAlcanza Y EL leSacaElHambreATodos - Y ASI SE SOLUCIONA EL PROBLEMA DE LOS CARAMELOS

puedeSatisfacer(Comida, Grupo) :-
    comida(Comida, _), grupo(Grupo, _),
    aTodosLesAlcanza(Grupo, Comida),
    leSacaElHambreATodos(Grupo, Comida).

aTodosLesAlcanza(Grupo, Comida) :-
    forall(grupo(Grupo, Visitante), leAlcanza(Visitante, Comida)).

leAlcanza(Visitante, Comida) :-
    visitante(Visitante, superficial(_, Dinero), _),
    comida(Comida, Precio),
    Dinero >= Precio.

leSacaElHambreATodos(Grupo, Comida) :-
    forall(grupo(Grupo, Visitante), leSacaElHambreA(Visitante, Comida)).

% La hamburguesa satisface a quienes tienen menos de 50 de hambre;
leSacaElHambreA(Visitante, hamburguesa) :-
    visitante(Visitante, _, sentimental(Hambre, _)),
    Hambre < 50.

%el panchito con papas sólo le quita el hambre a los chicos;
leSacaElHambreA(Visitante, panchitoConPapas) :-
    esChico(Visitante).

% el lomito completo llena siempre a todo el mundo.
leSacaElHambreA(_, lomitoCompleto).

% sólo satisfacen a las personas que no tienen dinero suficiente para pagar ninguna otra comida.
leSacaElHambreA(Visitante, caramelo) :-
    forall(comida(Comida, Precio), (not(leAlcanza(Visitante, Precio)), Comida \= caramelo )).

esChico(Visitante) :-
    visitante(Visitante, superficial(Edad, _), _),
    Edad < 13.

/* 4) Saber si puede producirse una lluvia de hamburguesas. Esto ocurre para un visitante que puede pagar una hamburguesa al subirse a una atracción que:
    a. Es intensa con un coeficiente de lanzamiento mayor a 10, o
    b. Es una montaña rusa peligrosa, o
    c. Es el tobogán 

    Para los adultos sólo es peligrosa la montaña rusa con mayor cantidad de giros invertidos en todo el parque, a menos que el visitante necesite entretenerse, 
    en cuyo caso nada le parece peligroso. 
    El criterio cambia para los chicos, donde independientemente de la cantidad de giros invertidos, los recorridos de más de un minuto de duración alcanzan para considerarla peligrosa.
*/

% lluviaDeHamburguesas(Visitante, NombreAtraccion).

lluviaDeHamburguesas(Visitante, NombreAtraccion) :-
    leAlcanza(Visitante, hamburguesa),
    atraccionDeLluviaDeHamburguesas(Visitante, NombreAtraccion).

atraccionDeLluviaDeHamburguesas(_, NombreAtraccion) :-
    atraccion(NombreAtraccion, intensa(_, Coeficiente)),
    Coeficiente > 10.

atraccionDeLluviaDeHamburguesas(Visitante, NombreAtraccion) :-
    atraccion(NombreAtraccion, montaniaRusa(Giros, Duracion)),
    esPeligrosa(Giros, Duracion, Visitante).

atraccionDeLluviaDeHamburguesas(_, tobogan).
    

esPeligrosa(_, Duracion, Visitante) :-
    esChico(Visitante),
    Duracion > 60.

esPeligrosa(Giros, _, Visitante) :-
    not(esChico(Visitante)),
    not(bienestar(Visitante, necesitaEntretenerse)),
    tieneLaMayorCantidadDegiros(Giros).

tieneLaMayorCantidadDegiros(Giros) :-
    forall(atraccion(_, (OtroGiro, _)), OtroGiro =< Giros). 

/* 5) Saber, para cada mes, las opciones de entretenimiento para un visitante. 

    Esto debe incluir todos los puestos de comida en los cuales tiene dinero para comprar, todas las atracciones tranquilas a las que puede acceder (dependiendo su franja etaria), 
    todas las atracciones intensas, todas las montañas rusas que no le sean peligrosas, y por último todas las atracciones acuáticas, siempre y cuando el mes de visita coincida con los
    meses de apertura. El resto de las atracciones están abiertas todo el año.

    Finalmente, una atracción tranquila exclusiva para chicos también puede ser opción de entretenimiento para un visitante adulto en el caso en que en el grupo familiar haya un
    chico a quien acompañar.
*/

% opcionDeEntretenimiento(Visitante, MesDeVisita) :-
    