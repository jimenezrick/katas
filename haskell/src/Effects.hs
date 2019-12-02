--{-# OPTIONS_GHC -fplugin=Polysemy.Plugin #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE GADTs, FlexibleContexts, TypeOperators, DataKinds,
  PolyKinds, ScopedTypeVariables #-}
{-# LANGUAGE LambdaCase, BlockArguments #-}

module Effects where

import Polysemy
import Polysemy.Input
import Polysemy.Output

data Teletype m a where
  ReadTTY :: Teletype m String
  WriteTTY :: String -> Teletype m ()

makeSem ''Teletype

teletypeToIO :: Member (Embed IO) r => Sem (Teletype ': r) a -> Sem r a
teletypeToIO =
  interpret $ \case
    ReadTTY -> embed getLine
    WriteTTY msg -> embed $ putStrLn msg

echo :: Member Teletype r => Sem r ()
echo = do
  i <- readTTY
  case i of
    "" -> pure ()
    _ -> writeTTY i >> echo

main :: IO ()
main = runM . teletypeToIO $ echo
