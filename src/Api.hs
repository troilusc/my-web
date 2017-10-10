{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Api
    ( api
    , Api
    , User (..)
    ) where

import Data.Aeson
import Data.Proxy
import GHC.Generics
import Servant
import Servant.Elm

type UserAPI = "users" :> Get '[JSON] [User]
type Api = "api" :> UserAPI

data User = User {
  name :: String,
  age :: Int
} deriving (Eq, Show, Generic)

instance ToJSON User
instance ElmType User

api :: Proxy Api
api = Proxy
