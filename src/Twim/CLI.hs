{-# OPTIONS_GHC -Wno-missing-signatures -Wno-type-defaults #-}

{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE TemplateHaskell #-}

-- | Exposes CLI commands via shh API.
module Twim.CLI where

import Shh

-- NOTE: Too heavy
-- $(loadEnv SearchPath)

$(load SearchPath ["echo", "grep", "cat", "ls"])
