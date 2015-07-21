{-# LANGUAGE FlexibleContexts #-}
module Spacewalk.ApiInternal where

-- import Control.Monad
import Control.Monad.Reader
import Control.Monad.State
import Network.XmlRpc.Client

import Spacewalk.ApiTypes

voidInt :: Functor f => f Int -> f ()
voidInt = void

-- | Use this for unauthenticated API calls.
swRemoteBase :: Remote a => String -> (a -> IO b) -> SpacewalkRPC b
swRemoteBase s m = do
    u <- asks apiurl
    liftIO $ m (remote u s)

-- | Use this for authenticated API calls.
swRemote :: Remote (Key -> a) => String -> (a -> IO b) -> SpacewalkRPC b
swRemote s m = do
    mk <- gets key
    case mk of
        Nothing -> error "Unauthenticated"
        Just k -> swRemoteBase s (\ x -> m (x k))
