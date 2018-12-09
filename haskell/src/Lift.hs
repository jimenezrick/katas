{-# LANGUAGE FlexibleContexts #-}

module Lift where

import Control.Monad.Reader
import UnliftIO

type Env = ReaderT Int IO

run :: Env ()
run = doN (liftIO $ print "now")

-- This is like vanilla replicateM_ but fixed on the IO monad to show how UnliftIO helps here
doNIO :: Int -> IO a -> IO ()
doNIO = replicateM_

-- This is the unlifted version that works back again on any monad supported by UnliftIO
doN :: (MonadReader Int m, MonadUnliftIO m) => m a -> m ()
doN f = do
    n <- ask
    -- This doesn't work given the type signature of doNIO
    --liftIO $ doNIO n f
    -- Here we are able to run doNIO on monad m
    withRunInIO $ \runInIO -> doNIO n (runInIO f)

test :: IO ()
test = runReaderT run 3
