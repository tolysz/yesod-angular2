{-# LANGUAGE  OverloadedStrings #-}
module Language.JS
( diTransform )
where

import Data.Attoparsec.Text.Lazy
import Control.Applicative
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.Lazy as TL
import qualified Data.List as DL
import Debug.Trace


data Param = Param
 { pPrivate   :: Maybe Bool
 , pOptional  :: Maybe Bool
 , pInject    :: Maybe Text
 , pComponent :: Maybe Text
 }

inBrackets p = do
  skipSpace
  char '('
  params <- p `sepBy` char ','
  char ')'
  return params

-- inComment p = do
--   skipSpace
--   string "/*"
--   params <- p `sepBy` char ' '
--   string "*/"
--   return params

inComment =
  string "/*" *> manyTill' anyChar (string "*/")

getFunction = do
  string "function"
  many1 (satisfy (notInClass "(" ))
  map head <$> inBrackets (many getWord)

test1 = parse getFunction

listToString ll = "[" ++ (concat $ DL.intersperse ", " ll) ++ "]"

getWord = do
--    varname <-
  skipSpace
  c <- inComment
  many1 (satisfy (notInClass ",)" ))
  let cc = listToString $ map fix $ words c
  return cc

fix ('@':xs) = "new ng.core." ++ xs
fix ('$':xs) =      xs
fix xs = "app." ++ xs

-- priv = string "private"
-- inject = string "@Inject"
-- @Optional
-- @Attribute
-- @ContentChild
-- @ViewChild
-- @Host
-- @SkipSelf

tests =
 [ "function (/*@Inject('AppStore')*/ appStore){}"
 , "function(/*bla*/ asd, /*adsa*/ asd)"
 , "function(/* @Inject('titlePrefix') @Optional() */ titlePrefix, /* @Inject('titlePrefix') @Optional() */ titlePrefix){}"
 ]

test = map test1 tests


diTransform f =
  let
     Done _ r = test1 (traceShow f f)
  in
    TL.pack $ listToString $ r ++ [TL.unpack $ TL.stripEnd f]
