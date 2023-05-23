# CraftMine


**En este videojuego, existen personajes cuyo objetivo es minar materiales y construir nuevos objetos.**

Los personajes tienen un nombre, un puntaje y un inventario con todos los materiales que poseen. De un mismo material se pueden tener varias unidades.

Para ello, se define el siguiente tipo de dato
```Haskell
data Personaje = UnPersonaje {
	nombre:: String,
	puntaje:: Int,
	inventario:: [Material]
} deriving Show
```
## Craft
Craftear consiste en construir objetos a partir de otros objetos. Para ello se cuenta con recetas que consisten en una lista de materiales que se requieren para craftear un nuevo objeto. En ninguna receta hace falta más de una unidad de mismo material. La receta también especifica el tiempo que tarda en construirse. Todo material puede ser componente de una receta y todo objeto resultante de una receta también es un material y puede ser parte en la receta de otro.

Por ejemplo:
- para hacer una fogata, se necesita madera y fósforo y se tarda 10 segundos
- para hacer pollo asado, se necesita fogata y un pollo, pero se tarda 300 segundos
- para hacer un sueter, se necesita lana, agujas y tintura, y demora 600 segundos

1. Hacer las funciones necesarias para que un jugador craftee un nuevo objeto
- El jugador debe quedar con el nuevo objeto en su inventario
- El jugador debe quedar sin los materiales usados para craftear
- La cantidad de puntos del jugador se incrementa a razón de 10 puntos por segundo utilizado en el crafteo.
- El objeto se craftea sólo si se cuenta con todos los materiales requeridos antes de comenzar la tarea. En caso contrario, no se altera el inventario, pero se pierden 100 puntos.

_Por ejemplo, si un jugador con 1000 puntos tenía un sueter, una fogata y dos pollos y craftea un pollo asado, mantiene su sueter intacto, se queda con un sólo pollo, sin fogatas y pasa a tener un pollo asado en su inventario. Su puntaje pasa a ser 4000._

2. Dado un personaje y una lista de recetas: 
- Encontrar los objetos que podría craftear un jugador y que le permitirían como mínimo duplicar su puntaje. 
- Hacer que un personaje craftee sucesivamente todos los objetos indicados en la lista de recetas. 
- Averiguar si logra quedar con más puntos en caso de craftearlos a todos sucesivamente en el orden indicado o al revés.

## Mine

El mundo del videojuego se compone de biomas, donde cada bioma tiene muchos materiales. Para poder minar en un bioma particular el personaje debe tener un elemento necesario según el bioma. Por ejemplo, en un bioma ártico, donde hay hielo, iglues y lobos, se debe tener un suéter. 

Cuando un personaje va a minar a un bioma, si cuenta con el elemento necesario, agrega a su inventario uno de los materiales del bioma y gana 50 puntos. La forma de elegir cuál es el material del bioma a conseguir, depende de la herramienta que use al minar. Por ejemplo, el hacha hace que se mine el último de los materiales del bioma, mientras que la espada actúa sobre el primero de ellos. Existe tambien el pico, que por ser más preciso permite apuntar a una determinada posición de los materiales. Por ejemplo, si un personaje con un sueter en su inventario mina el artico con un pico de precisión 1, agrega un iglú a su inventario. En caso de no poder minar por no tener lo necesario el personaje se va con las manos vacías y sigue como antes.

1. Hacer una función minar, que dada una herramienta, un personaje y un bioma, permita obtener cómo queda el personaje.
2. Definir las herramientas mencionadas y agregar dos nuevas. Mostrar ejemplos de uso. Hacerlo de manera que agregar en el futuro otras herramientas no implique modificar la función minar.
- Utilizando la función composición, usar una que permita obtener un material del medio del conjunto de materiales.
- Utilizando una expresión lambda, inventar una nueva herramienta, diferente a las anteriores

3. ¿Qué pasa al intentar minar en un bioma con infinitos materiales? Mostrar ejemplos donde con diferentes herramientas o personajes sucedan diferentes cosas. Justificar. 

