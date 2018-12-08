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

test :: IO ()
test = do
    runExceptT handleBad >>= print
    --runExceptT handleOverflow >>= print
    runExceptT handleOverflow' >>= print
    --runExceptT handleDeleteFileIO >>= print
    runExceptT handleDeleteFileIO' >>= print
