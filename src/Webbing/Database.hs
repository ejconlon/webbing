{-# LANGUAGE OverloadedStrings  #-}

module Webbing.Database (Database, postgresql, sqlite) where

import Control.Monad.Logger (NoLoggingT, runNoLoggingT)
import Control.Monad.Trans.Resource (runResourceT, ResourceT)
import Data.ByteString (ByteString)
import Data.Monoid ((<>))
import Data.Text (pack)
import Data.Text.Encoding (encodeUtf8)
import Database.Persist.Sql (runSqlConn, SqlPersistT)
import Database.Persist.Postgresql (withPostgresqlConn)
import Database.Persist.Sqlite (withSqliteConn)
import Webbing.WebHerokuCopy (dbConnParams)

type Database a = SqlPersistT (ResourceT (NoLoggingT IO)) a -> IO a

sqlite :: String -> Database a
sqlite name = runNoLoggingT . runResourceT . withSqliteConn (pack name) . runSqlConn

connStr :: IO ByteString
connStr = do
    params <- dbConnParams
    return $ foldr (\(k,v) t -> t <> (encodeUtf8 $ k <> "=" <> v <> " ")) "" params

postgresql' :: ByteString -> Database a
postgresql' cs = runNoLoggingT . runResourceT . withPostgresqlConn cs . runSqlConn

postgresql :: IO (Database a)
postgresql = fmap postgresql' connStr
