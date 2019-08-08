{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE AllowAmbiguousTypes #-}

module TypeApplications where

fmapMaybe :: (a -> Int) -> Maybe a -> Maybe Int
fmapMaybe = fmap @Maybe @_ @Int

showAmbiguous :: Show a => Int
showAmbiguous = 666

get666 :: Bool
get666 = showAmbiguous @Char == 666
