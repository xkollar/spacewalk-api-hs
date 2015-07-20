{-# LANGUAGE FlexibleContexts #-}
-- |
-- Stability   :  experimental
-- Portability :  non-portable (requires extensions and non-portable libraries)

module Spacewalk.Api where

-- import Control.Monad
import Control.Monad.Reader
import Control.Monad.State

import Spacewalk.ApiTypes
-- import Spacewalk.ApiInternal
import qualified Spacewalk.Api.Auth as Auth

runSwAPI :: String -> String -> String -> SpacewalkRPC a -> IO a
runSwAPI s u p a = fmap fst $ runStateT (runReaderT a' re) st where
    a' = do
        Auth.login
        x <- a
        Auth.logout
        return x
    st = SwS { key = Nothing }
    re = SwR { apiurl = s, username = u, password = p }
