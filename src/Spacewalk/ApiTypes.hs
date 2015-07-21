{-# LANGUAGE FlexibleContexts #-}
module Spacewalk.ApiTypes where

import Control.Monad
import Control.Monad.Reader
import Control.Monad.State
import Network.XmlRpc.Internals

newtype Key = Key String

instance XmlRpcType Key where
    toValue (Key s) = toValue s
    fromValue v = liftM Key $ fromValue v
    getType _ = TString

data ReaderValue = SwR
    { apiurl :: String
    , username :: String
    , password :: String
    }

data StateValue = SwS
    { key :: Maybe Key
    }

type SpacewalkRPC = ReaderT ReaderValue (StateT StateValue IO)
