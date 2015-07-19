module Spacewalk.Api.User where

import Spacewalk.ApiTypes
import Spacewalk.ApiInternal

import Network.XmlRpc.Internals

-- | Thrown away return value, as it is only 1 or exception anyway...
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

-- data UserDetails = UserDetails
--     { userDetails_firstName :: String
--     , userDetails_lastName :: String
--     , userDetails_email :: String
--     , userDetails_orgId :: Int
--     , userDetails_prefix :: String
--     , userDetails_lastLoginDate :: String
--     , userDetails_created_date :: String
--     , userDetails_enabled :: Bool
--     , userDetails_use_pam :: Bool
--     } deriving Show
--
-- instance XmlRpcType UserDetails where
--     toValue = undefined
--     fromValue = undefined
--     getType = undefined

getDetails :: String -> SpacewalkRPC Value
getDetails login = swRemote "user.getDetails" (\ x -> x login)

getLoggedInTime :: String -> SpacewalkRPC Value
getLoggedInTime login = swRemote "user.getLoggedInTime" (\ x -> x login)
