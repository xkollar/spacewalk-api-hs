module Main ( main ) where

import Control.Monad.IO.Class
import Control.Monad.Catch

import Spacewalk.Api
import System.Environment (getArgs)

import qualified Spacewalk.Api.User as User

main :: IO ()
main = do
    [server, user, pass] <- getArgs
    runSwAPI server user pass $ do
        bracket_
            (User.create  "test" "tset5" "A" "B" "a@b.c")
            (User.delete "test")
            $ do
                User.getDetails "admin" >>= liftIO . print
                User.getLoggedInTime "admin" >>= liftIO . print
                User.disable "test"
                User.enable "test"
        return ()
    putStrLn "Done."
