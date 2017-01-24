{-# LANGUAGE NoCPP #-}
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
import Debug.Trace

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
    <button md-button  routerLink="bla" routerLinkActive="active">
        <md-icon>dialpad</md-icon>
        <span>Backup Status</span>
      </button>
      <button md-button routerLink="sta" routerLinkActive="active">
        <md-icon>voicemail</md-icon>
        <span>Backup New</span>
      </button>
      <button md-button routerLink="inf" routerLinkActive="active">
        <md-icon>notifications_off</md-icon>
        <span>Backup Info</span>
      </button>
   </div>
  </md-sidenav>

  <div class="example-sidenav-content" routerLinkActive="active">
    <router-outlet></router-outlet>
  </div>
<!--
    <button md-button (click)="sidenav.open()">
      Open sidenav
    </button>
 -->
</md-sidenav-container>
    |]
    ngStyles [qq|
.example-container {
//  width: 500px;
  height: 100vh;
//  border: 1px solid rgba(0, 0, 0, 0.5);
}

[md-button].active  {
background: orangered;
    color: white;
    -webkit-text-stroke-width: 0.7px;
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

getBackupR _ =
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
     addModule "ng.http.HttpModule"
     addModule "ng.http.JsonpModule"

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
     backupStatus
     backupNew
     backupInfo
     ngRoute mempty {routePath=Just "bla", routeComponent=Just "BackupStatus"}
     ngRoute mempty {routePath=Just "sta", routeComponent=Just "BackupNew"}
     ngRoute mempty {routePath=Just "inf", routeComponent=Just "BackupInfo"}
   toWidget [whamlet|<app-root fxLayout=row> Loading ... |]

-- bla = jsComponent "BlaRoute" $ do

backupStatus =
  jsComponent "BackupStatus" $ do
    ngSelector "backup-status"
    ngTemplate [qq|
    <h1> Backup Status </h1>
    |]

backupNew =
  jsComponent "BackupNew" $ do
    ngSelector "backup-new"
    ngTemplate [qq|<h1> Set up a new backup </h1>|]

backupInfo = do
  ngImport "Http" "@angular/http"
  jsComponent "BackupInfo" $ do
    ngSelector "backup-new"
    let x = [qt|function BackupInfo(/* $Http */ http){
    this.http = http;
    this.value = http.get('http://jsonplaceholder.typicode.com/posts/1').map(res => res.json());
    this.value2 = null;
    }|]
    "getPage" @-> [js|function(){
        console.log("click");
        this.value2 = this.http.get("http://jsonplaceholder.typicode.com/posts/2")
            .map(function (response) {
               console.log(response);
               return response.json();
               }
               )
            .catch(function(err){
          console.log(err);
            });
        console.log("click done");
    }|]
    ngCtor $ trace x x
    ngTemplate [qq|<h1>Info backup </h1>
     <button md-button (click)="getPage()" >get</button>
     {{(value | async)?.body}}
     <h2> {{(value2 | async)?.body}} </h2>
    |]
