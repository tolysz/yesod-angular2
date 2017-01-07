module Handler.Home where

import Import
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3)
import Text.Julius (RawJS (..))
import Yesod.Angular2.DSL
import Text.Hamlet
import Text.Lucius
import Text.Blaze.Html.Renderer.Text

-- Define our data that will be used for creating the form.
data FileForm = FileForm
    { fileInfo :: FileInfo
    , fileDescription :: Text
    }

-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.
getHomeR :: Handler Html
getHomeR = defaultLayout $ do
   setTitle "Minimal Multifile"
   -- addScript AngJS
   toWidget localDemo
   toWidget [whamlet|<app-root> Loading ... |]
   toWidget [lucius|
   .example-card {
     width: 400px;
   }
   .example-header-image {
     background-image: url('https://material.angular.io/assets/img/examples/shiba1.jpg');
     background-size: cover;
   }
   |]

localDemo = run $ do
   --   jsClass "Vilain" $ return ()
     addModule "ng.material.MaterialModule.forRoot()"
     addModule "ng.flexLayout.FlexLayoutModule.forRoot()"
     jsClass "AppRoot" $ do
         "names" @= "[1,2,3,4,5,6,7,8,9]"
         bla1 ("app-root" :: Text) (renderHtml [shamlet|
         <div fxLayout=column fxLayoutAlign=warp>
            <div fxLayout=row fxLayoutAlign=warp>
                <hero-lifecycle template="ngFor let name of names" [name]=name>
            <div fxLayout=row fxLayoutAlign=warp>
                <shiba>
                <shiba>
                <shiba>
                <shiba>
                <shiba>
                <shiba>
         |])
     jsClass "Shiba" $ do
          "bla" @= [qq|"test"|]
          bla1 ("shiba" :: Text) (renderHtml [shamlet|
          <md-card class="example-card">
            <md-card-header>
              <div md-card-avatar class="example-header-image">
              <md-card-title>Shiba Inu
              <md-card-subtitle>Dog Breed
            <img md-card-image src="https://material.angular.io/assets/img/examples/shiba2.jpg">
            <md-card-content>
              <p>
                The Shiba Inu is the smallest of the six original and distinct spitz breeds of dog from Japan.
                A small, agile dog that copes very well with mountainous terrain, the Shiba Inu was originally
                bred for hunting.
            <md-card-actions>
              <button md-button>LIKE
              <button md-button>SHARE
          |])
     jsClass "Hero" $ do

          "name" @= [qq|""|]
          bla1 ("hero-lifecycle":: Text) (renderHtml [shamlet|
          <h1>Hero: {{name}}
          <md-button-toggle>zombie
          <md-button-toggle>ogre
          <md-button-toggle>blue
          <p>
            {{version | json}}
          |])
          "ngOnInit" @-> [js|function() {
           setTimeout(() => this.name = 'Windstorm', 2000);
           this.version = ng.common.VERSION;
           }|]


bla1 s t = Component @@ [js|{
  selector: '#{rawJS s}',
  template: `#{rawJS t}`,
  inputs: ['name']
}|]



postHomeR :: Handler Html
postHomeR = do
    ((result, formWidget), formEnctype) <- runFormPost sampleForm
    let handlerName = "postHomeR" :: Text
        submission = case result of
            FormSuccess res -> Just res
            _ -> Nothing

    defaultLayout $ do
        let (commentFormId, commentTextareaId, commentListId) = commentIds
        aDomId <- newIdent
        setTitle "Welcome To Yesod!"
        $(widgetFile "homepage")

sampleForm :: Form FileForm
sampleForm = renderBootstrap3 BootstrapBasicForm $ FileForm
    <$> fileAFormReq "Choose a file"
    <*> areq textField textSettings Nothing
    -- Add attributes like the placeholder and CSS classes.
    where textSettings = FieldSettings
            { fsLabel = "What's on the file?"
            , fsTooltip = Nothing
            , fsId = Nothing
            , fsName = Nothing
            , fsAttrs =
                [ ("class", "form-control")
                , ("placeholder", "File description")
                ]
            }

commentIds :: (Text, Text, Text)
commentIds = ("js-commentForm", "js-createCommentTextarea", "js-commentList")
