module Twim.CliOptions where

import Options.Applicative
import Options.Applicative.Help.Pretty (text, vsep)
import Twim.Twitter

data CliOptions
  = InitConfig
  | Follow CopyingTarget
  | Unfollow
  deriving (Show, Eq)

data CopyingTarget
  = FollowerOf TwitterUserId -- ^ To follow the specified user's follower
  | FollowingOf TwitterUserId -- ^ To follow users that the specified user follows
  deriving (Show, Eq)

parseCliOptions :: IO CliOptions
parseCliOptions = execParser twim

twim :: ParserInfo CliOptions
twim =
  flip info twimDesc .
    hsubparser $
      initConfig <>
      follow <>
      unfollow
  where
    -- NOTE: Why optparse-applicative doesn't show sub commands automatically for --help?
    twimDesc =
      progDescDoc . Just $ vsep
        [ text "A management system to follow/unfollow users smartly."
        , text "commands:"
        , text "  - init-config"
        , text "  - follow"
        , text "  - unfollow"
        ]

    initConfig =
      command "init-config" .
        info (pure InitConfig) .
          progDescDoc . Just $ vsep
            [ text "Initializing this app's config directory and the config file:"
            , text "  - ~/.config/twim"
            , text "  - ~/.config/twim/config"
            ]

    follow =
      command "follow" .
        info followParser .
        progDescDoc . Just $ vsep
          [ text "Following users that is another user's follower or followee:"
          , text "  - But Twim avoids following the users twice or more"
          , text "  - Meaning Twim follows the users only once"
          ]

    unfollow =
      command "unfollow" .
        info (pure Unfollow) $
        progDesc (
          "Unfollowing users that is not following you" <>
          "but never unfollowing users that is specified by you."
        )

followParser :: Parser CliOptions
followParser =
  Follow <$> (
    FollowerOf <$> strArgument (metavar "follower") <|>
    FollowingOf <$> strArgument (metavar "following")
  )
