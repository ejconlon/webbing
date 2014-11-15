{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Monoid (mconcat)
import Network.Wai.Middleware.RequestLogger
import qualified Web.Scotty as S
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html.Renderer.Text (renderHtml)

blaze :: H.Html -> S.ActionM ()
blaze = S.html . renderHtml

main :: IO ()
main = S.scotty 3000 $ do
  S.middleware logStdoutDev

  S.get "/:word" $ do
    beam <- S.param "word" :: S.ActionM String
    blaze $ do
      H.h1 $ H.toHtml $ "Scotty, " ++ beam ++ " me up!"
      H.p "yup"
