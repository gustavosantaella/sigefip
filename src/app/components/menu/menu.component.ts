import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink, RouterLinkActive, Router, NavigationEnd } from '@angular/router';
import { MenuController } from '@ionic/angular/standalone';
import { filter } from 'rxjs/operators';
import {
  IonMenu,
  IonHeader,
  IonToolbar,
  IonTitle,
  IonContent,
  IonList,
  IonItem,
  IonIcon,
  IonLabel
} from '@ionic/angular/standalone';
import {
  home,
  trendingUp,
  trendingDown,
  list,
  people,
  card,
  cash
} from 'ionicons/icons';
import { addIcons } from 'ionicons';

@Component({
  selector: 'app-menu',
  standalone: true,
  imports: [
    CommonModule,
    RouterLink,
    RouterLinkActive,
    IonMenu,
    IonHeader,
    IonToolbar,
    IonTitle,
    IonContent,
    IonList,
    IonItem,
    IonIcon,
    IonLabel
  ],
  templateUrl: './menu.component.html',
  styleUrl: './menu.component.css'
})
export class MenuComponent {
  menuItems = [
    {
      title: 'Dashboard',
      url: '/',
      icon: 'home'
    },
    {
      title: 'Ingresos',
      url: '/incomes',
      icon: 'trending-up'
    },
    {
      title: 'Egresos',
      url: '/expenses',
      icon: 'trending-down'
    },
    {
      title: 'Categorías',
      url: '/categories',
      icon: 'list'
    },
    {
      title: 'Cuentas por Cobrar',
      url: '/accounts-receivable',
      icon: 'people'
    },
    {
      title: 'Cuentas por Pagar',
      url: '/accounts-payable',
      icon: 'card'
    },
    {
      title: 'Deudas',
      url: '/debts',
      icon: 'cash'
    }
  ];

  constructor(
    private menuController: MenuController,
    private router: Router
  ) {
    addIcons({ home, trendingUp, trendingDown, list, people, card, cash });
    
    // Cerrar el menú cuando cambia la ruta
    this.router.events
      .pipe(filter(event => event instanceof NavigationEnd))
      .subscribe(() => {
        this.menuController.close();
      });
  }

  async closeMenu() {
    await this.menuController.close();
  }
}

