module Dibujos.Grilla (
    grilla, grillaConf
) where

import Dibujo (Dibujo, figura, juntar, apilar)
import FloatingPic(Conf(..), Output)
import Graphics.Gloss (text, translate, scale)

type CoordX = Int
type CoordY = Int

type Basica = (CoordX, CoordY) -- d

-- type Output a = a -> FloatingPic
-- type FloatingPic = Vector -> Vector -> Vector -> Picture
-- type Output a = a -> Vector -> Vector -> Vector -> Picture
interpCoord :: Output Basica
interpCoord (x, y) _ _ _ = translate (fromIntegral y*80 + 26) (fromIntegral (-(x*80) + 760)) (scale 0.1 0.1 (text (show (x, y))))
-- Entonces scale me da una imagen escalada a 1/10 de la original, la original siendo una
-- imagen formada a partir de una fuente de vectores, le damos a text el string de show 
-- de los vectores coordenada x,y.
-- Con esto translate utiliza las coordenadas, que manipulamos para que hagan grillas 
-- 8x8, y el dibujo que son las coordenadas, para devolver una imagen.
-- Quedo bastante similar al del word :D

-- Translate Float Float Picture: A picture translated by the given x and y coordinates.
-- Text String: Some text to draw with a vector font.
-- Scale Float Float Picture: A picture scaled by the given x and y factors.

row :: [Dibujo a] -> Dibujo a
row [] = error "row: no puede ser vacío"
row [d] = d
row (d:ds) = juntar (fromIntegral $ length ds) 1 d (row ds)

column :: [Dibujo a] -> Dibujo a
column [] = error "column: no puede ser vacío"
column [d] = d
column (d:ds) = apilar (fromIntegral $ length ds) 1 d (column ds)

grilla :: [[Dibujo a]] -> Dibujo a
grilla = column . map row

useGrilla :: Dibujo Basica
useGrilla = grilla [[ figura (x, y) | x <- [0..7] , y <- [0..7] ]]


grillaConf :: Conf
grillaConf = Conf {
    name = "Grilla"
    , pic = useGrilla
    , bas = interpCoord -- usa interp de interp.hs automaticamente, realmente creo que usa map.
}