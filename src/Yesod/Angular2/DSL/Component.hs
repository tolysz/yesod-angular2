-- {-# Language OverloadedRecordFields #-}
{-# LANGUAGE TemplateHaskell #-}
module Yesod.Angular2.DSL.Component where
--
-- import Text.Julius
-- import Data.Text
-- import Data.DeriveTH
-- import Data.Lens.Common
-- import Data.Maybe
--
-- data Component url = Component
--   { animations      :: Maybe (JavascriptUrl url)
--   , changeDetection :: Maybe (JavascriptUrl url)
--   , encapsulation   :: Maybe (JavascriptUrl url)
--   , entryComponents :: Maybe (JavascriptUrl url)
--   , exportAs        :: Maybe (JavascriptUrl url)
--   , host            :: Maybe (JavascriptUrl url)
--   , inputs          :: [Text]
--   , outputs         :: [Text]
--   , interpolation   :: Maybe (JavascriptUrl url)
--   , moduleId        :: Maybe (JavascriptUrl url)
--   , providers       :: Maybe (JavascriptUrl url)
--   , queries         :: Maybe (JavascriptUrl url)
--   , selector        :: Maybe (JavascriptUrl url)
--   , styleUrls       :: Maybe (JavascriptUrl url)
--   , styles          :: [Text]
--   , template        :: Maybe (JavascriptUrl url)
--   , templateUrl     :: Maybe (JavascriptUrl url)
--   , viewProviders   :: Maybe (JavascriptUrl url)
--   }
--
-- derives [makeLens, makeMonoid] [''Component]

{-
animations      - list of animations of this component
changeDetection - change detection strategy used by this component
encapsulation   - style encapsulation strategy used by this component
entryComponents - list of components that are dynamically inserted into the view of this component
exportAs        - name under which the component instance is exported in a template
host            - map of class property to host element bindings for events, properties and attributes
inputs          - list of class property names to data-bind as component inputs
interpolation   - custom interpolation markers used in this component's template
moduleId        - ES/CommonJS module id of the file in which this component is defined
outputs         - list of class property names that expose output events that others can subscribe to
providers       - list of providers available to this component and its children
queries         - configure queries that can be injected into the component
selector        - css selector that identifies this component in a template
styleUrls       - list of urls to stylesheets to be applied to this component's view
styles          - inline-defined styles to be applied to this component's view
template        - inline-defined template for the view
templateUrl     - url to an external file containing a template for the view
viewProviders   - list of providers available to this component and its view children
-}