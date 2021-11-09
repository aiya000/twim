module Twim.Follow where

import Twim.CliOptions
import Twim.TwitterApi

-- | Please see this description of Twim.CliOptions.
follow :: TwitterApi t => CopyingTarget -> t ()
follow target = printLog target
