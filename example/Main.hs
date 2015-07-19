module Main ( main ) where

import Spacewalk.Api
import Spacewalk.ApiInternal
import Spacewalk.ApiTypes
import System.Environment (getArgs)

main :: IO ()
main = do
    [server, user, pass] <- getArgs
    x <- runSwAPI server user pass $ do
        return ()
        swRemote "user.create" (\ x -> x "test" "tset5" "A" "B" "a@b.c") :: SpacewalkRPC Int
    print x
    return ()
