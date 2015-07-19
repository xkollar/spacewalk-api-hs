{-# LANGUAGE FlexibleContexts #-}

module Spacewalk.ApiInternal where

-- import Control.Monad
import Control.Monad.Reader
import Control.Monad.State
import Network.XmlRpc.Client

import Spacewalk.ApiTypes

voidInt :: Functor f => f Int -> f ()
voidInt = void

swRemoteBase :: Remote a => String -> (a -> IO b) -> SpacewalkRPC b
swRemoteBase s m = do
    u <- asks apiurl
    liftIO $ m (remote u s)

swRemote :: Remote (Key -> a) => String -> (a -> IO b) -> SpacewalkRPC b
swRemote s m = do
    mk <- gets key
    case mk of
        Nothing -> error "Unauthenticated"
        Just k -> swRemoteBase s (\ x -> m (x k))

api_auth_login :: SpacewalkRPC ()
api_auth_login = do
    mk <- gets key
    case mk of
        Just _ -> error "Already logged in"
        Nothing -> do
            user <- asks username
            pass <- asks password
            k <- swRemoteBase "auth.login" (\ x -> x user pass)
            put (SwS $ Just k)

api_auth_logout :: SpacewalkRPC ()
api_auth_logout = do
    _ <- swRemote "auth.logout" id :: SpacewalkRPC Int
    put (SwS Nothing)
