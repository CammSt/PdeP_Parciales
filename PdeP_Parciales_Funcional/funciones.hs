-- USO UTIL

-- Patrones de Listas 

-- (cabeza:cola)
-- (cabeza:segundo:cola)

-- Tuplas
-- (comp1, comp2)  --> primer elemento fst --> segundo elemento snd

-- Funciones lambda
-- (\x y -> algo con x e y)

-- FUNCIONES HASKELL 

{- 
    -- OPERADORES LOGICOS Y MATEMATICOS --

    NEGACION                     - not
    DIVISION ENTERA              - div dividendo divisor
    RESTO                        - mod dividendo divisor
    VALOR ABSOLUTO               - abs numero
    MAXIMO ENTRE DOS NUMEROS     - max numero1 numero2
    MINIMO ENTRE DOS NUMEROS     - min numero1 numero2
    NUMERO PAR                   - even numero
    NUMERO IMPAR                 - odd numero

    -- OPERADORES DE LISTAS --

    LONGITUD                     - length
    LISTA VACIA                  - null
    PRECEDER                     - :         --> (:) :: a -> [a] -> [a]
    CONCATENAR                   - ++        --> (++) :: [a] -> [a] -> [a]
    INTERSECCION                 - intersect --> intersect :: Eq a => [a] -> [a] -> [a]
    ACCESO POR INDICE            - !!        --> (!!) :: [a] -> Int -> a
    MAXIMO DE UNA LISTA          - maximum
    MINIMO DE UNA LISTA          - minimum
    SUMATORIA DE UNA LISTA       - sum
    APLANAR                      - concat    --> concat :: [[a]] -> [a]
    PRIMERO N ELEMENTOS          - take      --> take :: Int -> [a] -> [a]
    SIN LOS PRIMEROS N ELEMENTOS - drop      --> drop :: Int -> [a] -> [a]
    PRIMER ELEMENTO              - head
    ULTIMO ELEMENTO              - last
    COLA                         - tail (todo menos el primer elemento)
    SEGMENTO INICIAL             - init (todo menos el ultimo elemento)
    APAREO DE LISTAS             - zip       --> zip :: [a] -> [b] -> [(a, b)]
    LISTA ORDEN REVERSO          - reverse

    -- FUNCIONES DE ORDEN SUPERIOR DE LISTAS --

    FILTRAR                           - filter --> filter :: (a->Bool) -> [a] -> [a]
    TRANSFOMRAR                       - map    --> map ::  (a->b)-> [a] -> [b]
    TODOS CUMPLEN                     - all    --> all :: (a->Bool) -> [a] -> Bool
    ALGUNO CUMPLE                     - any    --> any :: (a->Bool) -> [a] -> Bool
    REDUCIR / PLEGAR A IZQUIERDA      - foldl  --> foldl :: (a->b->a) -> a -> [b] -> a
    REDUCIR / PLEGAR A DERECHA        - foldr  --> foldr :: (b->a->a) -> a -> [b] -> a
    1er ELEMENTO QUE CUMPLE CONDICION - find   --> find :: (a->Bool) -> [a] -> a
    LISTA ORDENADA                    - sort   --> sort :: Ord a => [a] -> [a] 
 
    -- FUNCIONES DE GENERACION DE LISTAS --

    GENERA LISTA INFINITA QUE REPITE UN SOLO ELEMENTO 
    repeat  :: a -> [a]
    repetir x = x : repetir x
    Ejemplo: repear 2 = [2,2,2,2,2,2,2,2,2,...]

    REPITE UNA LISTA DENTRO DE OTRA LISTA INFINITAMENTE
    cycle  :: [a] -> [a]
    ciclar x = x ++ ciclar x
    Ejemplo: cycle [1,2,3] = [1,2,3,1,2,3,1,2,3,1,2,3,...]

    REPITE INFINITAMENTE LA LOGICA DE APLICAR AL VALOR INICIAL UNA FUNCION
    iterate :: (a->a) -> a -> [a] -> una funcion, un valor inicial y devuelve la lista de los resultados
    iterar f x = iterar f (f x)
    Ejemplo: iterate (+2) 0 -> [0,2,4,6,8,10,...]

    REPITE N VECES UN ELEMENTO EN UNA LISTA
    replicate :: Int -> a -> [a] -> una cantidad de veces, un valor para repetir y devuelve la lista
    replicar n x 
        | n == 0 = []
        | otherwise = x : replicar (n-1) x
    Ejemplo: replicate 10 2 = [2,2,2,2,2,2,2,2,2,2]
-}


{- 

    -- TEORIA --

    PATTERN MATCHING HASKELL

        Tiene la ventaja de simplificar la codificación, ya que sólo escribimos la forma de lo que esperamos y podemos desglosar los componentes
    de estructuras complejos.
        Una desventaja asociada a usar pattern matching es que el simple hecho de agregar un elemento más a la tupla que representa a nuestro elemento 
    de dominio provocará un cambio en el tipo del mismo y el mismo se propagará en todos los lugares donde se haya utilizado esta estructura directamente

    Ejemplo1: 

    Si queremos saber si el nombre de un día de la semana es fin de semana usando Pattern Matching:

    esFinDeSemana' "Sábado" = True
    esFinDeSemana' "Domingo" = True
    esFinDeSemana' _ = False 

    Ejemplo2:

    factorial 0 = 1 
    factorial n = n * factorial (n - 1)

    Para evitar loops infinitos, es importante poner el caso base primero para que matchee con el 0, ya que la variable n también matchearía con este valor.



-}