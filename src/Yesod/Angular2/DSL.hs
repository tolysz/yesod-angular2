{-# LANGUAGE TypeSynonymInstances, FlexibleInstances, FlexibleContexts, OverloadedStrings #-}
module Yesod.Angular2.DSL
 ( qq
 , (@@)
 , (@=)
 , (@~)
 , (@>)
 , (@<)
 , (@@~)
 , (@@=)
 , (@@~~)
 , (@->)
 , jsClass
 , addModule
 , run
 , bla
 , ngSelector
 , ngTemplate
 , ngStyles
 , ngClay
 , js
 , demo
 , Decorator(..)
 )
where

import Data.String
import qualified Clay
import Data.Monoid
import Data.Map.Strict as Map
import Data.String.QM
import Text.Julius
import qualified Data.Text as T
import Data.Text (Text)

import qualified Data.Text.Lazy as TL
import qualified Data.Text.Lazy.Builder as B (singleton, fromString)
import Control.Monad.Trans.Writer (WriterT, runWriterT, tell, execWriter, runWriterT)
import Yesod.Angular2.Types

data Decorator
  = Component
  | Directive

(@@) :: Decorator -> JavascriptUrl url -> GJSClass url ()
Component @@ jsc = tell mempty {jscAnnot = [js|.Component(^{jsc})|]}

(@=) :: Text -> JavascriptUrl url -> GJSClass url ()
name @= jsc = tell mempty {jscProps = Map.singleton name jsc, jscInput = [name]}

(@>) :: Text -> JavascriptUrl url -> GJSClass url ()
name @> jsc = tell mempty {jscGetSet = Map.singleton name (mempty{gsGet = Just jsc})}

(@<) :: Text -> JavascriptUrl url -> GJSClass url ()
name @< jsc = tell mempty {jscGetSet = Map.singleton name (mempty{gsSet = Just jsc})}

(@~) :: RawJS a => Text -> a -> GJSClass url ()
name @~ txt = tell mempty {jscProps = Map.singleton name [js|`#{rawJS txt}`|]}

(@@=) :: RawJS a => Text -> a -> GJSClass url ()
name @@= txt = tell mempty {jscComponent = Map.singleton name [js|#{rawJS txt}|]}

(@@~) :: RawJS a => Text -> a -> GJSClass url ()
name @@~ txt = tell mempty {jscComponent = Map.singleton name [js|`#{rawJS txt}`|]}

(@@~~) :: RawJS a => Text -> a -> GJSClass url ()
name @@~~ txt = tell mempty {jscComponent = Map.singleton name [js|[`#{rawJS txt}`]|]}

(@->) :: Text -> JavascriptUrl url -> GJSClass url ()
name @-> jsc =  tell mempty {jscMethods = Map.singleton name jsc}

jsClass :: Text -> GJSClass url () -> GAngular2 url ()
jsClass name cl = tell mempty { ngExportsClass = [ execWriter $ do
                   tell mempty {jscName = First (Just name)}
                   cl
              ] }
addModule :: Text -> GAngular2 url ()
addModule m = tell mempty { ngModules = [m] }

{-
export class HeroComponent {
  title = 'Hero Detail';
  getName() {return 'Windstorm'; }
}

===

app.HeroComponent = HeroComponent; // "export"
HeroComponent.annotations = [
  new ng.core.Component({
    selector: 'hero-view',
    template: '<h1>{{title}}: {{getName()}}</h1>'
  })
];
function HeroComponent() {
  this.title = "Hero Detail";
}
HeroComponent.prototype.getName = function() { return 'Windstorm'; };



-}
bla = Component @@ [js|{
  selector: 'hero-lifecycle',
  template: `<h1>Hero: {{name}}</h1><md-button-toggle>zombie</md-button-toggle>`
}|]

run = renderApp . execWriter

demo = run $ do
--   jsClass "Vilain" $ return ()
  addModule "ng.material.MaterialModule.forRoot()"
  jsClass "Hero" $ do
       "bla" @= [qq|"test"|]
       "ola" @= "{}"
       bla
       "ngOnInit" @-> [js|function() {setTimeout(() => this.name = 'Windstorm', 0);}|]

ngSelector :: TL.Text -> GJSClass url ()
ngSelector s = "selector" @@~ s

ngTemplate :: TL.Text -> GJSClass url ()
ngTemplate t = "template" @@~ t

ngStyles :: TL.Text -> GJSClass url ()
ngStyles t = "styles" @@~~ t

ngClay :: Clay.Css -> GJSClass url ()
ngClay = ("styles" @@~~) . Clay.render