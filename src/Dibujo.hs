module Dibujo (
    Dibujo,
    figura, figuras, rotar, espejar, rot45, apilar, juntar, encimar, comp, 
    r180, r270, r90,
    (.-.), (///), (^^^),
    cuarteto, encimar4, ciclar,
    foldDib, mapDib, change
    ) where
import Control.Monad.RWS (Ap)
import Data.Bits (Bits(rotate))

{-
<Dibujo> ::= Figura <Fig> | Rotar <Dibujo> | Espejar <Dibujo> 
    | Rot45 <Dibujo>
    | Apilar <Float> <Float> <Dibujo> <Dibujo> 
    | Juntar <Float> <Float> <Dibujo> <Dibujo> 
    | Encimar <Dibujo> <Dibujo>
-}

-- nuestro lenguaje 
data Dibujo a = Figura a
    | Rotar (Dibujo a)
    | Espejar (Dibujo a)
    | Rot45 (Dibujo a)
    | Apilar Float Float (Dibujo a) (Dibujo a)
    | Juntar Float Float (Dibujo a) (Dibujo a)
    | Encimar (Dibujo a) (Dibujo a)
    deriving (Eq, Show)

-- combinadores
infixr 6 ^^^

infixr 7 .-.

infixr 8 ///

comp :: Int -> (a -> a) -> a -> a
comp 0 f x = x
comp n f x | n > 0 = f (comp (n - 1) f x)
           | otherwise = error "Error: No se puede componer una funcion con valores negativos"

-- Funciones constructoras
figura :: a -> Dibujo a
figura = Figura

encimar :: Dibujo a -> Dibujo a -> Dibujo a
encimar = Encimar

apilar :: Float -> Float -> Dibujo a -> Dibujo a -> Dibujo a
apilar = Apilar

juntar  :: Float -> Float -> Dibujo a -> Dibujo a -> Dibujo a
juntar = Juntar

rot45 :: Dibujo a -> Dibujo a
rot45 = Rot45

rotar :: Dibujo a -> Dibujo a
rotar dib = case dib of 
    Rotar (Rotar (Rotar dib_rot)) -> dib_rot
    _ -> Rotar dib

espejar :: Dibujo a -> Dibujo a
espejar = Espejar

-- Superpone un dibujo con otro.
(^^^) :: Dibujo a -> Dibujo a -> Dibujo a
(^^^) = encimar

-- Pone el primer dibujo arriba del segundo, ambos ocupan el mismo espacio.
(.-.) :: Dibujo a -> Dibujo a -> Dibujo a
(.-.) = apilar 1 1

-- Pone un dibujo al lado del otro, ambos ocupan el mismo espacio.
(///) :: Dibujo a -> Dibujo a -> Dibujo a
(///) = juntar 1 1

{- en /// y .-. puse como parametros 1 1 porque en la pagina 4 del enunciado 
esta asi el ejemplo, pero hay que verificar -}

-- rotaciones
r90 :: Dibujo a -> Dibujo a
r90 = rotar

r180 :: Dibujo a -> Dibujo a -- r180 a = rotar (rotar a)
r180 = comp 2 rotar

r270 :: Dibujo a -> Dibujo a -- r270 a = rotar (rotar (rotar a))
r270 = comp 3 rotar

-- una figura repetida con las cuatro rotaciones, superimpuestas.
encimar4 :: Dibujo a -> Dibujo a
encimar4 a = (^^^) ((^^^) a (r90 a)) ((^^^) (r180 a) (r270 a))

-- cuatro figuras en un cuadrante.
cuarteto :: Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a
cuarteto d1 d2 d3 d4 = (.-.) ((///) d1 d2) ((///) d3 d4)

-- un cuarteto donde se repite la imagen, rotada (¡No confundir con encimar4!)
ciclar :: Dibujo a -> Dibujo a
ciclar d = cuarteto d (r90 d) (r180 d) (r270 d)

-- map para nuestro lenguaje
mapDib :: (a -> b) -> Dibujo a -> Dibujo b
mapDib f d = case d of
    Figura fig -> Figura (f fig)
    Encimar d1 d2 -> Encimar (mapDib f d1) (mapDib f d2)
    Apilar n1 n2 d1 d2 -> Apilar n1 n2 (mapDib f d1) (mapDib f d2)
    Juntar n1 n2 d1 d2 -> Juntar n1 n2 (mapDib f d1) (mapDib f d2)
    Rot45 dib -> Rot45 (mapDib f dib)
    Rotar dib -> Rotar (mapDib f dib)
    Espejar dib -> Espejar (mapDib f dib)

-- verificar que las operaciones satisfagan
-- 1. map figura = id
-- 2. map (g . f) = mapDib g . mapDib f

-- Cambiar todas las básicas de acuerdo a la función.
change :: (a -> Dibujo b) -> Dibujo a -> Dibujo b
change f d = case d of
    Figura fig -> f fig
    Encimar d1 d2 -> Encimar (change f d1) (change f d2)
    Apilar n1 n2 d1 d2 -> Apilar n1 n2 (change f d1) (change f d2)
    Juntar n1 n2 d1 d2 -> Juntar n1 n2 (change f d1) (change f d2)
    Rot45 dib -> Rot45 (change f dib)
    Rotar dib -> Rotar (change f dib)
    Espejar dib -> Espejar (change f dib)

{-
*mapDib sirve para transformaciones elemento a elemento mientras preserva la estructura del dibujo. 
    Aplica una función elemento a elemento a un valor Dibujo, similar a la función map estándar en Haskell.
    Aplica la función proporcionada (f) directamente al valor de datos dentro de Figura. Esto le permite
    modificar potencialmente las propiedades del elemento (por ejemplo, cambiar su color).
*change se enfoca en modificar todos los elementos básicos dentro del dibujo, alterando potencialmente los datos y la estructura.
    Modifica todos los elementos básicos (Figura) dentro de un valor Dibujo basado en una función proporcionada.
    Es posible que la función en sí no modifique directamente los datos dentro de Figura. Sin embargo, la función
    proporcionada (f) que pasa para cambiar puede alterar potencialmente los datos asociados con el elemento Figura.

-}

-- Principio de recursión para Dibujos.
foldDib ::
  (a -> b) ->
  (b -> b) ->
  (b -> b) ->
  (b -> b) ->
  (Float -> Float -> b -> b -> b) ->
  (Float -> Float -> b -> b -> b) ->
  (b -> b -> b) ->
  Dibujo a ->
  b
foldDib fFigura fRotar fEspejar fRotar45 fApilar fJuntar fEncimar d = case d of
    Figura fig -> fFigura fig
    Encimar d1 d2 -> fEncimar (foldDib fFigura fRotar fEspejar fRotar45 fApilar fJuntar fEncimar d1)
                            (foldDib fFigura fRotar fEspejar fRotar45 fApilar fJuntar fEncimar d2)
    Apilar n1 n2 d1 d2 -> fApilar n1 n2 (foldDib fFigura fRotar fEspejar fRotar45 fApilar fJuntar fEncimar d1)
                                        (foldDib fFigura fRotar fEspejar fRotar45 fApilar fJuntar fEncimar d2)
    Juntar n1 n2 d1 d2 -> fJuntar n1 n2 (foldDib fFigura fRotar fEspejar fRotar45 fApilar fJuntar fEncimar d1)
                                        (foldDib fFigura fRotar fEspejar fRotar45 fApilar fJuntar fEncimar d2)
    Rot45 dib -> fRotar45 (foldDib fFigura fRotar fEspejar fRotar45 fApilar fJuntar fEncimar dib)
    Rotar dib -> fRotar (foldDib fFigura fRotar fEspejar fRotar45 fApilar fJuntar fEncimar dib)
    Espejar dib -> fEspejar (foldDib fFigura fRotar fEspejar fRotar45 fApilar fJuntar fEncimar dib)

-- Extrae todas las figuras básicas de un dibujo.
figuras :: Dibujo a -> [a]
figuras d = case d of
    Figura fig -> [fig]
    Encimar d1 d2 -> figuras d1 ++ figuras d2 
    Apilar _ _ d1 d2 -> figuras d1 ++ figuras d2 
    Juntar _ _ d1 d2 -> figuras d1 ++ figuras d2
    Rot45 dib -> figuras dib
    Rotar dib -> figuras dib 
    Espejar dib -> figuras dib

