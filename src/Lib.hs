{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( startApp
    ) where

--import Data.Aeson
--import Data.Aeson.TH
--import Data.List
--import GHC.Generics
--import Network.Wai
--import Network.Wai.Handler.Warp
--import Servant

import Data.Aeson
import GHC.Generics
import Network.Wai
import Network.Wai.Handler.Warp
import Servant

type UserAPI = "users" :> Get '[JSON] [User]

data User = User {
  name :: String,
  age :: Int
} deriving (Eq, Show, Generic)

instance ToJSON User

startApp :: IO ()
startApp = run 8080 app

app :: Application
app = serve api server

api :: Proxy UserAPI
api = Proxy

server :: Server UserAPI
server = return users

users :: [User]
users =
  [ User "Isaac Newton"    372
  , User "Albert Einstein" 136
  ]
