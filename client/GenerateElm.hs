{-# LANGUAGE OverloadedStrings #-}

import Servant.Elm
import Elm

import Api

spec :: Spec
spec = Spec ["Api"] $
  defElmImports :
  toElmTypeSource user :
  toElmDecoderSource user :
  generateElmForAPI api

main :: IO ()
main = specsToDir [spec] "client"
