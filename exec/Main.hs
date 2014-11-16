module Main (main) where

import Data.Maybe (fromMaybe)
import System.Environment (lookupEnv)
import Network.Wai.Middleware.RequestLogger (logStdoutDev)
import Webbing (AppConfig, app)
import Web.Scotty (middleware, scotty)

data ContainerConfig = ContainerConfig { port :: Port }

data Config = Config { appConfig :: AppConfig, containterConfig :: ContainterConfig }

readConfig :: IO Config
readConfig = do
  maybePortString <- lookupEnv "PORT"
  let port = fromMaybe 3000 $ fmap read maybePortString
  return Config { appConfig = AppConfig {}, containerConfig = ContainerConfig { port = port } }

main :: IO ()
main = do
  config <- readConfig
  scotty (port $ containerConfig config) do
    middleware logStdoutDev
    app $ appConfig config

