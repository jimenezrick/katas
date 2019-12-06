{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators #-}
{-# OPTIONS_GHC -fplugin=Polysemy.Plugin #-}

module Effects2 where

import Polysemy
import Polysemy.Input
import Polysemy.Output
import Polysemy.State

newtype Total a
  = Total
      { getTotal :: a
      }
  deriving (Show, Functor)

data Counter m a where
  Add :: Int -> Counter m ()
  Get :: Counter m Int

makeSem ''Counter

runCounterIO :: Members '[State (Total Int), Embed IO] r => Sem (Counter ': r) a -> Sem r a
runCounterIO = interpret \case
  Add inc -> do
    embed $ putStrLn $ "Add"
    modify $ fmap (+ inc)
