module Lens where

import Data.Text
import Lens.Micro.Platform

import qualified Data.HashMap.Lazy as HM
import qualified Data.Text as T

newtype UserName =
    UserName Text
    deriving (Show, Eq)

newtype PetName =
    PetName Text
    deriving (Show, Eq)

type Inventory = HM.HashMap Text Item

data User = User
    { _userName :: UserName
    , _userScore :: Int
    , _userPet :: Maybe Pet
    , _userInventory :: Inventory
    } deriving (Show, Eq)

data Pet = Pet
    { _petName :: PetName
    } deriving (Show, Eq)

data Item = Item
    { _itemValue :: Int
    , _itemWeight :: Int
    } deriving (Show, Eq)
