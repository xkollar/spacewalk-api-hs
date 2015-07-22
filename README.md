Haskell Spacewalk API
=====================

Simple Haskell bindings for Spacewalk XML-RPC API.

It is incomplete and new methods will be added on
demand (pull requests are welcome). This is intentional
as I operate under assumption that many methods are
not used anymore and idea is to add methods that
are used by/useful to someone.

Original API documentation available at <http://www.spacewalkproject.org/documentation/api/2.3/index.html>.

It handles session key for you.

Use
---

Code is not posted on the Hackage so if you want to give it a try:

~~~ { .bash }
TMP=$( mktemp -d )
git clone git://github.com/xkollar/spacewalk-api-hs.git "${TMP}"
cabal-dev init
${EDITOR:-vim} *.cabal # add dependency on spacewalk-api and setup stuff...
cabal-dev install "${TMP}/spacewalk-api.cabal"
cabal-dev install --only # in case you added more dependencies
# write your code (remember Main-is from editing .cabal file)
cabal-dev configure
cabal-dev build
~~~

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
