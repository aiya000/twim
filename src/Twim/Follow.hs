module Twim.Follow where

data OperationKind = OperationKindFollower | OperationKindFollowing
  deriving (Show)

followFromUser :: OperationKind -> IO ()
followFromUser = undefined
