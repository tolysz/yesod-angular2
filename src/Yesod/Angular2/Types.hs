{-# LANGUAGE TypeSynonymInstances, FlexibleInstances, FlexibleContexts, OverloadedStrings #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE RankNTypes, ViewPatterns, GADTs #-}
module Yesod.Angular2.Types where

import Control.Monad.Trans.Writer (Writer, WriterT)
import Data.Monoid -- (First (..), Monoid (..))
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.Lazy as TL
import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map
import qualified Data.Map.Merge.Strict as Map
import Text.Julius
import Text.Lucius
import Data.Coerce
import Data.Maybe
import Yesod.Angular2.Orphans
import qualified Data.List as DL

data Angular2 url = Angular2
  { ngName         :: First Text
  , ngExportsClass :: [JSClass url]
  , ngModules      :: [Text]
  , modAnnot       :: JavascriptUrl url
  , ngRoutes       :: [Route url]
  }

data JSClass url = JSClass
  { jscName      :: First Text
  , jscProps     :: Map Text (JavascriptUrl url)
  , jscMethods   :: Map Text (JavascriptUrl url)
  , jscComponent :: Map Text (JavascriptUrl url)
  , jscAnnot     :: JavascriptUrl url
  , jscInput     :: [Text]
  , jscCSS       :: Text
  , jscGetSet    :: Map Text (GetSet url)
  }

data GetSet url = GetSet
 { gsGet :: Maybe (JavascriptUrl url)
 , gsSet :: Maybe (JavascriptUrl url)
 }

instance Monoid (GetSet url) where
 mempty = GetSet Nothing Nothing
 mappend (GetSet a1 a2) (GetSet b1 b2) = GetSet
    (mappend a1 b1)
    (mappend b1 b2)

data Route url = Route
  { routePath       :: Maybe Text
  , routePathMatch  :: Maybe Text
  , routeComponent  :: Maybe ComponentNamable
  , routeRedirectTo :: Maybe Text
  , routeChildren   :: [Route url]
  , routeData       :: Maybe (JavascriptUrl url)
  }

instance Monoid (Route url) where
    mempty = Route mempty mempty Nothing mempty mempty mempty
    (Route a1 a2 a3 a4 a5 a6) `mappend` (Route b1 b2 b3 b4 b5 b6)
        = Route
            (mappend a1 b1)
            (mappend a2 b2)
            (mappendCN a3 b3)
            (mappend a4 b4)
            (mappend a5 b5)
            (mappend a6 b6)

mappendCN (Just a) _ = Just a
mappendCN _ (Just a) = Just a
mappendCN a _        = a

data ComponentNamable = forall a . ComponentName a => MkComponentNamable a

isNonNullRoute :: Route url -> Bool
isNonNullRoute (Route Nothing Nothing Nothing Nothing [] Nothing) = False
isNonNullRoute _ = True

renderRoute :: Route url -> JavascriptUrl url
-- renderRoute Route{..}= [js|#{rawJS r}|]
renderRoute r@Route{..}= [js|{^{body}}|]
 where
  body = mintersperse "," $ mconcat
      [ [[js|path = '#{rawJS (fromJust routePath)}'|]         | isJust routePath]
      , [[js|component = ^{cName (fromJust routeComponent)}|] | isJust routeComponent]
      , [[js|data = ^{fromJust routeData}|] | isJust routeData]
      , [[js|redirectTo = '#{rawJS (fromJust routeRedirectTo)}'|] | isJust routeRedirectTo]
      , [[js|pathMatch = '#{rawJS (fromJust routePathMatch)}'|] | isJust routePathMatch]
      , [[js|children = [^((mintersperse "," $ map renderRoute $ DL.filter isNonNullRoute routeChildren))]|] | not (DL.null routeChildren)]
      ]

class ComponentName x where
 cName :: x -> JavascriptUrl url
 cNull :: x -> Bool

instance ComponentName ComponentNamable where
 cName (MkComponentNamable cn) = cName cn
 cNull (MkComponentNamable cn) = cNull cn

-- instance ComponentName x => ComponentName (Maybe x) where
-- --  cName cl = [js|app.#{rawJS (jscName cl)}|]
--  cNull (Just n) = cNull n
--  cNull _ = True

instance ComponentName (JSClass url) where
 cName cl = [js|app.#{rawJS (jscName cl)}|]
 cNull (getFirst . jscName -> Just n) = T.null n
 cNull _ = True

renderApp :: Angular2 url -> JavascriptUrl url
renderApp Angular2{..} = [js|(function(app) {
^{routeDefs}
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
  routeDefs = "const appRoutes=[" <> (mintersperse "," $ map renderRoute $ DL.filter isNonNullRoute ngRoutes) <>"];"
  exportDefs = mconcat $ map (\cl -> [js|^{renderJSUrl cl}|]) ngExportsClass
  components1 = mintersperse "," $ map cName $ take 1 ngExportsClass
  components = mintersperse "," $ map cName ngExportsClass
  ngModulesM = mintersperse "," $ map (\m -> [js|#{rawJS m}|]) ("ng.platformBrowser.BrowserModule":ngModules ++ ["ng.router.RouterModule.forRoot(appRoutes)"| DL.length ngRoutes > 0])
  modAnnot2 = ""
--    mconcat $ map (\cl -> mconcat $ map (\i -> [js|ng.core.Input('#{rawJS i}', app.#{rawJS (jscName cl)});|]) $ jscInput cl) ngExportsClass
  appName = case ngName of
    First (Just a) -> a
    _ -> "app"

btToLines :: Text -> Text
btToLines x = mintersperse "+\n" $ map (\l -> T.pack $ show (l <> "\n")) $ T.lines x

renderJSUrl :: JSClass url -> JavascriptUrl url
renderJSUrl cl@JSClass{..} = [js|
^{cName cl} = ng.core
.Component({^{jscComponentM}})
.Class({^{annotM}});^{settersM}|]
   where
     className = [js|#{rawJS jscName}|]
     annotM = mintersperse ",\n " $ [js|constructor: function ^{className}(){^{jscPropsM}}|] : jscMethodsM
     jscPropsM = mconcat $ map (\(n,jsc) ->[js|
      this.#{rawJS n} = ^{jsc};|]) $ Map.toList jscProps
     jscMethodsM = map (\(n,jsc) -> [js|#{rawJS n} : ^{jsc}|]) $ Map.toList jscMethods
     jscComponentM = dictObj jscComponent
     dictObj = mintersperse ",\n " . map (\(n,jsc) -> [js|#{rawJS n}: ^{jsc}|]) . Map.toList

     settersM
       | Map.null jscGetSet = [js||]
       | otherwise          = mintersperse [js|;\n|] $ map (\(name,GetSet g s) -> mconcat $ mconcat
         [ [[js| Object.defineProperty(^{cName cl}.prototype, "#{rawJS name}", { |]]
         , [[js| get: ^{fromJust g},|] | isJust g ]
         , [[js| set: ^{fromJust s},|] | isJust s ]
         , [[js|  enumerable: true,
               configurable: true
             });|]]
         ] ) $ Map.toList jscGetSet

instance Monoid (Angular2 url) where
    mempty = Angular2 mempty mempty mempty mempty mempty
    (Angular2 a1 a2 modules1 a4 a5) `mappend` (Angular2 b1 b2 modules2 b4 b5)
        = Angular2
            (mappend a1 b1)
            (mappend a2 b2)
            (DL.nub (mappend modules1 modules2))
            (mappend a4 b4)
            (mappend a5 b5)

instance Monoid (JSClass url) where
    mempty = JSClass mempty mempty mempty mempty mempty mempty mempty mempty
    (JSClass a1 a2 a3 a4 a5 a6 a7 a8) `mappend` (JSClass b1 b2 b3 b4 b5 b6 b7 b8)
        = JSClass
            (mappend a1 b1)
            (mappend a2 b2)
            (mappend a3 b3)
            (mappend a4 b4)
            (mappend a5 b5)
            (mappend a6 b6)
            (mappend a7 b7)
            (mergeMonoMap a8 b8)

type GJSClass master = Writer (JSClass master)
type GAngular2 master = Writer (Angular2 master)
type GRoute master = Writer (Route master)


mergeMonoMap :: Monoid v => Map Text v -> Map Text v -> Map Text v
mergeMonoMap = Map.merge Map.preserveMissing Map.preserveMissing (Map.zipWithMatched (\_ x y -> x `mappend` y))
