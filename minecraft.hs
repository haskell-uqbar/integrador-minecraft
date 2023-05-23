data Jugador = UnJugador {
    nombre :: String,
    puntaje :: Int,
    inventario :: [Material]
} deriving Show

-- PARTE 1

type Material = String

data Receta = Receta {
    materiales :: [Material],
    tiempo :: Int,
    resultado :: Material
}

fogata,fosforo, madera,polloAsado,pollo,sueter,hielo,lobos,iglues :: Material
fogata = "fogata"
fosforo = "fosforo"
madera = "madera"
pollo = "pollo"
polloAsado = "pollo asado"
sueter = "sueter"
hielo = "hielo"
iglues = "iglues"
lobos = "lobos"

intentarCraftear :: Receta -> Jugador ->  Jugador
intentarCraftear receta jugador
    | tieneMateriales receta jugador  =  craftear receta jugador 
    | otherwise = alterarPuntaje (-100) jugador 

craftear :: Receta -> Jugador -> Jugador
craftear receta = alterarPuntaje (10*tiempo receta).agregarMaterial (resultado receta).quitarMateriales  (materiales receta)


-- Auxiliares
tieneMateriales :: Receta -> Jugador -> Bool
tieneMateriales  receta jugador = all (tieneMaterial jugador) (materiales receta)

tieneMaterial :: Jugador -> Material -> Bool
tieneMaterial jugador material = elem material (inventario jugador)

agregarMaterial :: Material -> Jugador -> Jugador
agregarMaterial material jugador = jugador {inventario = material:inventario jugador }

quitarMateriales :: [Material] -> Jugador -> Jugador
quitarMateriales materiales jugador = jugador{inventario = foldr quitarUnaVez (inventario jugador) materiales}

quitarUnaVez:: Eq a => a -> [a] -> [a]
quitarUnaVez _ [] = []
quitarUnaVez material (m:ms)  
 | material == m = ms
 | otherwise = m:quitarUnaVez material ms 

alterarPuntaje :: Int -> Jugador ->  Jugador
alterarPuntaje n jugador  = jugador {puntaje = puntaje jugador + n}

{-
Ejemplos:
ghci> intentarCraftear recetaPollo maria
UnJugador {nombre = "maria", puntaje = 4000, inventario = ["pollo asado","pollo","sueter"]}
-}

recetaFogata :: Receta
recetaFogata = Receta [madera, fosforo] 10 fogata

recetaPollo :: Receta
recetaPollo = Receta [fogata, pollo] 300 polloAsado

juan, maria :: Jugador
juan = UnJugador "juan" 20 [madera, fosforo, pollo, sueter]
maria = UnJugador "maria" 1000 [fogata, pollo, pollo, sueter]

unasRecetas :: [Receta]
unasRecetas = [recetaFogata, recetaPollo]

crafteablesDuplicadores :: [Receta] -> Jugador -> [Material]
crafteablesDuplicadores recetas jugador = map resultado (filter (duplicaLuegoDeCraftear jugador) recetas)

duplicaLuegoDeCraftear ::  Jugador -> Receta -> Bool
duplicaLuegoDeCraftear jugador receta = puntaje (intentarCraftear receta jugador ) > 2 * puntaje jugador

craftearSucesivamente :: Jugador -> [Receta] ->  Jugador
craftearSucesivamente = foldr intentarCraftear

masPuntosAlReves ::  Jugador -> [Receta] -> Bool
masPuntosAlReves jugador listaDeRecetas = puntaje (craftearSucesivamente jugador (reverse listaDeRecetas)) > puntaje (craftearSucesivamente jugador listaDeRecetas)

{-
Ejemplos:
ghci> intentarCraftear recetaPollo maria
UnJugador {nombre = "maria", puntaje = 4000, inventario = ["pollo asado","pollo","sueter"]}

ghci> crafteablesDuplicadores unasRecetas maria
["pollo asado"]
ghci> crafteablesDuplicadores unasRecetas juan
["fogata"]

ghci> craftearSucesivamente juan (reverse unasRecetas)
UnJugador {nombre = "juan", puntaje = 3120, inventario = ["pollo asado","sueter"]}
ghci> craftearSucesivamente juan unasRecetas
UnJugador {nombre = "juan", puntaje = 20, inventario = ["fogata","pollo","sueter"]}

ghci> masPuntosAlReves juan unasRecetas
True
-}

-- PARTE 2


data Bioma = UnBioma{
    materialesPresentes :: [Material],
    materialNecesario :: Material
}

biomaArtico :: Bioma
biomaArtico = UnBioma [hielo, iglues, lobos] sueter

type Herramienta = [Material] -> Material

hacha :: Herramienta
hacha = last

espada :: Herramienta
espada = head 

pico :: Int -> Herramienta
pico = flip (!!) 
    
posicionMitad :: Herramienta
posicionMitad lista = pico (length lista `div` 2) lista

minar :: Herramienta -> Bioma -> Jugador  -> Jugador
minar herramienta bioma jugador 
    | tieneMaterial jugador (materialNecesario bioma)  = agregarMaterial (herramienta (materialesPresentes bioma)) (alterarPuntaje 50 jugador)
    | otherwise = jugador
{-
EJEMPLOS DE USO DE HERRAMIENTAS:

ghci> minar hacha biomaArtico juan
UnJugador {nombre = "juan", puntaje = 70, inventario = ["lobos","madera","fosforo","pollo","sueter"]}

ghci> minar (pico 1) biomaArtico juan
UnJugador {nombre = "juan", puntaje = 70, inventario = ["iglues","madera","fosforo","pollo","sueter"]}

-}

-- PARTE 3

listaPollosInfinitos :: [String]
listaPollosInfinitos = pollo : listaPollosInfinitos

{-
> minar espada (UnBioma listaPollosInfinitos sueter) juan
UnJugador {nombre = "juan", puntaje = 1050, inventario = ["pollo","madera","fosforo","pollo crudo","sueter"]}

-}