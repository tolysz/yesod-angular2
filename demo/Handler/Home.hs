-- language="hamlet" Pattern=/hamlet\|(.*)\|\]/
-- language="css" Pattern=/lucius\|(.*)\|\]/

module Handler.Home where

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
{-# ANN module ("HLint: ignore Parse error: |]"::String) #-}

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
getHomeR = do
--  liftIO $ ngJSA ("" :: JS.JSString)
--  liftIO $ ngJSA (ifB (true &&* false) (notB false) (false ||* true) :: JS.JSBool)
--  liftIO $ ngJSA ((3 + 4) * 5 :: JS.JSNumber)
--  liftIO $ ngJSA (askName)

 defaultLayout $ do
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
   --   jsComponentjsClass "Vilain" $ return ()
     addModule "ng.material.MaterialModule.forRoot()"
     addModule "ng.flexLayout.FlexLayoutModule.forRoot()"
     jsComponent "AppRoot" $ do
         "names" @= "[1,2,3,4,5,6,7,8,9]"
         ngSelector "app-root"
         ngTemplate (renderHtml [shamlet|
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
     jsComponent "Shiba" $ do
          "bla" @= [qq|"test"|]
          ngSelector "shiba"
          ngTemplate (renderHtml [shamlet|
          <md-card .example-card>
            <md-card-header>
              <div md-card-avatar .example-header-image>
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
     jsComponent "Hero" $ do

          "name" @= [qq|""|]
          "inputs" @@= ([qq|['name']|] :: Text)
          ngSelector "hero-lifecycle"
          ngTemplate (renderHtml [shamlet|
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


-- bla1 s t = Component @@ [js|{
--   selector: '#{rawJS s}',
--   template: `#{rawJS t}`,
--   inputs: ['name']
-- }|]


commentIds :: (Text, Text, Text)
commentIds = ("js-commentForm", "js-createCommentTextarea", "js-commentList")

componentInputDemo = [shamlet|
<form class="example-form">
  <md-input-container class="example-full-width">
    <input md-input placeholder="Company (disabled)" disabled value="Google">

  <table class="example-full-width" cellspacing="0"><tr>
    <td><md-input-container class="example-full-width">
      <input md-input placeholder="First name">
    <td><md-input-container class="example-full-width">
      <input md-input placeholder="Long Last Name That Will Be Truncated">

  <p>
    <md-input-container class="example-full-width">
      <textarea md-input placeholder="Address">1600 Amphitheatre Pkwy
    <md-input-container class="example-full-width">
      <textarea md-input placeholder="Address 2"><

  <table class="example-full-width" cellspacing="0"><tr>
    <td><md-input-container class="example-full-width">
      <input md-input placeholder="City">
    <td><md-input-container class="example-full-width">
      <input md-input placeholder="State">
    <td><md-input-container class="example-full-width">
      <input md-input "#postalCode" maxlength="5" placeholder="Postal Code" value="94043">
      <md-hint align="end">{{postalCode.value.length}} / 5
|]

componentInputDemoCSS = [lucius|
.example-form {
  width: 500px;
}

.example-full-width {
  width: 100%;
}
|]

-- rawForm :: Text
rawForm = [qq|
<form class="example-form">
  <md-input-container class="example-full-width">
    <input md-input placeholder="Company (disabled)" disabled value="Google">
  </md-input-container>

  <table class="example-full-width" cellspacing="0"><tr>
    <td><md-input-container class="example-full-width">
      <input md-input placeholder="First name">
    </md-input-container></td>
    <td><md-input-container class="example-full-width">
      <input md-input placeholder="Long Last Name That Will Be Truncated">
    </md-input-container></td>
  </tr></table>

  <p>
    <md-input-container class="example-full-width">
      <textarea md-input placeholder="Address">1600 Amphitheatre Pkwy</textarea>
    </md-input-container>
    <md-input-container class="example-full-width">
      <textarea md-input placeholder="Address 2"></textarea>
    </md-input-container>
  </p>

  <table class="example-full-width" cellspacing="0"><tr>
    <td><md-input-container class="example-full-width">
      <input md-input placeholder="City">
    </md-input-container></td>
    <td><md-input-container class="example-full-width">
      <input md-input placeholder="State">
    </md-input-container></td>
    <td><md-input-container class="example-full-width">
      <input md-input #postalCode maxlength="5" placeholder="Postal Code" value="94043">
      <md-hint align="end">{{postalCode.value.length}} / 5</md-hint>
    </md-input-container></td>
  </tr></table>
</form>
|]

{-
import {Component} from '@angular/core';
@Component({
  selector: 'input-form-example',
  templateUrl: './input-form-example.html',
  styleUrls: ['./input-form-example.css'],
})
export class InputFormExample {}
-}


demoApp = do
  addModule "ng.material.MaterialModule.forRoot()"
  addModule "ng.material.MdCoreModule.forRoot()"
  addModule "ng.material.MdRadioModule.forRoot()"
  addModule "ng.forms.FormsModule"
  jsComponent "DemoApp" $ do
      "position" @= "'before'"
      "styles"   @@~~ Clay.render (do
            ".example-tooltip-host" & do
                   display inlineFlex
                   alignItems center
                   margin (px 50) (px 50) (px 50) (px 50)
            ".example-select" &
               margin (px 10) (px 10) (px 10) (px 10)
        )
      "selector" @@~ ("main-app" :: Text)
      "template" @@~ (renderHtml [shamlet|
$#      <menu-icons-example>
$#      <sidenav-fab-example>
      <toolbar-multirow-example>
        Loading menu...
$#         <my-zippy title="form">
$#           <input-form-example> Loading ...
$#         <my-zippy>
$#           <radio-ng-model-example> Loading ...
$#         <my-zippy>
$#           <select-form-example> Loading ...
$#         <my-zippy>
$#           <slider-configurable-example> Loading ...
$#         <my-zippy>
$#           <div class="example-tooltip-host" mdTooltip="Tooltip!" [mdTooltipPosition]="position">
$#             <span>Show tooltip
$#             <md-select class="example-select" [(ngModel)]="position">
$#               <md-option value="before">Before
$#               <md-option value="after">After
$#               <md-option value="above">Above
$#               <md-option value="below">Below
$#               <md-option value="left">Left
$#               <md-option value="right">Right
      |])

inputFormExample = do
    jsComponent "InputFormExample" $ do
      ngSelector "input-form-example" 
      ngTemplate rawForm
--       "template" @@~ renderHtml componentInputDemo
      ngStyles [qq|
.example-form {
  width: 500px;
}
.example-full-width {
  width: 100%;
}
|]
radioNgModelExample = do
    addModule "ng.forms.FormsModule"
    jsComponent "RadioNgModelExample" $ do
      "input" @@~ ([qtl|[favoriteSeason]|] :: Text)
      ngSelector "radio-ng-model-example"
      ngTemplate (renderHtml [shamlet|
<md-radio-group class="example-radio-group" [(ngModel)]="favoriteSeason">
  <md-radio-button class="example-radio-button" template="ngFor: let season of seasons" [value]="season">
    {{season}}
<div class="example-selected-value">Your favorite season is: {{favoriteSeason}}
      |])
      ngClay $ do
        ".example-radio-group" & do
            display inlineFlex
            flexDirection column
        ".example-radio-button" &
            margin (px 5) (px 5) (px 5) (px 5)
        ".example-selected-value" &
            margin (px 15) 0 (px 15) 0
      "favoriteSeason" @= "null"
      "seasons" @= [qq|[
       'Winter',
       'Spring',
       'Summer',
       'Autumn',
     ]|]
selectFormExample = do
    addModule "ng.forms.FormsModule"
    jsComponent "SelectFormExample" $ do
       ngSelector "select-form-example"
       ngTemplate [qq|
<form>
  <md-select placeholder="Favorite food" [(ngModel)]="selectedValue" name="food">
    <md-option *ngFor="let food of foods" [value]="food.value">
      {{food.viewValue}}
    </md-option>
  </md-select>

  <p> Selected value: {{selectedValue}} </p>
</form>
       |]
       "selectedValue" @= "null"
       "foods" @= [qq|[
    {value: 'steak-0', viewValue: 'Steak'},
    {value: 'pizza-1', viewValue: 'Pizza'},
    {value: 'tacos-2', viewValue: 'Tacos'}
  ]|]
sliderConfigurableExample = do
    jsComponent "SliderConfigurableExample" $ do
      ngSelector "slider-configurable-example"
      ngClay $ do
        ".example-h2" & margin (px 10) (px 10) (px 10) (px 10)
        ".example-section" & do
           display flex
           alignContent center
           alignItems center
           height (px 60)
        ".example-margin" & margin (px 10) (px 10) (px 10) (px 10)
        ".md-slider-horizontal" & width (px 300)
        ".md-slider-vertical" & height  (px 300)

      ngTemplate [qq|
<md-card>
  <md-card-content>
    <h2 class="example-h2">Slider configuration</h2>

    <section class="example-section">
      <md-input-container class="example-margin">
        <input md-input type="number" placeholder="Value" [(ngModel)]="value">
      </md-input-container>
      <md-input-container class="example-margin">
        <input md-input type="number" placeholder="Min value" [(ngModel)]="min">
      </md-input-container>
      <md-input-container class="example-margin">
        <input md-input type="number" placeholder="Max value" [(ngModel)]="max">
      </md-input-container>
      <md-input-container class="example-margin">
        <input md-input type="number" placeholder="Step size" [(ngModel)]="step">
      </md-input-container>
    </section>

    <section class="example-section">
      <md-checkbox class="example-margin" [(ngModel)]="showTicks">Show ticks</md-checkbox>
      <md-checkbox class="example-margin" [(ngModel)]="autoTicks" *ngIf="showTicks">
        Auto ticks
      </md-checkbox>
      <md-input-container class="example-margin" *ngIf="showTicks && !autoTicks">
        <input md-input type="number" placeholder="Tick interval" [(ngModel)]="tickInterval">
      </md-input-container>
    </section>

    <section class="example-section">
      <md-checkbox class="example-margin" [(ngModel)]="thumbLabel">Show thumb label</md-checkbox>
    </section>

    <section class="example-section">
      <md-checkbox class="example-margin" [(ngModel)]="vertical">Vertical</md-checkbox>
      <md-checkbox class="example-margin" [(ngModel)]="invert">Inverted</md-checkbox>
    </section>

    <section class="example-section">
      <md-checkbox class="example-margin" [(ngModel)]="disabled">Disabled</md-checkbox>
    </section>

  </md-card-content>
</md-card>

<md-card class="result">
  <md-card-content>
    <h2 class="example-h2">Result</h2>

    <md-slider
        class="example-margin"
        [disabled]="disabled"
        [invert]="invert"
        [max]="max"
        [min]="min"
        [step]="step"
        [thumb-label]="thumbLabel"
        [tick-interval]="tickInterval"
        [value]="value"
        [vertical]="vertical">
    </md-slider>
  </md-card-content>
</md-card>
      |]
      "selectedValue" @= "null"
      "autoTicks" @= "false"
      "disabled" @= "false"
      "invert" @= "false"
      "max" @= "100"
      "min" @= "0"
      "showTicks" @= "false"
      "step" @= "1"
      "thumbLabel" @= "false"
      "value" @= "0"
      "vertical" @= "false"
      "tickInterval" @> [js|function(){return this.showTicks ? (this.autoTicks ? 'auto' : this._tickInterval) : null;}|]
      "tickInterval" @< [js|function(v){this._tickInterval = Number(v);}|]
      "_tickInterval" @= "1"

{-
      Object.defineProperty(foo.prototype, "tickInterval", {
        get: function () {
            return this.showTicks ? (this.autoTicks ? 'auto' : this._tickInterval) : null;
        },
        set: function (v) {
            this._tickInterval = Number(v);
        },
      });
-}

getCIR = defaultLayout $ do
  setTitle "Minimal Multifile"
  toWidget $ run $ do
    addModule "ng.material.MaterialModule.forRoot()"
    addModule "ng.material.MdCoreModule.forRoot()"
    addModule "ng.material.MdRadioModule.forRoot()"
    addModule "ng.flexLayout.FlexLayoutModule.forRoot()"
    addModule "ng.forms.FormsModule"
    demoApp
--     inputFormExample
--     radioNgModelExample
--     selectFormExample
--     sliderConfigurableExample
--     menuIconsExample
--     sidenavFabExample
    toolbarMultirowExample
--     myZippy
--   toWidget $ run $ do
  toWidget [whamlet|
    <main-app> Loading...
  |]

toolbarMultirowExample =
 jsComponent "ToolbarMultirowExample" $ do
 ngSelector "toolbar-multirow-example"
 ngTemplate [qq|
 <md-toolbar color="primary">
   <span>Custom Toolbar</span>

   <md-toolbar-row>
     <span>Second Line</span>
     <span class="example-spacer"></span>
     <md-icon class="example-icon">verified_user</md-icon>
   </md-toolbar-row>

   <md-toolbar-row>
     <span>Third Line</span>
     <span class="example-spacer"></span>
     <md-icon class="example-icon">favorite</md-icon>
     <md-icon class="example-icon">delete</md-icon>
   </md-toolbar-row>
 </md-toolbar>
 |]
 ngClay $ do
    ".example-icon" & padding 0 (px 14) 0 (px 14)
--     ".example-spacer" & "flex" "1 1 auto"

sidenavFabExample =
 jsComponent "MenuIconsExample" $ do
 ngSelector "sidenav-fab-example"
 ngTemplate [qq|
<md-sidenav-container class="example-sidenav-fab-container">
  <md-sidenav #sidenav mode="side" opened="true">
    <button md-mini-fab class="example-fab" (click)="sidenav.toggle()">
      <md-icon>add</md-icon>
    </button>
    <div class="example-scrolling-content">
      Lorem ipsum dolor sit amet, pede a libero aenean phasellus, lectus metus sint ut risus,
      fusce vel in pellentesque. Nisl rutrum etiam morbi consectetuer tempor magna, aenean nullam
      nunc id, neque vivamus interdum sociis nulla scelerisque sem, dolor id wisi turpis magna
      aliquam magna. Risus accumsan hac eget etiam donec sed, senectus erat mattis quam, tempor
      vel urna occaecat cras, metus urna augue nec at. Et morbi amet dui praesent, nec eu at,
      ligula ipsum dui sollicitudin, quis nisl massa viverra ligula, mauris fermentum orci arcu
      enim fringilla. Arcu erat nulla in aenean lacinia ullamcorper, urna ante nam et sagittis,
      tristique vehicula nibh ipsum vivamus, proin proin. Porta commodo nibh quis libero amet.
      Taciti dui, sapien consectetuer.
    </div>
  </md-sidenav>
  <button md-mini-fab class="example-fab" (click)="sidenav.toggle()">
    <md-icon>add</md-icon>
  </button>
  <div class="example-scrolling-content">
    Lorem ipsum dolor sit amet, pede a libero aenean phasellus, lectus metus sint ut risus, fusce
    vel in pellentesque. Nisl rutrum etiam morbi consectetuer tempor magna, aenean nullam nunc id,
    neque vivamus interdum sociis nulla scelerisque sem, dolor id wisi turpis magna aliquam magna.
    Risus accumsan hac eget etiam donec sed, senectus erat mattis quam, tempor vel urna occaecat
    cras, metus urna augue nec at. Et morbi amet dui praesent, nec eu at, ligula ipsum dui
    sollicitudin, quis nisl massa viverra ligula, mauris fermentum orci arcu enim fringilla. Arcu
    erat nulla in aenean lacinia ullamcorper, urna ante nam et sagittis, tristique vehicula nibh
    ipsum vivamus, proin proin. Porta commodo nibh quis libero amet. Taciti dui, sapien
    consectetuer.
  </div>
</md-sidenav-container>
 |]
 ngStyles [qq|
.example-sidenav-fab-container {
  width: 500px;
  height: 300px;
  border: 1px solid rgba(0, 0, 0, 0.5);
}

.example-sidenav-fab-container md-sidenav {
  max-width: 200px;
}

.example-sidenav-fab-container .md-sidenav-content,
.example-sidenav-fab-container md-sidenav {
  display: flex;
  overflow: visible;
}

.example-scrolling-content {
  overflow: auto;
}

.example-fab {
  position: absolute;
  right: 20px;
  bottom: 10px;
}
 |]
menuIconsExample = do
  jsComponent "MenuIconsExample" $ do
  ngSelector "menu-icons-example"
  ngTemplate [qq|
<button md-icon-button [mdMenuTriggerFor]="menu">
  <md-icon>more_vert</md-icon>
</button>
<md-menu #menu="mdMenu">
  <button md-menu-item>
    <md-icon>dialpad</md-icon>
    <span>Redial</span>
  </button>
  <button md-menu-item disabled>
    <md-icon>voicemail</md-icon>
    <span>Check voicemail</span>
  </button>
  <button md-menu-item>
    <md-icon>notifications_off</md-icon>
    <span>Disable alerts</span>
  </button>
</md-menu>
  |]

appComponent = do
  addModule "ng.forms.FormsModule"
  addModule "ng.material.MaterialModule.forRoot()"
  addModule "ng.material.MdCoreModule.forRoot()"
  addModule "ng.material.MdRadioModule.forRoot()"

  jsComponent "SelectFormExample" $ do
     "title" @= "'Tour of Heroes'"
     "selectedHero" @="null"
     "onSelect" @-> [js|function(hero){
       this.selectedHero = hero;
     }|]
     "heroes"  @= [qq|[
  { id: 11, name: 'Mr. Nice' },
  { id: 12, name: 'Narco' },
  { id: 13, name: 'Bombasto' },
  { id: 14, name: 'Celeritas' },
  { id: 15, name: 'Magneta' },
  { id: 16, name: 'RubberMan' },
  { id: 17, name: 'Dynama' },
  { id: 18, name: 'Dr IQ' },
  { id: 19, name: 'Magma' },
  { id: 20, name: 'Tornado' }
]|]
     ngSelector "my-app"
     ngTemplate [qq|
    <h1>{{title}}</h1>
    <h2>My Heroes</h2>
    <ul class="heroes">
      <li *ngFor="let hero of heroes"
        [class.selected]="hero === selectedHero"
        (click)="onSelect(hero)">
        <span class="badge">{{hero.id}}</span> {{hero.name}}
      </li>
    </ul>
    <div *ngIf="selectedHero">
      <h2>{{selectedHero.name}} details!</h2>
      <div><label>id: </label>{{selectedHero.id}}</div>
      <div>
        <label>name: </label>
        <input [(ngModel)]="selectedHero.name" placeholder="name"/>
      </div>
    </div>
     |]
--      "encapsulation" @@= ("ng.core.ViewEncapsulation.Emulated" :: Text)
     ngStyles [qq|
    .selected {
      background-color: #CFD8DC !important;
      color: white;
    }
    .heroes {
      margin: 0 0 2em 0;
      list-style-type: none;
      padding: 0;
      width: 15em;
    }
    .heroes li {
      cursor: pointer;
      position: relative;
      left: 0;
      background-color: #EEE;
      margin: .5em;
      padding: .3em 0;
      height: 1.6em;
      border-radius: 4px;
    }
    .heroes li.selected:hover {
      background-color: #BBD8DC !important;
      color: white;
    }
    .heroes li:hover {
      color: #607D8B;
      background-color: #DDD;
      left: .1em;
    }
    .heroes .text {
      position: relative;
      top: -3px;
    }
    .heroes .badge {
      display: inline-block;
      font-size: small;
      color: white;
      padding: 0.8em 0.7em 0 0.7em;
      background-color: #607D8B;
      line-height: 1em;
      position: relative;
      left: -1px;
      top: -4px;
      height: 1.8em;
      margin-right: .8em;
      border-radius: 4px 0 0 4px;
    }
|]

getHeroR = defaultLayout $ do
  setTitle "The Hero Editor"
  toWidget $ run $ do
     appComponent
  toWidget [lucius|
h1 {
  color: #369;
  font-family: Arial, Helvetica, sans-serif;
  font-size: 250%;
}
h2, h3 {
  color: #444;
  font-family: Arial, Helvetica, sans-serif;
  font-weight: lighter;
}
body {
  margin: 2em;
}
body, input[text], button {
  color: #888;
  font-family: Cambria, Georgia;
}
a {
  cursor: pointer;
  cursor: hand;
}
button {
  font-family: Arial;
  background-color: #eee;
  border: none;
  padding: 5px 10px;
  border-radius: 4px;
  cursor: pointer;
  cursor: hand;
}
button:hover {
  background-color: #cfd8dc;
}
button:disabled {
  background-color: #eee;
  color: #aaa;
  cursor: auto;
}

/* Navigation link styles */
nav a {
  padding: 5px 10px;
  text-decoration: none;
  margin-right: 10px;
  margin-top: 10px;
  display: inline-block;
  background-color: #eee;
  border-radius: 4px;
}
nav a:visited, a:link {
  color: #607D8B;
}
nav a:hover {
  color: #039be5;
  background-color: #CFD8DC;
}
nav a.active {
  color: #039be5;
}

/* items class */
.items {
  margin: 0 0 2em 0;
  list-style-type: none;
  padding: 0;
  width: 24em;
}
.items li {
  cursor: pointer;
  position: relative;
  left: 0;
  background-color: #EEE;
  margin: .5em;
  padding: .3em 0;
  height: 1.6em;
  border-radius: 4px;
}
.items li:hover {
  color: #607D8B;
  background-color: #DDD;
  left: .1em;
}
.items li.selected {
  background-color: #CFD8DC;
  color: white;
}
.items li.selected:hover {
  background-color: #BBD8DC;
}
.items .text {
  position: relative;
  top: -3px;
}
.items .badge {
  display: inline-block;
  font-size: small;
  color: white;
  padding: 0.8em 0.7em 0 0.7em;
  background-color: #607D8B;
  line-height: 1em;
  position: relative;
  left: -1px;
  top: -4px;
  height: 1.8em;
  margin-right: .8em;
  border-radius: 4px 0 0 4px;
}
/* everywhere else */
* {
  font-family: Arial, Helvetica, sans-serif;
}
  |]
  toWidget [whamlet|
     <my-app> Loading...
  |]


myZippy = do
   jsComponent "ZippyComponent" $ do
      ngSelector "my-zippy"
      "input" @@= ([qq|["title"]|] :: Text)
      "name" @= [qq|""|]
      "toggle" @-> [js|function(){
          this.visible = !this.visible;
        }|]
      ngTemplate [qq|
      <div class="zippy">
        <div (click)="toggle()" class="zippy__title">
        ▾ Details
        </div>
        <div [hidden]="!visible" class="zippy__content">
          <ng-content></ng-content>
        </div>
      </div>
      |]
      ngClay $ ".zippy" & background green

getSliderR = defaultLayout $ do

  toWidget $ run $ do
    addModule "ng.forms.FormsModule"
    addModule "ng.material.MaterialModule.forRoot()"
    addModule "ng.material.MdCoreModule.forRoot()"
    addModule "ng.material.MdRadioModule.forRoot()"
    sliderConfigurableExample
  toWidget [whamlet|
         <slider-configurable-example> Loading...
      |]
