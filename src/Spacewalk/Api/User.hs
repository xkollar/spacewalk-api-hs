{-# LANGUAGE FlexibleContexts #-}
module Spacewalk.Api.User
    ( addAssignedSystemGroups
    , addDefaultSystemGroups
    , addRole
    , create
    , delete
    , disable
    , enable
    , getDetails
    , getLoggedInTime
    , listAssignableRoles
    , listRoles
    , listUsers
    , removeAssignedSystemGroups
    , removeRole
    , setCreateDefaultSystemGroup
    , setReadOnly
    , usePamAuthentication
    ) where

import Data.Time.LocalTime (LocalTime)
import Network.XmlRpc.Internals
import Network.XmlRpc.Client (Remote)

import Spacewalk.ApiTypes
import Spacewalk.ApiInternal


simpleUserMethod :: Remote (a -> IO b) => String -> a -> SpacewalkRPC b
simpleUserMethod m login = swRemote ("user." ++ m) (\ x -> x login)

------------------------------------

addAssignedSystemGroups :: String -> [String] -> Bool -> SpacewalkRPC ()
addAssignedSystemGroups login groups setdefault = voidInt $
    swRemote "user.addAssignedSystemGroups" (\ x -> x login groups setdefault)

addDefaultSystemGroups :: String -> [String] -> SpacewalkRPC ()
addDefaultSystemGroups login groups = voidInt $
    swRemote "user.addDefaultSystemGroups" (\ x -> x login groups)

addRole :: String -> String -> SpacewalkRPC ()
addRole login role = voidInt $
    swRemote "user.addRole" (\ x -> x login role)

create :: String -> String -> String -> String -> String -> SpacewalkRPC ()
create login pw namef namel email = voidInt $
    swRemote "user.create" (\ x -> x login pw namef namel email)

delete :: String -> SpacewalkRPC ()
delete = voidInt . simpleUserMethod "delete"

disable :: String -> SpacewalkRPC ()
disable = voidInt . simpleUserMethod "disable"

enable :: String -> SpacewalkRPC ()
enable = voidInt . simpleUserMethod "enable"

getDetails :: String -> SpacewalkRPC Value
getDetails = simpleUserMethod "getDetails"

getLoggedInTime :: String -> SpacewalkRPC LocalTime
getLoggedInTime = simpleUserMethod "getLoggedInTime"

listAssignableRoles :: SpacewalkRPC [String]
listAssignableRoles = swRemote "user.listAssignableRoles" id

listRoles :: String -> SpacewalkRPC [String]
listRoles = simpleUserMethod "listRoles"

-- | List logins and information whether the account is enabled or not
-- Rest of the return value of the API is useless :-/.
listUsers :: SpacewalkRPC [(String,Bool)]
listUsers = swRemote "user.listUsers" id >>= handleError fail . decode where
    decode v = fromValue v >>= mapM f where
        f v' = do
            l <- getField "login" v'
            e <- getField "enabled" v'
            return (l,e)

removeAssignedSystemGroups :: String -> [String] -> Bool -> SpacewalkRPC ()
removeAssignedSystemGroups login groups removefromdefaults = voidInt $
    swRemote "user.removeAssignedSystemGroups" (\ x -> x login groups removefromdefaults)

removeRole :: String -> String -> SpacewalkRPC ()
removeRole login role = voidInt $
    swRemote "user.removeRole" (\ x -> x login role)

setCreateDefaultSystemGroup :: Bool -> SpacewalkRPC ()
setCreateDefaultSystemGroup createdefault = voidInt $
    swRemote "user.setCreateDefaultSystemGroup" (\ x -> x createdefault)

setReadOnly :: String -> Bool -> SpacewalkRPC ()
setReadOnly login readonly = voidInt $
    swRemote "user.setReadOnly" (\ x -> x login readonly)

usePamAuthentication :: String -> Bool -> SpacewalkRPC ()
usePamAuthentication login usepam = voidInt $
    swRemote "user.usePamAuthentication" (\ x -> x login $ boolToInt usepam)
    where
        boolToInt :: Bool -> Int
        boolToInt b = if b then 1 else 0
