module Continuation where

fac :: Int -> Int
fac = facCps id

facCps :: (Int -> Int) -> Int -> Int
facCps cont 0 = cont 1
facCps cont n = facCps (cont . (n *)) $ n - 1

fib :: Int -> Int
fib n
  | n < 2 = n
  | otherwise = fib (n - 1) + fib (n - 2)

fibCps :: (Int -> Int) -> Int -> Int
fibCps cont n
  | n < 2 = cont n
  | otherwise = fibCps (\x -> fibCps (\y -> cont $ x + y) (n - 2)) (n - 1)
