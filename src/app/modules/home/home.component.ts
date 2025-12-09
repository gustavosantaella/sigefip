import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Capacitor } from '@capacitor/core';
import { 
  IonHeader, 
  IonToolbar, 
  IonTitle, 
  IonContent, 
  IonCard, 
  IonCardHeader, 
  IonCardTitle, 
  IonCardContent,
  IonItem,
  IonLabel,
  IonList,
  IonIcon,
  IonButton
} from '@ionic/angular/standalone';
import { RouterLink } from '@angular/router';
import { checkmarkCircle, phonePortrait } from 'ionicons/icons';
import { addIcons } from 'ionicons';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [
    CommonModule,
    RouterLink,
    IonHeader,
    IonToolbar,
    IonTitle,
    IonContent,
    IonCard,
    IonCardHeader,
    IonCardTitle,
    IonCardContent,
    IonItem,
    IonLabel,
    IonList,
    IonIcon,
    IonButton
  ],
  templateUrl: './home.component.html',
  styleUrl: './home.component.css'
})
export class HomeComponent {
  platform = 'web';
  isNative = false;

  constructor() {
    this.platform = Capacitor.getPlatform();
    this.isNative = Capacitor.isNativePlatform();
    addIcons({ checkmarkCircle, phonePortrait });
  }
}

