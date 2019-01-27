{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}

--
-- https://www.reddit.com/r/haskell/comments/6jy8yu/the_has_type_class_pattern/
--
module Has where

import Control.Monad.Reader
import Data.Has
import Data.Set (Set)
import Data.Set as S
import Lens.Micro.Platform

data Thing =
    Thing
    deriving (Show, Eq, Ord)

class HasThings a where
    getThings :: a -> Set Thing

newtype ThisThings = ThisThings
    { getThisThings :: [Thing]
    } deriving (Show)

data OtherThing = OtherThing
    { one :: Maybe Thing
    , other :: Thing
    } deriving (Show)

instance HasThings Thing where
    getThings = S.singleton

instance HasThings ThisThings where
    getThings = S.fromList . getThisThings

this :: (MonadReader r m, HasThisEnv r) => m Bool
this = do
    e <- asks getThisEnv
    return (e == 0)

that :: (MonadReader r m, HasThatEnv r) => m Int
that = do
    e <- asks getThatEnv
    return (read e)

class HasThisEnv a where
    getThisEnv :: a -> Int

class HasThatEnv a where
    getThatEnv :: a -> String

instance HasThisEnv (Int, String) where
    getThisEnv = fst

instance HasThatEnv (Int, String) where
    getThatEnv = snd

thisAndThat :: Reader (Int, String) Int
thisAndThat = do
    b <- this
    n <- that
    if b
        then return n
        else return (n + 1)

takeList :: Has [Int] a => a -> [Int]
takeList a = a ^. hasLens

test :: (Bool, [Int]) -> [Int]
test = takeList
