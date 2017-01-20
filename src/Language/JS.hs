{-# LANGUAGE  OverloadedStrings #-}
module Language.JS where

import Data.Attoparsec.Text.Lazy


getFunction = do
  string "function"
  skipSpace
  char '('
  params <- getParams `sepBy` (char ',')
  char ')'
  return params

test1 = parse getFunction

getParams = do
  many1 (satisfy (notInClass ",)" ))


tests =
 [ "function (@Inject('AppStore') private appStore){}"
 , "function(bla asd, adsa, asd)"
 ]

test = map test1 tests