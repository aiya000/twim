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
class Monad m => TwitterApi m where
  followUser :: TwitterUserId -> m ()
  unfollowUser :: TwitterUserId -> m ()
  doesFollowMe :: TwitterUserId -> m Bool
  -- vvv helpers
  putLog :: String -> m ()
  printLog :: Show a => a -> m ()

data TwimEnv = TwimEnv
  { envConfig :: Config
  , envCache :: Cache
  } deriving (Show, Eq)

-- | For actual operations.
newtype ViaNetwork a = ViaNetwork
  { unViaNetwork :: ReaderT TwimEnv IO a
  }
  deriving (Functor, Applicative, Monad)
  deriving newtype (MonadIO)

runViaNetwork :: TwimEnv -> ViaNetwork a -> IO a
runViaNetwork env = flip runReaderT env . unViaNetwork

instance TwitterApi ViaNetwork where
  followUser = undefined
  unfollowUser = undefined
  doesFollowMe = undefined
  putLog = liftIO . putStrLn
  printLog = liftIO . print

type Log = String

-- | For tests.
newtype ViaMock a = ViaMock
  { runViaMock :: ReaderT TwimEnv (Writer Log) a
  }
  deriving (Functor, Applicative, Monad)
  deriving newtype (MonadReader TwimEnv, MonadWriter Log)

instance TwitterApi ViaMock where
  followUser = undefined
  unfollowUser = undefined
  doesFollowMe = undefined
  putLog = tell
  printLog = putLog . show
