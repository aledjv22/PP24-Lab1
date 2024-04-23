{-# LANGUAGE LambdaCase #-}
module Main (
  main
) where

import Test.HUnit
import Dibujo (Dibujo, r90, r180, r270, espejar, figura)

testDibujo = figura ()

-- Test that rotating a Dibujo 180 degrees twice returns the original Dibujo
testRot180 = TestCase $ assertEqual "Rotation 180 degrees twice" expected result
  where
    expected = testDibujo
    result = r180 $ r180 testDibujo

-- Test que espejar un Dibujo dos veces devuelve el Dibujo original
testEspejar = TestCase $ assertEqual "Espejar dos veces" expected result
  where
    expected = testDibujo
    result = espejar $ espejar testDibujo

-- Test que rotar un Dibujo 90 grados cuatro veces devuelve el Dibujo original
testRot90 = TestCase $ assertEqual "Rotar 90 grados cuatro veces" expected result
  where
    expected = testDibujo
    result = r90 $ r90 $ r90 $ r90 testDibujo

-- Test que rotar un Dibujo 270 grados seguido de una rotación de 90 grados devuelve el Dibujo original
testRot270 = TestCase $ assertEqual "Rotar 270 grados y luego 90 grados" expected result
  where
    expected = testDibujo
    result = r90 $ r270 testDibujo

tests = TestList [
   testRot180,
   testEspejar
  ]

main :: IO ()
main = do
  _ <- runTestTT tests
  return ()