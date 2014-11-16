{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE QuasiQuotes                #-}

module Webbing.Model where

import Data.ByteString (ByteString)
import Data.Text (Text)
import Data.Time (UTCTime)
import Database.Persist
import Database.Persist.TH

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Site
    name String
    email String
    pwSalt String
    pwHash String
    createdAt UTCTime default=CURRENT_TIME
    deriving Show
File
    path String
    size Int
    contents ByteString
    createdAt UTCTime default=CURRENT_TIME
    siteId SiteId
    deriving Show
|]
