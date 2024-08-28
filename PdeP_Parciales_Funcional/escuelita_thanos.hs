
data Personaje = Personaje {
    edad        :: Float,
    energia     :: Float,
    habilidades :: [String],
    nombre      :: String,
    planeta     :: String
}

data Guantelete = Guantelete {
    material    :: String,
    gemas       :: [Gema]
}

{- data Universo = Universo {
    habitantes :: [Personaje]
} -}

type Universo = [Personaje]

type Gema = Personaje -> Personaje
type Habilidad = String
type Planeta = String

esGuanteleteCompleto :: Guantelete -> Bool
-- esGuanteleteCompleto unGuantelete = (material unGuantelete == "uru") && ((== 6) . length . gemas $ unGuantelete)
esGuanteleteCompleto (Guantelete material gemas) = (material == "uru") && ((== 6) . length $ gemas )

chasquido :: Universo -> Guantelete -> Universo
chasquido unUniverso unGuantelete 
    -- | esGuanteleteCompleto unGuantelete = unUniverso { habitantes =  take (div (length (habitantes unUniverso)) 2) (habitantes unUniverso) }
    | esGuanteleteCompleto unGuantelete = reducirALaMitad unUniverso
    | otherwise = unUniverso

reducirALaMitad :: Universo -> Universo
reducirALaMitad unUniverso = take (div (length unUniverso) 2) unUniverso
--------------------------------------------------------------------------------------------

edadMenorA :: Float -> Personaje -> Bool
edadMenorA edadLimite unPersonaje = edad unPersonaje < edadLimite

esAptoParaPendex :: Universo -> Bool
esAptoParaPendex unUniverso = any (edadMenorA 45) (habitantes unUniverso)
-- esAptoParaPendex = any $ (<=45).edad

sumarEnergiaPersonaje :: Personaje -> Float
sumarEnergiaPersonaje unPersonaje
    | (>1) . length . habilidades $ unPersonaje = energia unPersonaje
    | otherwise = 0

energiaTotalUniverso :: Universo -> Float  
energiaTotalUniverso unUniverso = sum (map sumarEnergiaPersonaje (habitantes unUniverso))
-- energiaTotalDelUniverso unUniverso = sum.map energia.filter ((>1).length.habilidades) unUniverso


----------- MODIFICADORES DE PERSONAJE -----------

modificarEnergia :: Personaje -> Float -> Personaje
modificarEnergia unPersonaje nuevaEnergia = unPersonaje { energia = nuevaEnergia }

modificarPlaneta :: Personaje -> Planeta -> Personaje
modificarPlaneta unPersonaje nuevoPlaneta = unPersonaje { planeta = nuevoPlaneta }

modificarHabilidades :: Personaje -> [Habilidad] -> Personaje
modificarHabilidades unPersonaje nuevasHabilidades = unPersonaje { habilidades = nuevasHabilidades }

modificarEdad :: Personaje -> Float -> Personaje
modificarEdad unPersonaje nuevaEdad = unPersonaje { edad = nuevaEdad }

eliminarHabilidad :: Personaje -> Habilidad -> Personaje 
eliminarHabilidad unPersonaje habilidadAEliminar = filter (not . (esHabilidadBuscada habilidadAEliminar)) (habilidades unPersonaje)

esHabilidadBuscada :: Habilidad -> Habilidad -> Bool
esHabilidadBuscada habilidadBuscada unaHabilidad = unaHabilidad == habilidadBuscada

--------------------------------------------------------------------------------------------

gemaMente :: Personaje -> Float -> Personaje
gemaMente unPersonaje nuevaEnergia = modificarEnergia unPersonaje nuevaEnergia
 
gemaAlma :: Habilidad -> Personaje -> Personaje
gemaAlma habilidadAEliminar unPersonaje = eliminarHabilidad (modificarEnergia unPersonaje ((energia unPersonaje) - 10)) habilidadAEliminar

gemaEspacio :: Personaje -> Planeta -> Personaje
gemaEspacio unPersonaje unPlaneta = modificarPlaneta (modificarEnergia unPersonaje ((energia unPersonaje) - 20) ) unPlaneta

gemaPoder :: Personaje -> Personaje
gemaPoder unPersonaje 
    | length (habilidades unPersonaje) <= 2 = modificarHabilidades (modificarEnergia unPersonaje 0) []
    | otherwise = modificarEnergia unPersonaje 0

gemaTiempo :: Personaje -> Personaje
gemaTiempo unPersonaje = modificarEdad unPersonaje . max 18 . flip div 2 . edad $ unPersonaje


gemaLoca :: Gema -> Personaje -> Personaje
gemaLoca unaGema unPersonaje = unaGema . unaGema $ unPersonaje

--------------------------------------------------------------------------------------------

guanteleteDeGoma :: Guantelete
guanteleteDeGoma = Guantelete { 
    material = "Goma",
    gemas = [ gemaTiempo, gemaAlma "usar Mjolnir", gemaLoca (gemaAlma "programación en Haskell")]
}
--------------------------------------------------------------------------------------------

utilizar :: [Gema] -> Personaje -> Personaje
utilizar listaGemas enemigo = foldl (\enemigo gema -> gema enemigo) enemigo listaGemas

--------------------------------------------------------------------------------------------

gemaMasPoderosaDe :: Personaje -> [Gema] -> Gema
gemaMasPoderosaDe _ [gema] = gema  -- si tiene una sola gema esa sera la mas poderosa
gemaMasPoderosaDe personaje (gema1:gema2:gemas) 
    | (energia.gema1) personaje < (energia.gema2) personaje = gemaMasPoderosaDe personaje (gema1:gemas)  -- si tiene mas de dos gemas compara de a dos y hace recursividad
    | otherwise = gemaMasPoderosaDe personaje (gema2:gemas)

--------------------------------------------------------------------------------------------
 
-- infinitasGemas :: Gema -> [Gema]
-- infinitasGemas gema = gema:(infinitasGemas gema)

-- guanteleteDeLocos :: Guantelete
-- guanteleteDeLocos = Guantelete "vesconite" (infinitasGemas tiempo)

-- usoLasTresPrimerasGemas :: Guantelete -> Personaje -> Personaje
-- usoLasTresPrimerasGemas guantelete = (utilizar . take 3. gemas) guantelete

{- 
    Justifique si se puede ejecutar, relacionándolo con conceptos vistos en la cursada:
        a) gemaMasPoderosa punisher guanteleteDeLocos
        No implementé la función gemaMasPoderosa, pero suponiendo que se resolviera con un foldl o foldr esta función no podrá ejecutarse porque necesitará
        evaluar cada una de las gemas para poder reconocer la más poderosa

        Ahora que estpa resuelto se puede asegurar que no terminará de ejecutarse hasta haber comparado toda la lista de gemas

        b) usoLasTresPrimerasGemas guanteleteDeLocos punisher
        Debido a que Haskell implementa las funciones con el concepto de Lazy Evaluation, no necesita llegar al final del array para completar la funcionalidad,
        por lo que se puede ejecutar.
    
-}

