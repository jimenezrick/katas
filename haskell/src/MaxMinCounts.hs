{-# LANGUAGE TupleSections #-}

module MaxMinCounts where

import Control.Monad
import Control.Monad.Primitive
import Criterion
import Criterion.Main
import Data.List (foldl')
import Data.Set (Set)
import qualified Data.Set as S
import qualified Data.Vector as V
import Data.Vector (Vector)
import qualified Data.Vector.Algorithms.Insertion as VA
import qualified Data.Vector.Unboxed as VU
import qualified Data.Vector.Unboxed.Mutable as MV
import Data.Vector.Unboxed.Mutable (MVector)

type MinMaxCounts s = (Int, Int, Vector (MVector s Int), Set (Int, Int))

initMinMaxCounts :: PrimMonad m => Int -> Int -> Int -> Int -> m (MinMaxCounts (PrimState m))
initMinMaxCounts initVal mc shards replicas = do
  mx <- V.replicateM shards $ MV.replicate replicas initVal
  l <- V.imapM (\i -> ((,i) <$>) . (MV.clone >=> countMax mc)) mx
  let s = S.fromList $ V.toList l
  return (mc, fst $ S.findMin s, mx, s)

minMaxCount :: PrimMonad m => MinMaxCounts (PrimState m) -> m Int
minMaxCount (_, min', _, _) = return min'

minCount :: PrimMonad m => MinMaxCounts (PrimState m) -> m Int
minCount (mc, _, _, _) = return mc

updateMinMaxCounts :: PrimMonad m => [(Int, Int, Int)] -> MinMaxCounts (PrimState m) -> m (MinMaxCounts (PrimState m))
updateMinMaxCounts changes (mc, _, mx, maxSet) =
  do
    setChanges <-
      forM changes $
        \(shard, replica, new) -> do
          oldCount <- MV.clone (mx V.! shard) >>= countMax mc
          writeMx shard replica new
          newCount <- MV.clone (mx V.! shard) >>= countMax mc
          return (shard, (oldCount, newCount))
    let newMaxSet = updateMaxSet setChanges maxSet
    return (mc, fst $ S.findMin newMaxSet, mx, newMaxSet)
  where
    writeMx shard replica val = MV.write (mx V.! shard) replica val

updateMaxSet :: [(Int, (Int, Int))] -> Set (Int, Int) -> Set (Int, Int)
updateMaxSet changes = insertions . removals
  where
    removals = flip (foldl' (\s (shard, (oldCount, _)) -> S.delete (oldCount, shard) s)) changes
    insertions = flip (foldl' (\s (shard, (_, newCount)) -> S.insert (newCount, shard) s)) changes

printMinMaxCounts :: MinMaxCounts (PrimState IO) -> IO ()
printMinMaxCounts (mc, min', mx, maxSet) = do
  putStrLn $ "minCount: " ++ show mc
  putStrLn $ "min: " ++ show min'
  putStrLn $ "maxSet: " ++ show maxSet
  putStrLn "matrix:"
  V.imapM_ (\i row -> putStr ("(" ++ show i ++ ") ") >> VU.freeze row >>= printRow >> putStrLn "") mx
  where
    printRow = VU.mapM_ (\x -> putStr $ show x ++ " ")

countMax :: PrimMonad m => Int -> MVector (PrimState m) Int -> m Int
countMax mc v
  | MV.length v < mc = return 0
  | otherwise = do
    VA.sort v
    MV.read v $ MV.length v - mc

benchmark :: IO ()
benchmark = do
  mmc <- initMinMaxCounts 2 14 (500 * 8) 16
  defaultMain
    [ bench "updateMinMaxCounts" $ nfIO (updateMinMaxCounts changes mmc >>= updateMinMaxCounts undos)
    ]
  where
    changes = [(203, 8, 1), (203, 1, 1), (203, 5, 1)]
    undos = [(203, 8, 2), (203, 1, 2), (203, 5, 2)]

test :: IO ()
test = do
  mmc <- initMinMaxCounts 2 14 (500 * 8) 16
  minMaxCount mmc >>= print -- 2
  mmc <- updateMinMaxCounts [(203, 8, 1)] mmc
  minMaxCount mmc >>= print -- 2
  mmc <- updateMinMaxCounts [(203, 1, 1)] mmc
  minMaxCount mmc >>= print -- 2
  mmc <- updateMinMaxCounts [(203, 5, 1)] mmc
  minMaxCount mmc >>= print -- 1
  mmc <- updateMinMaxCounts [(203, 5, 3)] mmc
  minMaxCount mmc >>= print -- 2
