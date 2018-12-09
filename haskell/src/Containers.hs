{-# LANGUAGE FlexibleContexts #-}

module Containers where

import Control.Exception.Safe
import Data.Containers as C
import Data.Map as M

lookupTwo :: IsMap a => (ContainerKey a, ContainerKey a) -> a -> Maybe (MapValue a, MapValue a)
lookupTwo (k1, k2) m = do
    v1 <- C.lookup k1 m
    v2 <- C.lookup k2 m
    Just (v1, v2)

bothEqual :: (IsMap a, Eq (MapValue a), MonadThrow m) => (a -> m (MapValue a, MapValue a)) -> a -> m Bool
bothEqual f m = do
    (v1, v2) <- f m
    return (v1 == v2)

test1 :: Maybe (Int, Int)
test1 = lookupTwo ("xxx", "bar") $ M.fromList [("foo", 1), ("bar", 2)]

test2 :: Maybe Bool
test2 = bothEqual (lookupTwo ("foo", "bar")) $ M.fromList [("foo", 1 :: Int), ("bar", 1 :: Int)]
