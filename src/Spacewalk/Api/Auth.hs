{-# LANGUAGE FlexibleContexts #-}

module Spacewalk.Api.Auth where

-- | This module is not supposed to be used directly.
-- Use @Spacewalk.Api.runSwAPI@ to get and use token.

import Control.Monad.Reader
import Control.Monad.State

import Spacewalk.ApiTypes
import Spacewalk.ApiInternal

login :: SpacewalkRPC ()
login = do
    mk <- gets key
    case mk of
        Just _ -> error "Already logged in"
        Nothing -> do
            user <- asks username
            pass <- asks password
            swRemoteBase "auth.login" (\ x -> x user pass)
            -- k <- swRemoteBase "auth.login" (\ x -> x user pass)
            -- put (SwS $ Just k)

logout :: SpacewalkRPC ()
logout = do
    _ <- swRemote "auth.logout" id :: SpacewalkRPC Int
    put (SwS Nothing)
