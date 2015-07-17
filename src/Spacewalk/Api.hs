{-# LANGUAGE FlexibleContexts #-}

module Spacewalk.Api where

-- import Control.Monad
import Control.Monad.Reader
import Control.Monad.State

import Spacewalk.ApiTypes
import Spacewalk.ApiInternal

runSwAPI :: String -> String -> String -> SpacewalkRPC a -> IO a
runSwAPI s u p a = fmap fst $ runStateT (runReaderT a' re) st where
    a' = do
        _ <- api_auth_login
        x <- a
        api_auth_logout
        return x
    st = SwS { key = Nothing }
    re = SwR { apiurl = s, username = u, password = p }
