{-# LANGUAGE NoOverloadedStrings #-}

module Twim.Main where

import Control.Monad.Extra (whenM)
import Data.Maybe (isJust)
import Data.String.Here (i)
import System.IO (hSetBuffering, stdout, BufferMode (..))
import Twim.CliOptions
import Twim.Config
import Twim.Follow
import Twim.Unfollow

defaultMain :: IO ()
defaultMain = do
  hSetBuffering stdout NoBuffering
  parseCliOptions >>= \case
    InitConfig -> readConfig >>= initConfig' . isJust
    Unfollow -> readConfigForcely >>= unfollow
    Follow target -> readConfigForcely >>= follow target
  where
    initConfig' :: Bool -> IO ()
    initConfig' configIsExistent = do
      if configIsExistent
        then initConfigIfAgree
        else initConfig''

    initConfigIfAgree :: IO ()
    initConfigIfAgree =
      whenM confirm initConfig''

    initConfig'' = do
      initConfig
      configPath <- getConfigFilePath
      putStrLn $ "Your config is initialized: " <> configPath
      putStrLn "Done."

    confirm = do
      putStrLn =<< getConfirmation
      getLine >>= \case
        "" -> confirm
        ans -> if
          | ans `elem` yes -> pure True
          | ans `elem` no -> pure False
          | otherwise -> do
            putStrLn [i|At here, you can input just {yes} or {no}.|]
            confirm

    getConfirmation = do
      path <- getConfigFilePath
      pure $
        (path <> " is already existent.\n") <>
        "Do you really initialize this? (y/n)"

    yes = ["y", "Y", "yes", "Yes"]
    no = ["n", "N", "no", "No"]

    readConfigForcely =
      readConfig >>= \case
        Nothing -> fail noSuchConfigError
        Just conf -> pure conf

    noSuchConfigError =
      "No such config file.\n" <>
      "Please run `$ twim init-config` before run this app."
