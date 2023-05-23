data Jugador = UnJugador {
    nombre :: String,
    puntaje :: Int,
    inventario :: [Material]
} deriving Show

-- PARTE 1

{-
Craftear consiste en construir objetos a partir de otros objetos. 
Para ello se cuenta con recetas que consisten en una lista de materiales
que se requieren para craftear un nuevo objeto. La receta también 
especifica el tiempo que tarda en construirse. 
Todo material puede ser componente de una receta y todo objeto resultante 
de una receta también es un material y puede ser parte en la receta de otro.
Por ejemplo:
para hacer una fogata, se necesita madera y fósforo y se tarda 10 segundos
para hacer pollo asado, se necesita fogata y un pollo, pero se tarda 300 segundos
-}

type Material = String

data Receta = Receta {
    materiales :: [Material],
    tiempo :: Int,
    resultado :: Material
}
-- MATERIALES UTILIZADOS:
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

{-
Hacer las funciones necesarias para que un jugador craftee un nuevo objeto
El jugador debe quedar con el nuevo objeto en su inventario
El jugador debe quedar sin los materiales usados para craftear
La cantidad de puntos del jugador se incrementa a razón de 10 puntos por segundo utilizado en el crafteo.
El objeto se craftea sólo si se cuenta con todos los materiales requeridos antes de 
comenzar la tarea. En caso contrario, no se altera el inventario, pero se pierden 100 puntos.
-}
intentarCraftear :: Receta -> Jugador ->  Jugador
intentarCraftear receta jugador
    | tieneMateriales receta jugador  =  craftear receta jugador 
    | otherwise = alterarPuntaje (-100) jugador 

craftear :: Receta -> Jugador -> Jugador
craftear receta = alterarPuntaje (tiempo receta).agregarMaterial (resultado receta).quitarMateriales  (materiales receta)


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
Dado un personaje y una lista de recetas: 
Encontrar los objetos que podría craftear un jugador y que le permitirían como mínimo duplicar su puntaje. 
Hacer que un personaje craftee sucesivamente todos los objetos indicados en la lista de recetas. 
Averiguar si logra quedar con más puntos en caso de craftearlos a todos en el orden indicado o al revés.
-}

recetaFogata :: Receta
recetaFogata = Receta [madera, fosforo] 10 fogata

recetaPollo :: Receta
recetaPollo = Receta [fogata, pollo] 100 polloAsado

juan, maria :: Jugador
juan = UnJugador "juan" 1000 [madera, fosforo, pollo, sueter]
maria = UnJugador "maria" 5 [madera, fosforo, pollo, sueter]

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

ghci> crafteablesDuplicadores unasRecetas maria
["fogata"]
ghci> crafteablesDuplicadores unasRecetas juan
[]
ghci> craftearSucesivamente juan (reverse unasRecetas)
UnJugador {nombre = "juan", puntaje = 1110, inventario = ["pollo asado","sueter"]}
ghci> craftearSucesivamente juan unasRecetas
UnJugador {nombre = "juan", puntaje = 910, inventario = ["fogata","pollo","sueter"]}
ghci> masPuntosAlReves juan unasRecetas
True

-}

-- PARTE 2

{-
Cuando un personaje va a minar a un bioma, si cuenta con el elemento necesario, agrega a su 
inventario uno de los materiales del bioma y gana 50 puntos. La forma de elegir cuál es el material del 
bioma a conseguir, depende de la herramienta que use al minar. Por ejemplo, el hacha hace que se mine el 
último de los materiales del bioma, mientras que la espada actúa sobre el primero de ellos. 
Existe tambien el pico, que por ser más preciso permite apuntar a una determinada posición de los materiales. 
Por ejemplo, si un personaje con un sueter en su inventario mina el artico con un pico de precisión 1, 
agrega un iglú a su inventario. En caso de no poder minar por no tener lo necesario el personaje se 
va con las manos vacías y sigue como antes.
-}
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



-}


-- PARTE 3
{-
 Depende de como sea la función que defina la herramienta, ya que si una herramienta utiliza la función head sobre
 la lista infinita, no va a haber problema, gracias a la evaliacion diferida o perezosa. Por ejemplo:
-}

listaPollosInfinitos :: [String]
listaPollosInfinitos = pollo : listaPollosInfinitos

{-
> minar espada (UnBioma listaPollosInfinitos sueter) juan
UnJugador {nombre = "juan", puntaje = 1050, inventario = ["pollo","madera","fosforo","pollo crudo","sueter"]}

-}