module MaxMinCounts where

import Control.Monad
import Control.Monad.Primitive
import Criterion
import Criterion.Main
import qualified Data.Vector as V
import Data.Vector (Vector)
import qualified Data.Vector.Algorithms.Insertion as VA
import qualified Data.Vector.Unboxed as VU
import qualified Data.Vector.Unboxed.Mutable as MV
import Data.Vector.Unboxed.Mutable (MVector)

type ReplicasMtx s = Vector (MVector s Int)

initReplicasMtx :: PrimMonad m => Int -> Int -> m (ReplicasMtx (PrimState m))
initReplicasMtx shards replicas = V.replicateM shards $ MV.replicate replicas 2

printReplicasMtx :: ReplicasMtx (PrimState IO) -> IO ()
printReplicasMtx =
  V.imapM_ (\i row -> putStr (show i ++ ": ") >> VU.freeze row >>= printRow >> putStrLn "")
  where
    printRow = VU.mapM_ (\x -> putStr $ show x ++ " ")

-- | >>> maxReplicaOverlap 1 $ V.empty
-- 0
--
-- >>> maxReplicaOverlap 2 $ V.fromList [3, 1, 2]
-- 2
maxReplicaOverlap :: PrimMonad m => Int -> MVector (PrimState m) Int -> m Int
maxReplicaOverlap minReplicas v
  | MV.length v < minReplicas = return 0
  | otherwise = do
    VA.sort v
    MV.read v $ MV.length v - minReplicas

benchmark :: IO ()
benchmark = do
  v1 <- VU.thaw $ VU.fromList [5, 7, 3, 1, 4, 2, 1, 3, 3, 3, 4]
  --
  mtx <- initReplicasMtx (500 * 8) 16
  MV.write (mtx V.! 203) 8 1
  MV.write (mtx V.! 203) 1 1
  MV.write (mtx V.! 203) 5 1
  --
  defaultMain
    [ bench "maxReplicaOverlap" $ nfIO (maxReplicaOverlap 3 v1),
      bench "computeMaxOverlap" $ nfIO (computeMaxOverlap 14 mtx)
    ]

computeMaxOverlap :: PrimMonad m => Int -> ReplicasMtx (PrimState m) -> m Int
computeMaxOverlap minReplicas mtx =
  V.minimum <$> V.mapM (MV.clone >=> maxReplicaOverlap minReplicas) mtx

test :: IO ()
test = do
  mtx <- initReplicasMtx (500 * 8) 16
  computeMaxOverlap 14 mtx >>= print -- 2
  MV.write (mtx V.! 203) 8 1
  computeMaxOverlap 14 mtx >>= print -- 2
  MV.write (mtx V.! 203) 1 1
  computeMaxOverlap 14 mtx >>= print -- 2
  MV.write (mtx V.! 203) 5 1
  computeMaxOverlap 14 mtx >>= print -- 1
  MV.write (mtx V.! 203) 5 3
  computeMaxOverlap 14 mtx >>= print -- 2
