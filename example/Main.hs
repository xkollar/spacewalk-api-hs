module Main ( main ) where

import Control.Monad
import Control.Monad.Catch
import Control.Monad.IO.Class

import System.Environment (getArgs)

import Spacewalk.Api
import Spacewalk.ApiTypes (SpacewalkRPC)

import qualified Spacewalk.Api.User as User

listNeverLoggedIn :: SpacewalkRPC ()
listNeverLoggedIn = do
        liftIO $ putStrLn "Users that have never logged in:"
        users <- (map fst . filter snd) `fmap` User.listUsers
        flip mapM_ users $ \ login -> do
            b <- catchAll (User.getLoggedInTime login >> return False) (return . const True)
            when b $ (liftIO . putStrLn) login

createUserExample :: SpacewalkRPC ()
createUserExample =
    bracket_
        (User.create u "password" "A" "B" "a@b.c")
        (User.delete u)
        $ do
            -- User.getDetails u >>= liftIO . print
            -- User.getLoggedInTime u >>= liftIO . print
            User.disable u
            User.enable u
    where u = "test"

main :: IO ()
main = do
    [server, user, pass] <- getArgs
    runSwAPI server user pass $ do
        createUserExample
        listNeverLoggedIn
        return ()
    putStrLn "Done."
