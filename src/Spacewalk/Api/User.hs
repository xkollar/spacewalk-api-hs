module Spacewalk.Api.User where

import Spacewalk.ApiTypes
import Spacewalk.ApiInternal

import Network.XmlRpc.Internals

create :: String -> String -> String -> String -> String -> SpacewalkRPC ()
create login pw namef namel email = voidInt $
    swRemote "user.create" (\ x -> x login pw namef namel email)

delete :: String -> SpacewalkRPC ()
delete login = voidInt $
    swRemote "user.delete" (\ x -> x login)

disable :: String -> SpacewalkRPC ()
disable login = voidInt $
    swRemote "user.disable" (\ x -> x login)

enable :: String -> SpacewalkRPC ()
enable login = voidInt $
    swRemote "user.enable" (\ x -> x login)

getDetails :: String -> SpacewalkRPC Value
getDetails login = swRemote "user.getDetails" (\ x -> x login)

getLoggedInTime :: String -> SpacewalkRPC Value
getLoggedInTime login = swRemote "user.getLoggedInTime" (\ x -> x login)

-- | List logins and information whether the account is enabled or not
-- Rest of the return value of the API is useless :-/.
listUsers :: SpacewalkRPC [(String,Bool)]
listUsers = swRemote "user.listUsers" id >>= handleError fail . decode where
    decode v = fromValue v >>= mapM f where
        f v' = do
            l <- getField "login" v'
            e <- getField "enabled" v'
            return (l,e)
