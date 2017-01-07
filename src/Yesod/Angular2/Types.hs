{-# LANGUAGE TypeSynonymInstances, FlexibleInstances, FlexibleContexts, OverloadedStrings #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE RecordWildCards #-}
module Yesod.Angular2.Types where

import Control.Monad.Trans.Writer (Writer, WriterT)
import Data.Monoid -- (First (..), Monoid (..))
import Data.Text (Text)
import qualified Data.Text.Lazy as TL
import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map
import Text.Julius
import Text.Lucius
import Yesod.Angular2.Orphans

data Angular2 url = Angular2
  { ngName         :: First Text
  , ngExportsClass :: [JSClass url]
  , ngModules      :: [Text]
  , modAnnot       :: JavascriptUrl url
  }

data JSClass url = JSClass
  { jscName    :: First Text
  , jscProps   :: Map Text (JavascriptUrl url)
  , jscMethods :: Map Text (JavascriptUrl url)
  , jscAnnot   :: JavascriptUrl url
  , jscInput   :: [Text]
  , jscCSS     :: Text
  }

renderApp :: Angular2 url -> JavascriptUrl url
renderApp Angular2{..} = [js|(function(app) {
^{exportDefs}
ng.core.enableProdMode();
app.AppModule =
    ng.core.NgModule({
      imports: [ ^{ngModulesM} ],
      declarations: [ ^{components} ],
      bootstrap: [ ^{components1} ]
    })
    .Class({
      constructor: function() {
      }
    });
^{modAnnot2}
  document.addEventListener('DOMContentLoaded', function() {
    ng.platformBrowserDynamic
      .platformBrowserDynamic()
      .bootstrapModule(app.AppModule);
  });
})(window.#{rawJS appName} || (window.#{rawJS appName} = {}));|]
 where
--   exportNames = mconcat $ map (\cl -> [js|
-- #{rawJS (jscName cl)};|]) ngExportsClass
  exportDefs = mconcat $ map (\cl -> [js|app.#{rawJS (jscName cl)} = ng.core^{renderJSUrl cl};|]) ngExportsClass
  components1 = mintersperse "," $ map (\cl -> [js|app.#{rawJS (jscName cl)}|]) $ take 1 ngExportsClass
  components = mintersperse "," $ map (\cl -> [js|app.#{rawJS (jscName cl)}|]) ngExportsClass
  ngModulesM = mintersperse "," $ map (\m -> [js|#{rawJS m}|]) ("ng.platformBrowser.BrowserModule":ngModules)
  modAnnot2 = ""
--    mconcat $ map (\cl -> mconcat $ map (\i -> [js|ng.core.Input('#{rawJS i}', app.#{rawJS (jscName cl)});|]) $ jscInput cl) ngExportsClass
  appName = case ngName of
    First (Just a) -> a
    _ -> "app"

renderJSUrl :: JSClass url -> JavascriptUrl url
renderJSUrl JSClass{..} = [js|^{jscAnnot}.Class({
 ^{annotM} }) |]
   where
     className = [js|#{rawJS jscName}|]
     annotM = mintersperse ",\n " $ [js|constructor: function ^{className}(){^{jscPropsM}}|] : jscMethodsM
     jscPropsM = mconcat $ map (\(n,jsc) ->[js|
      this.#{rawJS n} = ^{jsc};|]) $ Map.toList jscProps
     jscMethodsM = map (\(n,jsc) -> [js|#{rawJS n} : ^{jsc}|]) $ Map.toList jscMethods

-- instance Show (JSClass url) where
--   show JSClass{..} = concat
--     [ show [js| this.#{rawJS jscName} = #{jscProps};|]
--     ]
--    where
--      toJs = TL.unpack . renderJavascriptUrl (\_ _ -> undefined)

instance Monoid (Angular2 url) where
    mempty = Angular2 mempty mempty mempty mempty
    (Angular2 a1 a2 a3 a4) `mappend` (Angular2 b1 b2 b3 b4)
        = Angular2
            (mappend a1 b1)
            (mappend a2 b2)
            (mappend a3 b3)
            (mappend a4 b4)

instance Monoid (JSClass url) where
    mempty = JSClass mempty mempty mempty mempty mempty mempty
    (JSClass a1 a2 a3 a4 a5 a6) `mappend` (JSClass b1 b2 b3 b4 b5 b6)
        = JSClass
            (mappend a1 b1)
            (mappend a2 b2)
            (mappend a3 b3)
            (mappend a4 b4)
            (mappend a5 b5)
            (mappend a6 b6)

type GJSClass master = Writer (JSClass master)
type GAngular2 master = Writer (Angular2 master)
