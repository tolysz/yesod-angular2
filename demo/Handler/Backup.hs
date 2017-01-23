module Handler.Backup where

import Import
import Text.Julius (RawJS (..))
import Yesod.Angular2.DSL
import Text.Hamlet
import Text.Lucius
import Data.String.QM
import Text.Css                    (Block(..))
import Clay hiding ((@=),Css)
import qualified Clay
import Text.Blaze.Html.Renderer.Text


sideNav =
 jsComponent "SidenavOverviewExample" $ do
    ngSelector "sidenav-overview-example"
    "toggle" @-> [js|function(){
        this.visible = !this.visible;
      }|]
--       fxShow [fxShow.gt-sm]="sidenav.opened"
    ngTemplate [qq|

<md-sidenav-container class="example-container">
  <md-sidenav #sidenav class="example-sidenav" opened="true" mode="side">
    <div fxLayout="column" fxLayoutWrap="wrap">
     <button md-button>
        <md-icon>dialpad</md-icon>
        <span>Redial</span>
      </button>
      <button md-button>
        <md-icon>voicemail</md-icon>
        <span>Check voicemail</span>
      </button>
      <button md-button>
        <md-icon>notifications_off</md-icon>
        <span>Disable alerts</span>
      </button>
   </div>
  </md-sidenav>

<!--
  <div class="example-sidenav-content" fxHide fxHide.gt-sm>
    <button md-button (click)="sidenav.open()">
      Open sidenav
    </button>
  </div>
 -->
</md-sidenav-container>
    |]
    ngStyles [qq|
.example-container {
//  width: 500px;
  height: 100vh;
//  border: 1px solid rgba(0, 0, 0, 0.5);
}

.example-sidenav-content {
  display: flex;
  height: 100%;
  align-items: center;
  justify-content: center;
}

.example-sidenav {
  padding: 20px;
}
   |]

getBackupR =
 defaultLayout $ do
   setTitle "Backup Commander"
   -- addScript AngJS
--    toWidget localDemo
   toWidget $ run $ do
     addModule "ng.forms.FormsModule"
     addModule "ng.material.MaterialModule.forRoot()"
     addModule "ng.material.MdCoreModule.forRoot()"
     addModule "ng.material.MdRadioModule.forRoot()"
     addModule "ng.flexLayout.FlexLayoutModule.forRoot()"
     jsComponent "AppRoot" $ do
         ngSelector "app-root"
         ngTemplate (renderHtml [shamlet|
         <sidenav-overview-example>
$#         <div fxLayout=column fxLayoutAlign=warp>
$#            <div fxLayout=row fxLayoutAlign=warp>
$#                <hero-lifecycle template="ngFor let name of names" [name]=name>
$#            <div fxLayout=row fxLayoutAlign=warp>
$#                <shiba>
         |])
     sideNav
     ngRoute mempty {routePath="bla", routeComponent="CrisisListComponent"}
   toWidget [whamlet|<app-root fxLayout=row> Loading ... |]

-- bla = jsComponent "BlaRoute" $ do