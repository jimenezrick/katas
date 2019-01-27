{-# LANGUAGE FlexibleContexts #-}

module Error where

import Control.Monad.Except
import Control.Monad.IO.Class

test :: IO (Either String Int)
test = runExceptT fail1

fail1 :: (MonadError String m, MonadIO m) => m Int
fail1 = do
    liftEither good
    throwError "fuck"
  where
    good = Right 1
