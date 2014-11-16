{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes        #-}

module Webbing.Database where

import Control.Monad.Logger (NoLoggingT, runNoLoggingT)
import Control.Monad.Trans.Resource (runResourceT, ResourceT)
import Database.Persist
import Database.Persist.Sqlite

type Database = forall a. SqlPersistT (ResourceT (NoLoggingT IO)) a -> IO a

sqlite :: Database
sqlite = runNoLoggingT . runResourceT . withSqliteConn "dev.app.sqlite3" . runSqlConn
