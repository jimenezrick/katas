module Has where

import Data.Set

data Thing = Thing
    deriving (Show, Eq, Ord)

class HasThings a where
  getThings :: a -> Set Thing

newtype ThisThings = ThisThings { getThisThings :: [Thing] }
    deriving Show

data OtherThing = OtherThing
    { one :: Maybe Thing
    , other :: Thing
    } deriving Show






instance HasThings ThisThings where
  getThings = fromList . getThisThings
