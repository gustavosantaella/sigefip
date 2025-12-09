import { Component } from "@angular/core";
import { RouterOutlet } from "@angular/router";
import { IonApp, IonRouterOutlet } from "@ionic/angular/standalone";
import { MenuComponent } from "./components/menu/menu.component";

@Component({
  selector: "app-root",
  standalone: true,
  imports: [IonApp, IonRouterOutlet, MenuComponent],
  template: `
    <ion-app>
      <app-menu></app-menu>
      <ion-router-outlet id="main-content"></ion-router-outlet>
    </ion-app>
  `,
  styles: [],
})
export class AppComponent {
  title = "Sigefip";
}
