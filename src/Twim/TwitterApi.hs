-- |
-- Running contexts.
-- Please also see 'Twim.Follow' and 'Twim.Unfollow'.
module Twim.TwitterApi where

import Control.Monad.Reader
import Control.Monad.Writer
import Twim.Cache
import Twim.Config
import Twim.Twitter

-- | To inject below instance types into contexts.
class MonadReader TwimEnv m => TwitterApi m where
  followUser :: TwitterUserId -> m () -- ^ Does follow the user
  unfollowUser :: TwitterUserId -> m () -- ^ Does unfollow the user
  isFollowingMe :: TwitterUserId -> m Bool -- ^ Is the user following me?
  fetchFollowersOf :: TwitterUserId -> m [TwitterUserId]
  fetchFollowingsOf :: TwitterUserId -> m [TwitterUserId]
  -- vvv helpers
  putLog :: String -> m ()
  printLog :: Show a => a -> m ()
  -- vvv defaults
  isTruestedUser :: TwitterUserId -> m Bool
  isTruestedUser user = do
    Config {..} <- asks envConfig
    pure $ user `elem` trustedUsers

data TwimEnv = TwimEnv
  { envConfig :: Config
  , envCache :: Cache
  } deriving (Show, Eq)

-- | For actual operations.
newtype ViaNetwork a = ViaNetwork
  { unViaNetwork :: ReaderT TwimEnv IO a
  }
  deriving (Functor, Applicative, Monad)
  deriving newtype (MonadReader TwimEnv, MonadIO)

instance TwitterApi ViaNetwork where
  followUser = undefined
  unfollowUser = undefined
  isFollowingMe = undefined
  fetchFollowersOf = undefined
  fetchFollowingsOf = undefined
  putLog = liftIO . putStrLn
  printLog = liftIO . print

runViaNetwork :: TwimEnv -> ViaNetwork a -> IO a
runViaNetwork env = flip runReaderT env . unViaNetwork

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
