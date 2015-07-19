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
        catchAll (User.create  "test" "tset5" "A" "B" "a@b.c") $ \ _ -> do
            liftIO . putStrLn $ "Ayayay: caught exception"
            User.delete "test"
            User.create "test" "tset5" "A" "B" "a@b.c"
        User.getDetails "test" >>= liftIO . print
        User.getLoggedInTime "test" >>= liftIO . print
        User.disable "test"
        User.enable "test"
        User.delete "test"
        return ()
    putStrLn "Done."
