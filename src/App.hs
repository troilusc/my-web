{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module App
    ( startApp
    ) where

import Control.Concurrent (forkIO)
import Network.Wai
import Network.Wai.MakeAssets
import Network.Wai.Handler.Warp
import Network.Wai.Handler.WarpTLS
import Network.Wai.Middleware.ForceSSL (forceSSL)
import Servant

import Api

type WithAssets = Api :<|> Raw

withAssets :: Proxy WithAssets
withAssets = Proxy

listenTLS :: Int -> IO Application -> IO ()
listenTLS port app = runTLS tls settings =<< app
  where
    tls = tlsSettings "fullchain.pem" "privkey.pem"
    settings = setPort port defaultSettings

listen :: Int -> IO Application -> IO ()
listen port app = run port =<< app

startApp :: IO ()
startApp = do
  _ <- forkIO $ listenTLS 443 webApp
  listen 80 (forceSSL <$> webApp)

webApp :: IO Application
webApp = serve withAssets <$> server

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
