module Script where

import Control.Error.Script
import System.Process.Typed as P

failDeleteFile :: Script ()
failDeleteFile = scriptIO $ P.runProcess_ "rm xxxxxxxxxxx"

failFalse :: Script ()
failFalse = scriptIO $ P.runProcess_ "false "

--
-- Simple scripts: IO exceptions (Control.Exception) are captured and printed as errors
--
test1 :: IO ()
test1 = runScript failFalse

test2 :: IO ()
test2 = runScript failDeleteFile
