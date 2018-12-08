{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE RankNTypes #-}

module ForAll where

j :: forall a. [a] -> [a]
j xs = ys ++ ys
  where
    ys :: [a]
    ys = reverse xs

data Showable =
    forall a. Show a =>
              Showable a

g :: [Showable] -> IO ()
g = mapM_ (\(Showable x) -> print x)

h :: IO ()
h = g [Showable (1 :: Int), Showable ("Foo" :: String), Showable False]

{-
 -rank1 :: ([a] -> Int) -> ([b], [c]) -> (Int, Int)
 -rank1 f (x, y) = (f x, f y)
 -
 -rank1 length ("hello", [1, 2, 3])
 -}
rankN :: (forall a. [a] -> Int) -> ([b], [c]) -> (Int, Int)
rankN f (x, y) = (f x, f y)
