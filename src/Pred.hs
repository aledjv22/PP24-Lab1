module Pred (
  Pred,
  cambiar, anyFig, allFig, orP, andP, falla
) where

import Dibujo


-- `Pred a` define un predicado sobre figuras básicas. Por ejemplo,
-- `(== Triangulo)` es un `Pred TriOCuat` que devuelve `True` cuando la
-- figura es `Triangulo`.

type Pred a = a -> Bool

{-
cambiarFigura :: Pred a -> (a -> Dibujo a) -> a -> Dibujo a
cambiarFigura predicado f fig | predicado fig = f fig
                              | not (predicado fig) = figura fig
-}

-- Dado un predicado sobre figuras básicas, cambiar todas las que satisfacen
-- el predicado por el resultado de llamar a la función indicada por el
-- segundo argumento con dicha figura.
-- Por ejemplo, `cambiar (== Triangulo) (\x -> Rotar (Figura x))` rota
-- todos los triángulos.
cambiar :: Pred a -> (a -> Dibujo a) -> Dibujo a -> Dibujo a
cambiar p f = change (\fig -> if p fig then f fig else figura fig)
-- ETA reduce del dibujo que toma
-- Entra a change con, recursivo hasta llegar a una figura, toma primero esa figura
-- y confirma con el predicado, luego si el predicado es verdadero le aplica 
-- la transformacion




-- Alguna básica satisface el predicado.
anyFig :: Pred a -> Dibujo a -> Bool
anyFig p = foldDib p id id id (\_ _ d1 d2 -> d1 || d2) (\_ _ d1 d2 -> d1 || d2) (||)

-- Todas las figuras satisfacen el predicado.
allFig :: Pred a -> Dibujo a -> Bool
allFig p = foldDib p id id id (\_ _ d1 d2 -> d1 && d2) (\_ _ d1 d2 -> d1 && d2) (&&)


-- Los dos predicados se cumplen para el elemento recibido.
andP :: Pred a -> Pred a -> Pred a
andP p1 p2 p3 = p1 p3 && p2 p3


-- Algún predicado se cumple para el elemento recibido.
orP :: Pred a -> Pred a -> Pred a
orP p1 p2 p3 =  p1 p3 || p2 p3

falla :: Bool
falla = True