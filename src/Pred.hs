module Pred (
  Pred,
  cambiar, anyDib, allDib, orP, andP, falla
) where

import Dibujo


-- `Pred a` define un predicado sobre figuras básicas. Por ejemplo,
-- `(== Triangulo)` es un `Pred TriOCuat` que devuelve `True` cuando la
-- figura es `Triangulo`.

type Pred a = a -> Bool

-- Dado un predicado sobre figuras básicas, cambiar todas las que satisfacen
-- el predicado por el resultado de llamar a la función indicada por el
-- segundo argumento con dicha figura.
-- Por ejemplo, `cambiar (== Triangulo) (\x -> Rotar (Figura x))` rota
-- todos los triángulos.
cambiar :: Pred a -> (a -> Dibujo a) -> Dibujo a -> Dibujo a
cambiar p f =  undefined




-- Alguna básica satisface el predicado.
anyDib = undefined

-- Todas las básicas satisfacen el predicado.
allDib = undefined

-- Los dos predicados se cumplen para el elemento recibido.
andP = undefined

-- Algún predicado se cumple para el elemento recibido.
orP = undefined

falla = True