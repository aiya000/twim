{-# LANGUAGE NoOverloadedStrings #-}

module Twim.Main where

import Safe (headMay)
import Shh
import System.Environment (getArgs)
import Twim.Config (my_user_name)
import Twim.Follow (followFromUser, OperationKind (..))
import Twim.Unfollow (unfollowNotFollowingUsers)
import Twim.Utils (ignoreRubyWarning)

defaultMain :: IO ()
defaultMain = headMay <$> getArgs >>= \case
  Nothing -> putStrLn "Avaliable sub commands: switch-account, unfollow, copy-follower, copy-following"
  Just subcmd ->
    case subcmd of
      "switch-account" -> switchAccount
      "unfollow" -> unfollowNotFollowingUsers
      "copy-follower" -> followFromUser OperationKindFollower
      "copy-following" -> followFromUser OperationKindFollower
      unknown -> putStrLn $ "Unknown sub command: " <> unknown


switchAccount :: IO ()
switchAccount = exe "t" "set" "active" my_user_name |> ignoreRubyWarning
