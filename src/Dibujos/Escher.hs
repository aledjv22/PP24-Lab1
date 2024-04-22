module Dibujos.Escher
(
    escher, escherConf
) where


import Dibujo (Dibujo, figura, encimar4, juntar, apilar, rot45, rotar, encimar, espejar, cuarteto, r270, r180)
import FloatingPic(Conf(..), Output, half, vacia)
import qualified Graphics.Gloss.Data.Point.Arithmetic as V
import Graphics.Gloss ( Picture, blue, red, azure, color, line, pictures )

interpEscher :: Output Escher
interpEscher fig x y w = if fig then pictures [color azure (line $ map (x V.+) [(0,0), y, w, (0,0)])]  else vacia x y w
-- vacia = blank pero de Graphics.Gloss, esta en FloatingPic

-- Supongamos que eligen.
type Escher = Bool

blank :: Bool
blank = False



fish2 p = espejar (rot45 p)

fish3 p = r270 (fish2 p)

-- El dibujo u.
dibujoU :: Dibujo Escher -> Dibujo Escher
dibujoU p = encimar4 (fish2 p)

-- El dibujo t.
dibujoT :: Dibujo Escher -> Dibujo Escher
dibujoT p = encimar
            p
            (encimar
                (fish2 p)
                (fish3 p))

{-
lado(1, f) = cuarteto(blank, blank, rotar(dibujo_t(f)), dibujo_t(f))
lado(2, f) = cuarteto(lado(1, f), lado(1, f), rotar(f), f)
esquina(1, f) = cuarteto(blank, blank, blank, dibujo_u(f))
esquina(2, f) = cuarteto(esquina(1, f), lado(1, f), rotar(lado(1, f)), dibujo_u(f))
-}

-- Esquina con nivel de detalle en base a la figura p.
esquina :: Int -> Dibujo Escher -> Dibujo Escher
esquina 1 dib = cuarteto (figura blank) (figura blank) (figura blank) (dibujoU dib)
esquina n dib = cuarteto (esquina (n-1) dib) (lado (n-1) dib) (rotar (lado (n-1) dib)) (dibujoU dib)

-- Lado con nivel de detalle.
lado :: Int -> Dibujo Escher -> Dibujo Escher
lado 1 dib = cuarteto (figura blank) (figura blank) (rotar (dibujoT dib)) (dibujoT dib)
lado n dib = cuarteto (lado (n-1) dib) (lado (n-1) dib) (rotar (dibujoT dib)) (dibujoT dib)

-- Por suerte no tenemos que poner el tipo!
noneto p q r s t u v w x = apilar 1 2
                            (juntar 1 2 p (juntar 1 1 q r))
                            (apilar 1 1 (juntar 1 2 s (juntar 1 1 t u)) (juntar 1 2 v (juntar 1 1 w x)))
{-
nonet(p, q, r,
s, t, u,
v, w, x) =
above(1,2,beside(1,2,p,beside(1,1,q,r)),
above(1,1,beside(1,2,s,beside(1,1,t,u)),
beside(1,2,v,beside(1,1,w,x))))
-}

-- El dibujo de Escher:
escher :: Int -> Escher -> Dibujo Escher
escher n f = noneto
    (esquina n (figura f))
    (lado n (figura f))
    (r270 (esquina n (figura f)))
    (rotar (lado n (figura f)) )
    (dibujoU (figura f))
    (r270 (lado n (figura f)))
    (rotar (esquina n (figura f)))
    (r180 (lado n (figura f)))
    (r180 (esquina n (figura f)))


row :: [Dibujo a] -> Dibujo a
row [] = error "row: no puede ser vacío"
row [d] = d
row (d:ds) = juntar 1 (fromIntegral $ length ds) d (row ds)

column :: [Dibujo a] -> Dibujo a
column [] = error "column: no puede ser vacío"
column [d] = d
column (d:ds) = apilar 1 (fromIntegral $ length ds) d (column ds)

grilla :: [[Dibujo a]] -> Dibujo a
grilla = column . map row

useGrilla :: Dibujo Escher
useGrilla = grilla [[escher 2 True]]
-- el valor de escher (en este caso 2) se puede
-- modificar para definir el nivel de profuncidad
-- 17 parece ser el limite en donde carga en un 
-- tiempo razonable (al menos en mi PC)

escherConf :: Conf
escherConf = Conf {
    name = "Escher"
    , pic = useGrilla
    , bas = interpEscher -- usa interp de interp.hs automaticamente, realmente creo que usa map.
}