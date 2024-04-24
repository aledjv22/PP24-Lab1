---
title: Laboratorio de Funcional
author: Arne José Müller Carrizo, Victor Alejandro Díaz Jáuregui, María José Villegas
---
La consigna del laboratorio está en https://tinyurl.com/funcional-2024-famaf

# 1. Tareas
Pueden usar esta checklist para indicar el avance.

## Verificación de que pueden hacer las cosas.
- [x] Haskell instalado y testeos provistos funcionando. (En Install.md están las instrucciones para instalar.)

## 1.1. Lenguaje
- [x] Módulo `Dibujo.hs` con el tipo `Dibujo` y combinadores. Puntos 1 a 3 de la consigna.
- [x] Definición de funciones (esquemas) para la manipulación de dibujos.
- [x] Módulo `Pred.hs`. Punto extra si definen predicados para transformaciones innecesarias (por ejemplo, espejar dos veces es la identidad).

## 1.2. Interpretación geométrica
- [x] Módulo `Interp.hs`.

## 1.3. Expresión artística (Utilizar el lenguaje)
- [x] El dibujo de `Dibujos/Feo.hs` se ve lindo.
- [x] Módulo `Dibujos/Grilla.hs`.
- [x] Módulo `Dibujos/Escher.hs`.
- [x] Listado de dibujos en `Main.hs` + punto extra

## 1.4 Tests
- [x] Tests para `Dibujo.hs`.
- [x] Tests para `Pred.hs`.

# 2. Experiencia
Nuestra experiencia fue muy desafiante, requiriendo una investigación exhaustiva y un pensamiento cuidadoso sobre cómo funcionan las cosas para poder implementarlas. Tuvimos que buscar mucha documentación y en algunos caso tuvimos que experimentar con distintos metodos hasta que logramos que funcionara correctamente.

Sorprendentemente, la parte del dibujo de Escher fue en nuestra opinión la más fácil, ya que gran parte del código ya estaba escrito en el documento que se nos proporcionó. Sin embargo, enfrentamos algunas complicaciones que consumieron mucho tiempo, como comprender qué significaba el "blank" en el documento y cómo traducirlo a nuestro código. Al final, descubrimos que el tipo Escher era un booleano y se utilizaba de manera que "True" aplicaba la figura y "False" no la aplicaba, además de que al hacer la interpretación teníamos que pasar el tipo "Blank" de la librería Gloss.
Otro problema fue que la figura del triángulo que extraímos del dibujo no era exactamente un triángulo normal, sino que parecía tener un ángulo adicional, lo que afectaba la apariencia del dibujo. Lamentablemente, nos llevó bastante tiempo d​arnos cuenta de esto.

Además, algunos problemas de documentación, como el hecho de que no se explicara qué hacer con el cambio de dibujo en la consigna, requirieron que preguntáramos qué se necesitaba hacer en esos casos.

# 3. Preguntas
## ¿Por qué están separadas las funcionalidades en los módulos indicados? Explicar detalladamente la responsabilidad de cada módulo.
Primero que todo, ¿qué es un modulo?
Los modulos son bloques constructores para organizar funciones, tipos y definiciones de clases relacionadas en unidades separadas permitiendo asi como su nombre indica modularidad. Un módulo en Haskell tiene el doble propósito de controlar espacios de nombres y crear tipos de datos abstractos.
Responsabilidad de cada modulo:

- Main: es el punto de entrada del programa y brinda funcionalidades para mostrar e interactuar con distintas configuraciones de dibujos, almacena las configuraciones para los dibujos disponibles, interpreta el dibujo pedido, llamando a initial del modulo Interp para junto a la configuración (configs) y el nombre del dibujo, empiece a reclearlo. En la función principal de `Main` se ven los argumentos de la linea de comandos y: 
    - Si hay más de dos argumentos o ninguno, muestra un mensaje de error y sale.
    - Si el primer argumento es "-l" o "--list", lista los nombres de dibujo disponibles basado en la función name en cada configuración y sale (aclarar que con --list tambien hace un prompt para pedir por un nombre de dibujo que se desee dibujar).
    - Si el primer argumento es "-a" seguido por un nombre de dibujo, utiliza InterpHaha.
    - Si el primer argumento es "-s" seguido por un nombre de dibujo, utiliza initialSVG' de InterpSVG.
    - De lo contrario, intenta encontrar un dibujo nombrado como el primer argumento en la lista configs y llama a la función initial' para mostrarlo.
- FloatingPic: Define tipos y funciones relacionadas a crear y manipular dibujos de puntos flotantes, en general es para hacer la grilla del fondo de los dibujos cuando se inicializan. Ademas tiene una funcion que se llama vacia que devuelve un tipo de dato llamado blank de la libreria Gloss que devuelve un tipo Picture sin nada, esto lo utilizamos particularmente en el dibujo de Escher cuando el dibujo era igual a False.
- Interp: Define funciones para la interpretacion de contructores de dibujos y luego mostrar la imagen resultante utilizando funciones y tipos de el modulo FloatinPic.
- Dibujo: Define un tipo de dato y funciones para representar y manipular dibujos. Proporciona una estructura jerárquica para los dibujos, permitiendo la composición de elementos simples en otros más complejos. Además, ofrece funciones para aplicar transformaciones y recorrer la estructura del dibujo. En particular tenemos:
    - El tipo de dato Dibujo: Se define utilizando tipos de datos algebraicos (ADTs) para representar diferentes elementos de dibujo y sus composiciones. Permite la creación de dibujos complejos combinando elementos más simples
    - Combinadores: Funcionan como operadores infijos que representan operaciones de dibujo específicas
    - Funciones: 
        - Constructoras: Estas funciones son los bloques de construcción fundamentales para crear dibujos. Sirven para generar elementos de dibujo básicos y combinarlos en estructuras más complejas. Ej : figura, encimar, apilar, juntar, rot45, rotar, espejar
        - Transformadoras: Estas funciones se utilizan para construir dibujos incluso mas complejos con el uso de las funciones constructoras basicas. Ej : r90, r180, r270, encimar4, cuarteto, ciclar
    - Funciones para manipulación: Funciones para manipular y transformar dibujos.
        - `mapDib` sirve para transformaciones elemento a elemento mientras preserva la estructura del dibujo. 
        Aplica una función elemento a elemento a un valor Dibujo, similar a la función map estándar en Haskell.
        Aplica la función proporcionada (f) directamente al valor de datos dentro de Figura. Esto le permite modificar potencialmente las propiedades del elemento (por ejemplo, cambiar su color).
        - change se enfoca en modificar todos los elementos básicos dentro del dibujo, alterando potencialmente los datos y la estructura.
        Modifica todos los elementos básicos (Figura) dentro de un valor Dibujo basado en una función proporcionada.
        Es posible que la función en sí no modifique directamente los datos dentro de Figura. Sin embargo, la función proporcionada (f) que pasa para cambiar puede alterar potencialmente los datos asociados con el elemento Figura.(Esta funcion la utilizamos en cambiar del modulo Pred)
    - Principio de recursión foldDib: Esta función recorre recursivamente la estructura Dibujo, aplicando las funciones proporcionadas para cada tipo de constructor (Figura, Encimar, etc.).
    - Función figuras: Extrae todos los elementos básicos Figura de un Dibujo.
- Pred: Proporciona un conjunto de funciones y definiciones de tipo para trabajar con predicados sobre elementos básicos de dibujo en el módulo Dibujo.Introduce el concepto de Pred a, que representa un predicado que toma un elemento básico de dibujo de tipo a y devuelve un valor Bool que indica si el predicado se cumple para ese elemento.

## ¿Por qué las figuras básicas no están incluidas en la definición del lenguaje, y en vez de eso, es un parámetro del tipo?
El uso de un parámetro de tipo para las figuras básicas permite abstraer el concepto de un "elemento básico de dibujo" y generalizarlo a diferentes tipos de figuras. Esto facilita la creación de funciones y estructuras de datos que operan sobre cualquier tipo de figura básica. De hecho uno de los problemas que tuvimos es que el triangulo que necesitabamos para el dibujo de Escher no era el mismo que el que se utilizo en Feo (puesto que el de Feo tiene un angulo). Al utilizar un parámetro de tipo para las figuras básicas, se permite definir diferentes implementaciones de triángulos (o cualquier otra figura) según las necesidades específicas de cada caso.

## ¿Qué ventaja tiene utilizar una función de `fold` sobre hacer pattern-matching directo?
En nuestro caso usamos foldDib, esta permite encapsular la lógica de recorrido y procesamiento en una única función, separándola del código específico que opera sobre cada elemento del dibujo. Nuestro fold permite ademas agregar funciones particulares para cada cada parte del dibujo (figura, rotacion, encimar, etc.)
Ejemplos :
La función anyFig que verifica si alguna figura básica en un dibujo satisface un predicado ilustra la aplicación de foldDib. En lugar de usar pattern matching para cada tipo de elemento de dibujo, foldDib recorre recursivamente la estructura, aplicando el predicado a cada figura y combinando los resultados utilizando la función ||.
La función interp, que interpreta una salida de texto en una salida de un dibujo, demuestra la aplicación de foldDib para transformar una representación textual en una estructura de dibujo. En lugar de usar pattern matching para cada elemento textual, foldDib recorre la salida, aplicando las funciones de transformación correspondientes a cada tipo de comando textual.

## ¿Cuál es la diferencia entre los predicados definidos en Pred.hs y los tests?
Los predicados definidos en [Pred.hs](./src/Pred.hs) y los tests en [TestPred.hs](./test/TestPred.hs) y [TestDibujo.hs](./test/TestDibujo.hs) tienen propósitos diferentes pero están relacionados.
En [Pred.hs](./src/Pred.hs), los predicados son funciones que toman una figura y devuelven un valor booleano. Estos predicados se utilizan para determinar si una figura cumple con ciertas condiciones. Por ejemplo, el predicado anyFig devuelve True si alguna figura en un dibujo satisface el predicado dado, y allFig devuelve True si todas las figuras en un dibujo satisfacen el predicado dado.
Por otro lado, los tests en [TestPred.hs](./test/TestPred.hs) y [TestDibujo.hs](./test/TestDibujo.hs) utilizan estos predicados para verificar que se comporten como se espera. Cada test define un escenario específico, ejecuta los predicados en ese escenario y luego verifica que el resultado sea el esperado. Por ejemplo, testAnyFig verifica que anyFig devuelva True cuando se le da un dibujo que contiene una figura que satisface el predicado.
Por lo tanto, los predicados en [Pred.hs](./src/Pred.hs) son las funciones que se están probando, y los tests en [TestPred.hs](./test/TestPred.hs) y [TestDibujo.hs](./test/TestDibujo.hs) son los que verifican que estos predicados funcionen correctamente.


# 4. Extras
- En dibujos.cabal se agrego una biblioteca mtl ^>= 2.2.2 que si no estaba causaba error al decir que no existe Control.Monad.RWS (Ap)
- Se agrego el punto extra de agregar --list con la peticion de seleccionar un dibujo.
- Se agrego en pred.hs la definicion de predicados para transformaciones innecesarias generalizadas, basicamente si la transformacion causa que se vuelva a la figura original (identidad) entonces no es necesaria y devuelve True.

# 5. Ejecución
A continuación se mostrarán los comandos a utilizar para visualizar los diversos resultados de salida del proyecto.

- Para visualziar el Escher:
```bash
cabal run dibujos.cabal Escher 
```
- Para visualizar el Feo:
```bash
cabal run dibujos.cabal Feo
```
- Para visualizar el Grilla:
```bash
cabal run dibujos.cabal Grilla
```
- Para visualizar los resultados de los tests de Dibujo:
```bash
cabal test dibujo-tests --test-show-details=streaming
```
- Para visualizar los resultados de los tests de Pred:
```bash
cabal test predicados --test-show-details=streaming
```

# 6. Resultados visuales
A continuación se mostrarán los resultados visuales de los dibujos y tests realizados.

- Dibujo de Escher:
![Escher](https://i.ibb.co/r4T6gMW/Captura-desde-2024-04-23-21-38-56.png)

- Dibujo de Feo:
![Feo](https://i.ibb.co/nQSm0JL/Captura-desde-2024-04-23-21-39-14.png)

- Dibujo de Grilla:
![Grilla](https://i.ibb.co/LYZP84X/Captura-desde-2024-04-23-21-39-23.png)

- Resultados de los tests de Dibujo:
![TestsDibujo](https://i.ibb.co/f8fNQ2v/Captura-desde-2024-04-23-21-40-53.png)

- Resultados de los tests de Pred:
![TestsPred](https://i.ibb.co/k6gY1q9/Captura-desde-2024-04-23-21-41-07.png)