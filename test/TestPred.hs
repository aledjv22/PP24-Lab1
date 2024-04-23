module Main (
    main
) where
import Test.HUnit
import Pred (Pred, cambiar, anyFig, allFig)
import Dibujo (Dibujo, figura)

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

tests = TestList [
     testCambiar,
     testAnyFig,
     testAllFig
    ]

main :: IO ()
main = do
    _ <- runTestTT tests
    return ()