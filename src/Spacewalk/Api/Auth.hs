{-# LANGUAGE FlexibleContexts #-}

module Spacewalk.Api.Auth where

-- | This module is not supposed to be used directly.
-- Use @Spacewalk.Api.runSwAPI@ to get and use token.

import Control.Monad.Reader
import Control.Monad.State

import Spacewalk.ApiTypes
import Spacewalk.ApiInternal

loginRaw :: SpacewalkRPC Key
loginRaw = do
    mk <- gets key
    case mk of
        Just _ -> error "Already logged in"
        Nothing -> do
            user <- asks username
            pass <- asks password
            swRemoteBase "auth.login" (\ x -> x user pass)

login :: SpacewalkRPC ()
login = loginRaw >>= put . SwS . Just

logoutRaw :: SpacewalkRPC Int
logoutRaw = swRemote "auth.logout" id :: SpacewalkRPC Int

logout :: SpacewalkRPC ()
logout = logoutRaw >> put (SwS Nothing)
