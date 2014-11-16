{-# LANGUAGE OverloadedStrings #-}

module Webbing (app, AppConfig(..), Backend(..)) where

import           Data.Monoid (mconcat)
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import           Text.Blaze.Html.Renderer.Text (renderHtml)
import qualified Web.Scotty as S
import           Webbing.Database as DB
import           Webbing.Model
import           Webbing.View

data Backend = SqliteBackend String | PostgresqlBackend

data AppConfig = AppConfig { backend :: Backend }

connect :: Backend -> IO (DB.Database a)
connect (SqliteBackend name) = return $ DB.sqlite name
connect (PostgresqlBackend) = DB.postgresql

blaze :: H.Html -> S.ActionM ()
blaze = S.html . renderHtml

app :: AppConfig -> S.ScottyM ()
app appConfig = do
  S.get "/:word" $ do
    beam <- S.param "word" :: S.ActionM String
    blaze $ do
      H.h1 $ H.toHtml $ "Scotty, " ++ beam ++ " me up!"
      H.p "yup"
