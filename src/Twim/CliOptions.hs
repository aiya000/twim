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

twim :: Parser CliOptions
twim = subparser $
  initConfig <>
  unfollow <>
  follow
  where
    initConfig = undefined
    unfollow = undefined
    follow = undefined
