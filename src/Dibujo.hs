module Dibujo (
    Dibujo,
    figura, rotar, espejar, rot45, apilar, juntar, encimar,
    r180, r270,
    (.-.), (///), (^^^),
    cuarteto, encimar4, ciclar,
    foldDib, mapDib,
    --figura
    ) where

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
    | Apilar (Float) (Float) (Dibujo a) (Dibujo a) 
    | Juntar (Float) (Float) (Dibujo a) (Dibujo a) 
    | Encimar (Dibujo a) (Dibujo a)
    deriving (Eq, Show)

-- combinadores
infixr 6 ^^^

infixr 7 .-.

infixr 8 ///

comp :: Int -> (a -> a) -> a -> a
comp n f = undefined


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
rotar = Rotar


espejar :: Dibujo a -> Dibujo a
espejar = undefined

-- Superpone un dibujo con otro.
(^^^) :: Dibujo a -> Dibujo a -> Dibujo a
(^^^) a b = encimar a b 

-- Pone el primer dibujo arriba del segundo, ambos ocupan el mismo espacio.
(.-.) :: Dibujo a -> Dibujo a -> Dibujo a
(.-.) x y = apilar 1 1 x y

-- Pone un dibujo al lado del otro, ambos ocupan el mismo espacio.
(///) :: Dibujo a -> Dibujo a -> Dibujo a
(///) a b = juntar 1 1 a b

{- en /// y .-. puse como parametros 1 1 porque en la pagina 4 del enunciado 
esta asi el ejemplo, pero hay que verificar -}

-- rotaciones
r90 :: Dibujo a -> Dibujo a
r90 = rotar

r180 :: Dibujo a -> Dibujo a -- r180 a = rotar (rotar a)
r180 = rotar . rotar 

r270 :: Dibujo a -> Dibujo a -- r270 a = rotar (rotar (rotar a))
r270 = rotar . rotar . rotar

-- una figura repetida con las cuatro rotaciones, superimpuestas.
encimar4 :: Dibujo a -> Dibujo a
encimar4 a = (^^^) ((^^^) a (rotar a)) ((^^^) (r180 a) (r270 a))

-- cuatro figuras en un cuadrante.
cuarteto :: Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a
cuarteto d1 d2 d3 d4 = (.-.) ((///) d1 d2) ((///) d3 d4)

-- un cuarteto donde se repite la imagen, rotada (¡No confundir con encimar4!)
ciclar :: Dibujo a -> Dibujo a
ciclar a = (.-.)((///) a (rotar a)) ((///) (r180 a) (r270 a))
{- verificar si esto esta bien -}

-- map para nuestro lenguaje
mapDib :: (a -> b) -> Dibujo a -> Dibujo b
mapDib = undefined
-- verificar que las operaciones satisfagan
-- 1. map figura = id
-- 2. map (g . f) = mapDib g . mapDib f

-- Cambiar todas las básicas de acuerdo a la función.
change :: (a -> Dibujo b) -> Dibujo a -> Dibujo b
change = undefined

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
foldDib = undefined