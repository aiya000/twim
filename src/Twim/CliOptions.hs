module Twim.CliOptions where

import Options.Applicative
import Twim.Twitter

data CliOptions
  = InitConfig
  | Unfollow
  | Follow CopyingTarget
  deriving (Show)

data CopyingTarget
  = FollowerOf TwitterUserId -- ^ To follow the specified user's follower
  | FollowingOf TwitterUserId -- ^ To follow users that the specified user follows
  deriving (Show)

parseCliOptions :: IO CliOptions
parseCliOptions = execParser twim

twim :: ParserInfo CliOptions
twim =
  flip info (progDesc "A management system to follow/unfollow users smartly.") .
    subparser $
      initConfig <>
      unfollow <>
      follow
  where
    initConfig =
      command "init-config" .
        info (pure InitConfig) $
        progDesc (
          "Initializing this app's config directory and the config file:\n" <>
          "   - ~/.config/twim\n" <>
          "   - ~/.config/twim/config"
        )

    unfollow =
      command "unfollow" .
        info (pure Unfollow) $
        progDesc (
          "Unfollowing users that is not following you:\n" <>
          "   - But never unfollowing users that is specified by you."
        )

    follow =
      command "follow" .
        info parserForFollow $
        progDesc (
          "Following users that is another user's follower or followee:\n" <>
          "   - But Twim avoids following the users twice or more\n" <>
          "   - Meaning Twim follows the users only once"
        )

parserForFollow :: Parser CliOptions
parserForFollow =
  Follow <$> undefined
