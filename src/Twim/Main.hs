{-# LANGUAGE NoOverloadedStrings #-}

module Twim.Main where

import Safe (headMay)
import Shh (exe)
import System.Environment (getArgs)
import Twim.Config
import Twim.Follow (followFromUser, OperationKind (..))
import Twim.Unfollow (unfollowNotFollowingUsers)

defaultMain :: IO ()
defaultMain = do
  config <- readConfigOrInit
  headMay <$> getArgs >>= \case
    Nothing -> putStrLn "Avaliable sub commands: switch-account, unfollow, copy-follower, copy-following"
    Just subcmd ->
      case subcmd of
        "init" -> pure ()
        "switch-account" -> switchAccount config
        "unfollow" ->  unfollowNotFollowingUsers config
        "copy-follower" -> followFromUser OperationKindFollower config
        "copy-following" -> followFromUser OperationKindFollower config
        unknown -> putStrLn $ "Unknown sub command: " <> unknown
  where
    readConfigOrInit :: IO Config
    readConfigOrInit =
      readConfig >>= \case
        Just config -> pure config
        Nothing -> do
          _ <- initConfigDir
          readConfig >>= \case
            Just config -> pure config
            Nothing -> fail "Fatal error: cannot read and initialize config."


switchAccount :: Config -> IO ()
switchAccount (Config { twitterUserId }) = do
  exe "t" "set" "active" twitterUserId
