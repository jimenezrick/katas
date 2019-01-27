module Error where

import Control.Monad.Except

test :: IO (Either String Int)
test = runExceptT fail1

fail1 :: ExceptT String IO Int
fail1 = do
    liftEither good
    throwError "fuck"
  where
    good = Right 1
