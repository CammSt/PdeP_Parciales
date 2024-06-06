
import Text.Show.Functions

data Auto = Auto {
    marca :: String,
    modelo :: String,
    desgasteRuedas :: Float,
    desgasteChasis :: Float,
    velocidadMaxima :: Float,
    tiempoDeCarrera :: Float
} deriving (Show)

type Tramo = Auto -> Auto
type Pista = [Tramo]

ferrari :: Auto
ferrari = Auto { 
    marca = "Ferrari",
    modelo = "F50",
    desgasteChasis = 0,
    desgasteRuedas = 0,
    velocidadMaxima = 65,
    tiempoDeCarrera = 0
}

lamborghini :: Auto
lamborghini = Auto {
    marca = "Lamborghini",
    modelo = "Diablo",
    desgasteChasis = 7,
    desgasteRuedas = 4,
    velocidadMaxima = 73,
    tiempoDeCarrera = 0
}

fiat :: Auto
fiat = Auto {
    marca = "Fiat",
    modelo = "600",
    desgasteChasis = 33,
    desgasteRuedas = 27,
    velocidadMaxima = 44,
    tiempoDeCarrera = 0
}

------------------------------------------------------------------------------------

chasisEnBuenEstado :: Auto -> Bool
chasisEnBuenEstado unAuto = (<40) . desgasteChasis $ unAuto

ruedasEnBuenEstado :: Auto -> Bool
ruedasEnBuenEstado unAuto = (<60) . desgasteRuedas $ unAuto

autoEnBuenEstado :: Auto -> Bool
autoEnBuenEstado unAuto = chasisEnBuenEstado unAuto && ruedasEnBuenEstado unAuto

autoNoDaMas :: Auto -> Bool
autoNoDaMas unAuto = desgasteChasis unAuto > 80 || desgasteRuedas unAuto > 80

------------------------------------------------------------------------------------

modificarDesgasteRuedas :: Float -> Auto -> Auto
modificarDesgasteRuedas valor unAuto = unAuto { desgasteRuedas = valor }

modificarDesgasteChasis :: Float -> Auto -> Auto
modificarDesgasteChasis valor unAuto = unAuto { desgasteChasis = valor }

modificarTiempoDeCarrera :: Float -> Auto -> Auto
modificarTiempoDeCarrera valor unAuto = unAuto { tiempoDeCarrera = valor }

repararAuto :: Auto -> Auto
repararAuto unAuto = modificarDesgasteChasis (0.15 * desgasteChasis unAuto) . modificarDesgasteRuedas 0 $ unAuto

penalizarTiempo :: Auto -> Auto
penalizarTiempo unAuto = modificarTiempoDeCarrera ((tiempoDeCarrera unAuto) + 10) unAuto

------------------------------------------------------------------------------------

curva :: Float -> Float -> Auto -> Auto
curva longitud angulo unAuto = modificarDesgasteRuedas (3 * longitud / angulo) . modificarTiempoDeCarrera (longitud / (velocidadMaxima unAuto / 2)) $ unAuto

tramoRecto :: Float -> Auto -> Auto
tramoRecto longitud unAuto = modificarDesgasteChasis (desgasteChasis unAuto + longitud/100) . modificarTiempoDeCarrera (longitud / velocidadMaxima unAuto) $ unAuto

boxes :: Tramo -> Auto -> Auto
boxes tramo unAuto
    | autoEnBuenEstado unAuto = tramo unAuto
    | otherwise = penalizarTiempo . repararAuto  $ unAuto

curvaPeligrosa :: Auto -> Auto
curvaPeligrosa unAuto = curva 300 60 unAuto

curvaTranca :: Auto -> Auto
curvaTranca unAuto = curva 550 110 unAuto

tramoRectoClassic :: Auto  -> Auto
tramoRectoClassic unAuto = tramoRecto 750 unAuto

tramito :: Auto  -> Auto
tramito unAuto = tramoRecto 280 unAuto
 
pistaMojada :: Tramo -> Auto -> Auto
pistaMojada tramo unAuto = modificarTiempoDeCarrera (tiempoDeCarrera (tramo unAuto) / 2) . tramo $ unAuto

conRipio :: Tramo -> Auto -> Auto
conRipio tramo unAuto = tramo . tramo $ unAuto

obstruccion :: Tramo -> Auto -> Float -> Auto
obstruccion tramo unAuto longitud = modificarDesgasteRuedas (2 * longitud) . tramo $ unAuto

------------------------------------------------------------------------------------

pasaPorTramo :: Tramo -> Auto -> Auto
pasaPorTramo tramo unAuto
    | not . autoNoDaMas $ unAuto = tramo unAuto
    | otherwise = unAuto

------------------------------------------------------------------------------------

superPista :: Pista
superPista = [tramoRectoClassic, curvaTranca, pistaMojada tramito, tramito, curva 400 80, curva 650 115, tramoRecto 970, curvaPeligrosa, conRipio tramito, boxes (tramoRecto 800)]

peganLaVuelta :: Pista -> [Auto] -> [Auto]
peganLaVuelta pista autos = foldl (\autos tramo -> map (pasaPorTramo tramo) autos) autos pista

------------------------------------------------------------------------------------

data Carrera = Carrera {
    pista :: Pista,
    vueltas :: Float
} deriving (Show)

tourBuenosAires :: Carrera
tourBuenosAires = Carrera {
    pista = superPista,
    vueltas = 20
}

competidores :: [Auto]
competidores = [ferrari, lamborghini, fiat]

