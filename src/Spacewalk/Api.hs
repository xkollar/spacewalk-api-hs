{-# LANGUAGE FlexibleContexts #-}
-- |
-- This module contains only function to run 'SpacewalkRPC' code.
-- Bindings can be found in @Spacewalk.Api.*@ modules.
-- As of now they are incomplete, however contributors are welcome.
--
-- If there is unimplemented method, you can use @Spacewalk.ApiInternal@.
--
-- Spacewalk API methods that return @1@ or throw exception
-- in this api return @()@ or throw exception.
module Spacewalk.Api () where


import Control.Monad.Reader
import Control.Monad.State

import Spacewalk.ApiTypes
import qualified Spacewalk.Api.Auth as Auth

-- | Run 'SpacewalkRPC' code.
--
-- > main :: IO ()
-- > main = do
-- >     [server, user, pass] <- getArgs
-- >     runSwAPI server user pass $ do
-- >         User.listUsers >>= mapM_ (liftIO . print)
runSwAPI
    :: String
    -- ^ XML-RPC entrypoint URL (usually @http:\/\/\<FQDN\>\/rpc\/api@).
    -> String
    -- ^ Login.
    -> String
    -- ^ Password.
    -> SpacewalkRPC a
    -> IO a
runSwAPI s u p a = fmap fst $ runStateT (runReaderT a' re) st where
    a' = do
        Auth.login
        x <- a
        Auth.logout
        return x
    st = SwS { key = Nothing }
    re = SwR { apiurl = s, username = u, password = p }
