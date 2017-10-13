{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module App
    ( startApp
    ) where

import Network.Wai
import Network.Wai.MakeAssets
import Network.Wai.Handler.Warp
import Servant

import Api

type WithAssets = Api :<|> Raw

withAssets :: Proxy WithAssets
withAssets = Proxy

startApp :: IO ()
startApp = run 8080 =<< app

app :: IO Application
app = serve withAssets <$> server

server :: IO (Server WithAssets)
server = do
  assets <- serveAssets def
  return $ (apiServer :<|> Tagged assets)

apiServer :: Server Api
apiServer = return users

users :: [User]
users =
  [ User "Isaac Newton"    372
  , User "Albert Einstein" 136
  ]
