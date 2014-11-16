{-# LANGUAGE OverloadedStrings, QuasiQuotes #-}
module Test (main) where

import           Network.Wai (Application)
import           Test.Hspec
import           Test.Hspec.Wai
import qualified Web.Scotty as S
import           Webbing (AppConfig, app)

main :: IO ()
main = hspec spec

appConfig :: AppConfig
appConfig = AppConfig {}

spec :: Spec
spec = with (app appConfig) $ do
  describe "GET /beam" $ do
    it "responds with 200" $ do
      get "/beam" `shouldRespondWith` 200
