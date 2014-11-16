{-
Temporarily lifted from https://github.com/gregwebs/haskell-heroku/blob/master
due to issues in their cabal file. TODO: send patch upstream and delete this.
LICENSE follows:

Copyright (c)2011, Greg Weber

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.

    * Neither the name of Greg Weber nor the names of other
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-}

module Webbing.WebHerokuCopy (dbConnParams) where

import Data.Text
import System.Environment
import Network.URI

dbConnParams :: IO [(Text, Text)]
dbConnParams = dbConnParams' "DATABASE_URL" parseDatabaseUrl

parseDatabaseUrl :: String -> [(Text, Text)]
parseDatabaseUrl = parseDatabaseUrl' "postgres:"

-- | read the DATABASE_URL environment variable
-- and return an alist of connection parameters with the following keys:
-- user, password, host, port, dbname
--
-- warning: just calls error if it can't parse correctly
dbConnParams' :: String -> (String -> [(Text, Text)]) -> IO [(Text, Text)]
dbConnParams' envVar parse = getEnv envVar >>= return . parse

parseDatabaseUrl' :: String -> String -> [(Text, Text)]
parseDatabaseUrl' scheme durl =
  let muri = parseAbsoluteURI durl
      (auth, path) = case muri of
                      Nothing ->  error "couldn't parse absolute uri"
                      Just uri -> if uriScheme uri /= scheme
                                    then schemeError uri
                                    else case uriAuthority uri of
                                           Nothing   -> invalid
                                           Just a -> (a, uriPath uri)
      (user,password) = userAndPassword auth
  in     [ (pack "user",     user)
           -- tail not safe, but should be there on Heroku
         , (pack "password", Data.Text.tail password)
         , (pack "host",     pack $ uriRegName auth)
         , (pack "port",     pack $ removeColon $ uriPort auth)
         -- tail not safe but path should always be there
         , (pack "dbname",   pack $ Prelude.tail $ path)
         ]
  where
    removeColon (':':port) = port
    removeColon port = port

    -- init is not safe, but should be there on Heroku
    userAndPassword :: URIAuth -> (Text, Text)
    userAndPassword = (breakOn $ pack ":") . pack . Prelude.init . uriUserInfo

    schemeError uri = error $ "was expecting a postgres scheme, not: " ++ (uriScheme uri) ++ "\n" ++ (show uri)
    -- should be an error 
    invalid = error "could not parse heroku DATABASE_URL"
