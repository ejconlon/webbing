module Main (main) where

import           Data.Maybe (fromMaybe)
import           System.Environment (lookupEnv)
import           Network.Wai.Middleware.RequestLogger (logStdoutDev)
import           Webbing (app, AppConfig(..), Backend(..))
import qualified Web.Scotty as S

data ContainerConfig = ContainerConfig { port :: Int }

data Config = Config { appConfig :: AppConfig, containerConfig :: ContainerConfig }

readConfig :: IO Config
readConfig = do
  maybePortString <- lookupEnv "PORT"
  maybeSqliteName <- lookupEnv "SQLITE_NAME"
  let port = fromMaybe 3000 $ fmap read maybePortString
  let backend = fromMaybe PostgresqlBackend $ fmap SqliteBackend maybeSqliteName
  return Config { appConfig = AppConfig { backend = backend }, containerConfig = ContainerConfig { port = port } }

main :: IO ()
main = do
  config <- readConfig
  S.scotty (port $ containerConfig config) $ do
    S.middleware logStdoutDev
    app $ appConfig config

