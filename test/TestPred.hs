module Main (
    main
) where
import Test.HUnit
import Pred (Pred, cambiar, anyFig, allFig, orP, andP, falla, esTransNoNes)
import Dibujo (Dibujo, figura, rotar)

-- Tests para 'cambiar'
testCambiar = TestCase $ assertEqual "Cambiar" expected result
    where
        predicado :: Pred String
        predicado = (== "a")
        transformacion :: String -> Dibujo String
        transformacion = figura
        dibujo = figura "a"
        expected = transformacion "a"
        result = cambiar predicado transformacion dibujo

-- Tests para 'anyFig'
testAnyFig = TestCase $ assertEqual "AnyFig" expected result
    where
        predicado :: Pred String
        predicado = (== "a")
        dibujo = figura "a"
        expected = True
        result = anyFig predicado dibujo

-- Tests para 'allFig'
testAllFig = TestCase $ assertEqual "AllFig" expected result
    where
        predicado :: Pred String
        predicado = (== "a")
        dibujo = figura "a"
        expected = True
        result = allFig predicado dibujo

-- Tests para 'andP'
testAndP = TestCase $ assertEqual "AndP" expected result
    where
        predicado1 :: Pred String
        predicado1 = (== "a")
        predicado2 :: Pred String
        predicado2 = (== "b")
        elemento = "a"
        expected = False
        result = andP predicado1 predicado2 elemento

-- Tests para 'orP'
testOrP = TestCase $ assertEqual "OrP" expected result
    where
        predicado1 :: Pred String
        predicado1 = (== "a")
        predicado2 :: Pred String
        predicado2 = (== "b")
        elemento = "a"
        expected = True
        result = orP predicado1 predicado2 elemento

-- Tests para 'falla'
testFalla = TestCase $ assertEqual "Falla" expected result
    where
        expected = True
        result = falla

-- Tests para 'esTransNoNes'
testEsTransNoNes = TestCase $ assertEqual "EsTransNoNes" expected result
    where
        transformacion :: Dibujo String -> Dibujo String
        transformacion = rotar
        dibujo = figura "a"
        expected = False
        result = esTransNoNes transformacion dibujo

tests = TestList [
     testCambiar,
     testAnyFig,
     testAllFig,
     testAndP,
     testOrP,
     testFalla,
     testEsTransNoNes
    ]

main :: IO ()
main = do
  results <- runTestTT tests
  putStrLn $ "\nNúmero de tests ejecutados: " ++ show (cases results)
  putStrLn $ "\nNúmero de tests que pasaron: " ++ show (tried results - errors results - failures results)
  putStrLn $ "\nNúmero de errores: " ++ show (errors results)
  putStrLn $ "\nNúmero de fallos: " ++ show (failures results)