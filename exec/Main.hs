module Main (main) where

import           Data.Maybe (fromMaybe)
import           System.Environment (lookupEnv)
import           Network.Wai.Middleware.RequestLogger (logStdoutDev)
import           Webbing (app, AppConfig(..))
import qualified Web.Scotty as S

data ContainerConfig = ContainerConfig { port :: Int }

data Config = Config { appConfig :: AppConfig, containerConfig :: ContainerConfig }

readConfig :: IO Config
readConfig = do
  maybePortString <- lookupEnv "PORT"
  let port = fromMaybe 3000 $ fmap read maybePortString
  return Config { appConfig = AppConfig {}, containerConfig = ContainerConfig { port = port } }

main :: IO ()
main = do
  config <- readConfig
  S.scotty (port $ containerConfig config) $ do
    S.middleware logStdoutDev
    app $ appConfig config

