{-# LANGUAGE TypeSynonymInstances, FlexibleInstances, FlexibleContexts, OverloadedStrings #-}

module Yesod.Angular2.Orphans where

import Data.String
-- import Data.String.QM
import Text.Julius
import Data.Monoid
import qualified Data.Text.Lazy as TL
-- import qualified Data.Text as T
-- import Data.Text (Text)

instance Show (JavascriptUrl url) where
  show = TL.unpack . renderJavascriptUrl (\_ _ -> undefined)

instance IsString (JavascriptUrl url) where
  fromString x = [js|#{rawJS x}|]

instance RawJS a => (RawJS (First a)) where
  rawJS (First (Just a)) = rawJS a
  rawJS _ = RawJavascript ""


mintersperse _ []     = mempty
mintersperse _ [a]    = a
mintersperse b (a:bs) = a <> b <> mintersperse b bs