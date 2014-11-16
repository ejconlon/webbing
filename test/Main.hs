{-# LANGUAGE OverloadedStrings, QuasiQuotes #-}

module Main (main) where

import           Network.Wai (Application)
import           Test.Hspec
import           Test.Hspec.Wai
import qualified Web.Scotty as S
import           Webbing (app, AppConfig(..), Backend(..), initialize)

appConfig :: AppConfig
appConfig = AppConfig { backend = SqliteBackend "test" }

spec :: Spec
spec = with (S.scottyApp $ app appConfig) $ do
  describe "GET /beam" $ do
    it "responds with 200" $ do
      get "/beam" `shouldRespondWith` 200

main :: IO ()
main = do
  initialize appConfig
  hspec spec
