{-# LANGUAGE NoOverloadedStrings #-}

module Twim.Main where

import Safe (headMay)
import Shh (exe)
import System.Environment (getArgs)
import Twim.Config
import Twim.Unfollow (unfollowNotFollowingUsers)

defaultMain :: IO ()
defaultMain = do
  readConfig >>= \case
    Nothing -> fail noSuchConfigError
    Just conf -> exec conf
  where
    noSuchConfigError =
      "No such config file.\n" <>
      "Please run `$ twim init-config` before run this app."

    exec :: Config -> IO ()
    exec config = do
      switchAccount config
      headMay <$> getArgs >>= \case
        Nothing -> putStrLn "Avaliable sub commands: switch-account, unfollow, copy-follower, copy-following"
        Just subcmd ->
          case subcmd of
            "unfollow" ->  unfollowNotFollowingUsers config
            "follow" -> undefined
            unknown -> putStrLn $ "Unknown sub command: " <> unknown


switchAccount :: Config -> IO ()
switchAccount (Config { yourId }) =
  exe "t" "set" "active" yourId
