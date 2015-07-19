Haskell Spacewalk API
=====================

Simple Haskell bindings for Spacewalk XML-RPC API.

It is incomplete. Pull requests are welcome.

It handles session key for you.

Example
-------


~~~~ { .haskell }
module Main ( main ) where

import System.Environment (getArgs)

import Spacewalk.Api
import qualified Spacewalk.Api.User as User

main :: IO ()
main = do
    [server, user, pass] <- getArgs
    runSwAPI server user pass User.listUsers >>= mapM_ print
~~~~
