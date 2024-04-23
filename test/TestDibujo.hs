{-# LANGUAGE LambdaCase #-}
module Main (
  main
) where

import Test.HUnit
import Dibujo (Dibujo, r90, r180, r270, espejar, apilar, juntar, encimar)
import Dibujo (encimar4, ciclar, figura, figuras, rot45, mapDib)

testDibujo = figura ()

-- Tests para 'figura'
testFigura = TestCase $ assertEqual "Figura" expected result
  where
    expected = figura "a"
    result = figura "a"

-- Tests para 'rot45', 'r90', 'r180', 'r270'
testRot180 = TestCase $ assertEqual "Rotation 180 degrees twice" expected result
  where
    expected = testDibujo
    result = r180 $ r180 testDibujo

testRot45 = TestCase $ assertEqual "Rotar 45 grados" expected result
  where
    expected = rot45 testDibujo
    result = rot45 testDibujo

testRot90 = TestCase $ assertEqual "Rotar 90 grados cuatro veces" expected result
  where
    expected = testDibujo
    result = r90 $ r90 $ r90 $ r90 testDibujo

testRot270 = TestCase $ assertEqual "Rotar 270 grados y luego 90 grados" expected result
  where
    expected = testDibujo
    result = r90 $ r270 testDibujo

-- Tests para 'espejar'
testEspejar = TestCase $ assertEqual "Espejar dos veces" expected result
  where
    expected = testDibujo
    result = espejar $ espejar testDibujo

-- Tests para 'apilar' y 'juntar'
testApilar = TestCase $ assertEqual "Apilar" expected result
  where
    expected = apilar 0.5 0.5 (figura "a") (figura "b")
    result = apilar 0.5 0.5 (figura "a") (figura "b")

testJuntar = TestCase $ assertEqual "Juntar" expected result
  where
    expected = juntar 0.5 0.5 (figura "a") (figura "b")
    result = juntar 0.5 0.5 (figura "a") (figura "b")

-- Tests para 'encimar' y 'encimar4'
testEncimar = TestCase $ assertEqual "Encimar" expected result
  where
    expected = encimar (figura "a") (figura "b")
    result = encimar (figura "a") (figura "b")

testEncimar4 = TestCase $ assertEqual "Encimar4" expected result
  where
    expected = encimar4 (figura "a")
    result = encimar4 (figura "a")

-- Tests para 'ciclar'
testCiclar = TestCase $ assertEqual "Ciclar" expected result
  where
    expected = ciclar (figura "a")
    result = ciclar (figura "a")

-- Test para 'figuras'
testFiguras = TestCase $ assertEqual "Figuras" expected result
  where
    dibujo = apilar 0.5 0.5 (figura "a") (figura "b")
    expected = ["a", "b"]
    result = figuras dibujo

testMapDib = TestCase $ assertEqual "mapDib" expected result
  where
    expected = figura "b"
    result = mapDib (\_ -> "b") (figura "a")

tests = TestList [
   testFigura,
   testRot45,
   testRot90,
   testRot180,
   testRot270,
   testEspejar,
   testApilar,
   testJuntar,
   testEncimar,
   testEncimar4,
   testCiclar,
   testFiguras,
   testMapDib
  ]

main :: IO ()
main = do
  results <- runTestTT tests
  putStrLn $ "\nNúmero de tests ejecutados: " ++ show (cases results)
  putStrLn $ "\nNúmero de tests que pasaron: " ++ show (tried results - errors results - failures results)
  putStrLn $ "\nNúmero de errores: " ++ show (errors results)
  putStrLn $ "\nNúmero de fallos: " ++ show (failures results)