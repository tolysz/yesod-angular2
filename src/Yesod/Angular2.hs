
module Yesod.Angular2 where

{-
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';
import {
  LocationStrategy,
  HashLocationStrategy
} from '@angular/common';

var platformBrowserDynamic = ng.platformBrowserDynamic.platformBrowserDynamic;
var LocationStrategy = ng.common.LocationStrategy;
var HashLocationStrategy = ng.common.HashLocationStrategy;

export class HeroComponent {
  title = 'Hero Detail';
  getName() {return 'Windstorm'; }
}

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
HeroComponent.prototype.getName = function() { return 'Windstorm'; };-}
