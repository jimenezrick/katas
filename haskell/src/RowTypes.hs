{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE TypeFamilies #-}

module RowTypes where

import Data.Generics.Labels ()
import Data.Generics.Product.Fields (HasField)
import Data.Row
import Data.Row.Records
import Lens.Micro.Platform

--
-- https://github.com/target/row-types/blob/master/examples/Examples.lhs
--
originXY :: Rec ("x" .== Double .+ "y" .== Double)
originXY = #x .== 0 .+ #y .== 0

withZ :: a -> Rec r -> Rec ("z" .== a .+ r)
withZ z r = #z .== z .+ r

originXYZ :: Rec ("x" .== Double .+ "y" .== Double .+ "z" .== Double)
originXYZ = 123 `withZ` originXY

takeZ :: (Floating t, (r .! "z") ~ t) => Rec r -> t
takeZ r = r .! #z

moveX :: Num (r .! "x") => Rec r -> r .! "x" -> Rec r
moveX r dx = update #x (r .! #x + dx) r

moveLensX :: (HasField "x" s t a a, Num a) => s -> a -> t
moveLensX r dx = r & #x %~ (+ dx)

originXYmoved10 :: Rec ("x" .== Double .+ "y" .== Double)
originXYmoved10 = originXY `moveX` 10

originXYZmoved10 :: Rec ("x" .== Double .+ "y" .== Double .+ "z" .== Double)
originXYZmoved10 = originXYZ `moveLensX` 10

fromOriginXYZ :: Rec ("x" .== Double .+ "y" .== Double)
fromOriginXYZ = restrict @("x" .== Double .+ "y" .== Double) originXYZ

oneOf :: Var ("foo" .== String .+ "bar" .== Int)
oneOf = IsJust #foo "caca"

butAlso :: Var ("foo" .== String .+ "bar" .== Int .+ "zzz" .== Double)
butAlso = diversify @("zzz" .== Double) oneOf
