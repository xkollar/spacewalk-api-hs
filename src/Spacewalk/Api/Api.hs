module Spacewalk.Api.Api
    ( getVersion
    , systemVersion
    ) where

import Spacewalk.ApiTypes
import Spacewalk.ApiInternal

getVersion :: SpacewalkRPC String
getVersion = swRemoteBase "api.getVersion" id

systemVersion :: SpacewalkRPC String
systemVersion = swRemoteBase "api.systemVersion" id
