
-- PUNTO 1--

data Auto = Auto {
    marca :: String,
    modelo :: String, 
    desgasteRuedas :: Float,
    desgasteChasis :: Float,
    velocidad :: Float,
    tiempo :: Float
}

ferrari :: Auto
ferrari = Auto {
    marca          = "Ferrari",
    modelo         = "F50",
    desgasteRuedas = 0,
    desgasteChasis = 0,
    velocidad      = 65,
    tiempo         = 0
}

lambo :: Auto
lambo = Auto {
    marca          = "Lamborghini",
    modelo         = "Diablo",
    desgasteRuedas = 4,
    desgasteChasis = 7,
    velocidad      = 73,
    tiempo         = 0
}

fiat :: Auto
fiat = Auto {
    marca          = "Fiat",
    modelo         = "600",
    desgasteRuedas = 27,
    desgasteChasis = 33,
    velocidad      = 44,
    tiempo         = 0
}

---------------------------------------------------------------------
-- PUNTO 2 --

enBuenEstado :: Auto -> Bool
enBuenEstado auto = (desgasteChasis auto < 40) && (desgasteRuedas auto < 60)

noDaMas :: Auto -> Bool
noDaMas auto = (desgasteChasis auto > 80) || (desgasteRuedas auto > 80)

---------------------------------------------------------------------
-- PUNTO 3 --

modificarDesgasteChasis :: (Float -> Float) -> Auto -> Auto
modificarDesgasteChasis modificador auto = auto { desgasteChasis = modificador . desgasteChasis $ auto}

modificarDesgasteRuedas :: (Float -> Float) -> Auto -> Auto
modificarDesgasteRuedas modificador auto = auto { desgasteRuedas = modificador . desgasteRuedas $ auto}

reparar :: Auto -> Auto
reparar = modificarDesgasteRuedas (const 0) . modificarDesgasteChasis (*0.15) 

---------------------------------------------------------------------
-- PUNTO 4 --

type Tramo = Auto -> Auto

----- 4.A

modificarTiempo :: (Float -> Float) -> Auto -> Auto
modificarTiempo modificador auto = auto { tiempo = modificador . tiempo $ auto}

curva :: Float -> Float -> Auto -> Auto
curva angulo longitud auto = modificarDesgasteRuedas (+ (3 * longitud / angulo)) . modificarTiempo (+ (longitud / (velocidad auto / 2))) $ auto

curvaPeligrosa :: Tramo
curvaPeligrosa = curva 60 300

curvaTranca :: Tramo
curvaTranca = curva 110 550

----- 4.B

tramoRecto :: Float -> Auto -> Auto
tramoRecto longitud auto = modificarDesgasteChasis (+ (longitud / 100)). modificarTiempo (+ (longitud / velocidad auto)) $ auto

tramoRectoClassic :: Tramo
tramoRectoClassic = tramoRecto 750

tramito :: Tramo
tramito = tramoRecto 280

----- 4.C

boxes :: Tramo -> Auto -> Auto
boxes tramo auto 
    | enBuenEstado auto = auto
    | otherwise = modificarTiempo (+10) . reparar $ auto

----- 4.D

mojado :: Tramo -> Auto -> Auto
mojado tramo auto = modificarTiempo (+ (tiempo . tramo $ auto) / 2) . tramo $ auto

----- 4.E

ripio :: Tramo -> Auto -> Auto
ripio tramo  = tramo . tramo

----- 4.F

obstruccion :: Float -> Tramo -> Auto -> Auto
obstruccion longitud tramo auto = modificarDesgasteRuedas (+ 2 * longitud) . tramo $ auto

---------------------------------------------------------------------
-- PUNTO 5 --

pasarPorTramo :: Tramo -> Auto -> Auto
pasarPorTramo tramo auto   
    | not . noDaMas $ auto = tramo auto
    | otherwise = auto

---------------------------------------------------------------------
-- PUNTO 6 --

type Pista = [Tramo]

----- 6.A

superPista :: Pista
superPista = [tramoRectoClassic, curvaTranca, mojado tramito, tramito, obstruccion 2 (curva 80 400), curva 115 650, tramoRecto 970, curvaPeligrosa, ripio tramito, boxes (tramoRecto 800) ]

----- 6.B

peganLaVuelta :: Pista -> [Auto] -> [Auto]
peganLaVuelta pista autos = foldl (\autos tramo -> map (pasarPorTramo tramo) autos) autos pista

---------------------------------------------------------------------
-- PUNTO 7 --

----- 7.A

data Carrera = Carrera {
    pista :: Pista,
    vueltas :: Int
}

----- 7.B

tourBuenosAires :: Carrera
tourBuenosAires = Carrera {
    pista = superPista,
    vueltas = 20
}

----- 7.C

jugarCarrera :: Carrera -> [Auto] -> [[Auto]]
jugarCarrera carrera competidores = take (vueltas carrera + 1) $ iterate (peganLaVuelta (pista carrera)) autos -- ESTO NO SE ME OCURRE NI DE PEDO