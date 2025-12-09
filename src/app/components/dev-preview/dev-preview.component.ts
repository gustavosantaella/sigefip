import { Component, OnInit } from "@angular/core";
import { CommonModule } from "@angular/common";
import { FormsModule } from "@angular/forms";
import { RouterOutlet, RouterLink } from "@angular/router";
import { Capacitor } from "@capacitor/core";
import { HomeComponent } from "../../modules/home/home.component";
import {
  IonHeader,
  IonToolbar,
  IonTitle,
  IonContent,
  IonButton,
  IonButtons,
  IonSegment,
  IonSegmentButton,
  IonLabel,
  IonIcon,
} from "@ionic/angular/standalone";
import {
  phonePortrait,
  phoneLandscape,
  tabletPortrait,
  close,
  phonePortraitOutline,
  settings,
  chevronUp,
  chevronDown,
} from "ionicons/icons";
import { addIcons } from "ionicons";

type DeviceType = "iphone" | "android" | "both";
type Orientation = "portrait" | "landscape";

@Component({
  selector: "app-dev-preview",
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    RouterOutlet,
    RouterLink,
    HomeComponent,
    IonHeader,
    IonToolbar,
    IonTitle,
    IonButton,
    IonButtons,
    IonSegment,
    IonSegmentButton,
    IonLabel,
    IonContent,
    IonIcon,
  ],
  templateUrl: "./dev-preview.component.html",
  styleUrl: "./dev-preview.component.css",
})
export class DevPreviewComponent implements OnInit {
  deviceType: DeviceType = "iphone";
  orientation: Orientation = "portrait";
  deviceSize: "phone" | "tablet" = "phone";
  controlsExpanded: boolean = false;

  constructor() {
    addIcons({
      phonePortrait,
      phoneLandscape,
      tabletPortrait,
      close,
      phonePortraitOutline,
      settings,
      chevronUp,
      chevronDown,
    });
  }

  ngOnInit() {
    // Detectar si estamos en modo desarrollo
    if (!Capacitor.isNativePlatform()) {
      // En desarrollo web, podemos usar esta vista
    }
  }

  setDeviceType(event: any) {
    this.deviceType = event.detail.value;
  }

  setOrientation(event: any) {
    this.orientation = event.detail.value;
  }

  setDeviceSize(event: any) {
    this.deviceSize = event.detail.value;
  }

  get deviceClass(): string {
    return `${this.deviceType} ${this.orientation} ${this.deviceSize}`;
  }

  get showBoth(): boolean {
    return this.deviceType === "both";
  }

  toggleControls() {
    this.controlsExpanded = !this.controlsExpanded;
  }
}

