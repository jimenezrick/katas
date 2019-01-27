{-# LANGUAGE FlexibleContexts #-}

module Error where

import Control.Monad.Except

test1 :: IO (Either String Int)
test1 = runExceptT fail1

test2 :: IO (Either String Int)
test2 = runExceptT fail2

fail1 :: (MonadError String m, MonadIO m) => m Int
fail1 = do
    liftEither good
    throwError "fuck"
  where
    good = Right 1

fail2 :: ExceptT String IO Int
fail2 = do
    x <- ExceptT failE
    throwError "fuck"
    return $ x + 1

failE :: IO (Either String Int)
failE = return $ Left "failE"
