{-# LANGUAGE FlexibleContexts #-}

-- |
-- Stability   :  experimental
--
-- This module is not supposed to be used directly.
-- Use 'Spacewalk.Api.runSwAPI' to get and use token.

module Spacewalk.Api.Auth where

import Control.Monad.Reader
import Control.Monad.State

import Spacewalk.ApiTypes
import Spacewalk.ApiInternal

login' :: SpacewalkRPC Key
login' = do
    mk <- gets key
    case mk of
        Just _ -> error "Already logged in"
        Nothing -> do
            user <- asks username
            pass <- asks password
            swRemoteBase "auth.login" (\ x -> x user pass)

login :: SpacewalkRPC ()
login = login' >>= put . SwS . Just

logout' :: SpacewalkRPC Int
logout' = swRemote "auth.logout" id :: SpacewalkRPC Int

logout :: SpacewalkRPC ()
logout = logout' >> put (SwS Nothing)
