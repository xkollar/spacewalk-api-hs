module Spacewalk.Api.Preferences.Locale where

import Spacewalk.ApiTypes
import Spacewalk.ApiInternal

import Network.XmlRpc.Internals

listLocales :: SpacewalkRPC String
listLocales = swRemoteBase "preferences.locale.listTimeZones" id

listTimeZones :: SpacewalkRPC Value
listTimeZones = swRemoteBase "preferences.locale.listTimeZones" id

setLocale :: String -> String -> SpacewalkRPC ()
setLocale login locale = voidInt $
    swRemote "preferences.locale.setLocale" (\ x -> x login locale )

setTimeZone :: String -> Int -> SpacewalkRPC ()
setTimeZone login tzid = voidInt $
    swRemote "preferences.locale.setTimeZone" (\ x -> x login tzid )
