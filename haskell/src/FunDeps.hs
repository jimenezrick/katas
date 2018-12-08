{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FunctionalDependencies #-}

--
-- https://ocharles.org.uk/posts/2014-12-14-functional-dependencies.html
--
module FunDeps where

class Convertible a b | b -> a where
    convert :: a -> b

instance Convertible Int String where
    convert = show

instance Convertible () () where
    convert = id

test :: IO ()
test = do
    putStrLn $ convert (123 :: Int)
    putStrLn $ convert 123
    return $ convert ()
