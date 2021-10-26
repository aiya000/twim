module Twim.Utils where

import Data.ByteString.Lazy
import Shh
import Twim.CLI

ignoreRubyWarning :: Proc ()
ignoreRubyWarning = grep ("-v" :: ByteString) (": warning:" :: ByteString)
