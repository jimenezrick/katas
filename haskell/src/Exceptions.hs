{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Exceptions where

import Control.Exception.Safe
import Control.Monad.Except
import System.Process.Typed as P

import qualified Control.Exception as E

--
-- This puts the IO exception under a Left value in the ExceptT
--
underIO :: (Monad m, MonadCatch m, Exception e) => m a -> ExceptT e m a
underIO = ExceptT . try

-- Cannot be handled directly in ExceptT
failDeleteFileIO :: MonadIO m => m ()
failDeleteFileIO = liftIO $ P.runProcess_ "rm yyyyyyyyyyy"

-- Throw custom error directly into ExceptT
handleBad :: ExceptT String IO ()
handleBad = void . throwError $ "bad"

-- Won't work, IO exceptions cannot be handled in ExceptT
handleOverflow :: ExceptT SomeException IO ()
handleOverflow = void $ throw E.Overflow

handleOverflow' :: ExceptT SomeException IO ()
handleOverflow' = underIO $ throw E.Overflow

-- Won't work, IO exceptions cannot be handled in ExceptT
handleDeleteFileIO :: ExceptT SomeException IO ()
handleDeleteFileIO = catchError failDeleteFileIO (\e -> liftIO $ print ("Error catched: " <> show e))

handleDeleteFileIO' :: ExceptT SomeException IO ()
handleDeleteFileIO' = catchError (underIO failDeleteFileIO) (\e -> liftIO $ putStrLn ("Got exception: " <> show e))

test1 :: IO ()
test1 = do
    runExceptT handleBad >>= print
    --runExceptT handleOverflow >>= print
    runExceptT handleOverflow' >>= print
    --runExceptT handleDeleteFileIO >>= print
    runExceptT handleDeleteFileIO' >>= print

--
-- Let's define type as our custom exception
--
data Error =
    Error
    deriving (Show, Eq)

instance Exception Error

-- This function fails throwing our error generically over different error monads
alwaysFail :: MonadThrow m => Int -> m Int
alwaysFail = const $ throwM Error

-- We can handle it over Maybe
handleError :: (Int -> Maybe Int) -> Maybe Int
handleError f = f 123

-- We can handle it over Either
handleError' :: (Int -> Either SomeException Int) -> Either SomeException Int
handleError' f = f 123

-- We can handle the error from Maybe or Either
test2 :: Bool
test2 =
    let Nothing = handleError alwaysFail :: Maybe Int
        Left err = handleError' alwaysFail :: Either SomeException Int
        -- err contains our Error within the SomeException value and we can extract it:
        -- err ~ Left (SomeException Error)
     in case fromException err of
            Just Error -> True
            Nothing -> False

--
-- Catch selectively a specific exception
--
divByZero :: Int
divByZero = 3 `div` 0

test3 :: IO ()
test3 = catch (print divByZero) (\(_ :: E.ArithException) -> print (999 :: Int))
