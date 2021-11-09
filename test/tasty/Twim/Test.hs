-- | Test utilities.
module Twim.Test where

import Control.Monad.Reader
import Control.Monad.Writer
import Twim.Cache
import Twim.Config
import Twim.Twitter

type Log = String

data TwitterAccount = TwitterAccount
  { follower :: [TwitterUserId] -- ^ Users that is following me
  , following :: [TwitterUserId] -- ^ Users that I'm following
  } deriving (Show, Eq)

-- | For tests.
newtype ViaMock a = ViaMock
  { unViaMock :: ReaderT TwimEnv (Writer Log) a
  }
  deriving (Functor, Applicative, Monad)
  deriving newtype (MonadReader TwimEnv, MonadWriter Log)

instance TwitterApi ViaMock where
  followUser = undefined
  unfollowUser = undefined
  isFollowingMe = undefined
  fetchFollowersOf = undefined
  fetchFollowingsOf = undefined
  putLog = tell
  printLog = putLog . show

runViaMock :: TwimEnv -> ViaMock a -> (a, Log)
runViaMock env = runWriter . flip runReaderT env . unViaMock
