{-# LANGUAGE OverloadedStrings #-}

module Webbing (AppConfig, app) where

import           Data.Monoid (mconcat)
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import           Text.Blaze.Html.Renderer.Text (renderHtml)
import qualified Web.Scotty as S

data AppConfig = AppConfig { }

blaze :: H.Html -> S.ActionM ()
blaze = S.html . renderHtml

app :: AppConfig -> ScottyM ()
app = do
  S.middleware logStdoutDev

  S.get "/:word" $ do
    beam <- S.param "word" :: S.ActionM String
    blaze $ do
      H.h1 $ H.toHtml $ "Scotty, " ++ beam ++ " me up!"
      H.p "yup"

