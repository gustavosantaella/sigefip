import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import {
  IonHeader,
  IonToolbar,
  IonTitle,
  IonContent,
  IonList,
  IonItem,
  IonLabel,
  IonButton,
  IonIcon,
  IonFab,
  IonFabButton,
  IonModal,
  IonInput,
  IonSelect,
  IonSelectOption,
  IonButtons,
  IonBackButton,
  IonBadge,
  IonMenuButton
} from '@ionic/angular/standalone';
import { add, create, trash } from 'ionicons/icons';
import { addIcons } from 'ionicons';
import { CategoryService } from '../../services/offline/category.service';
import { Category } from '../../models/category.model';

@Component({
  selector: 'app-categories',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    RouterLink,
    IonHeader,
    IonToolbar,
    IonTitle,
    IonContent,
    IonList,
    IonItem,
    IonLabel,
    IonButton,
    IonIcon,
    IonFab,
    IonFabButton,
    IonModal,
    IonInput,
    IonSelect,
    IonSelectOption,
    IonButtons,
    IonBackButton,
    IonBadge,
    IonMenuButton
  ],
  templateUrl: './categories.component.html',
  styleUrl: './categories.component.css'
})
export class CategoriesComponent implements OnInit {
  categories: Category[] = [];
  isModalOpen = false;
  editingCategory: Category | null = null;
  
  formData = {
    name: '',
    type: 'income' as 'income' | 'expense',
    color: '#3880ff',
    icon: 'cash'
  };

  colors = ['#3880ff', '#2dd36f', '#ffc409', '#eb445a', '#92949c', '#f4f5f8'];
  icons = ['cash', 'card', 'wallet', 'trending-up', 'trending-down', 'home', 'car', 'restaurant', 'medical', 'shirt'];

  constructor(private categoryService: CategoryService) {
    addIcons({ add, create, trash });
  }

  async ngOnInit() {
    await this.loadData();
  }

  async loadData() {
    this.categories = await this.categoryService.getAll();
  }

  openModal(category?: Category) {
    if (category) {
      this.editingCategory = category;
      this.formData = {
        name: category.name,
        type: category.type,
        color: category.color,
        icon: category.icon
      };
    } else {
      this.editingCategory = null;
      this.formData = {
        name: '',
        type: 'income',
        color: '#3880ff',
        icon: 'cash'
      };
    }
    this.isModalOpen = true;
  }

  closeModal() {
    this.isModalOpen = false;
    this.editingCategory = null;
  }

  async save() {
    if (!this.formData.name) {
      return;
    }

    if (this.editingCategory) {
      await this.categoryService.update(this.editingCategory.id, this.formData);
    } else {
      await this.categoryService.create(this.formData);
    }

    await this.loadData();
    this.closeModal();
  }

  async delete(id: string) {
    if (confirm('¿Estás seguro de eliminar esta categoría?')) {
      await this.categoryService.delete(id);
      await this.loadData();
    }
  }

  getTypeLabel(type: string): string {
    return type === 'income' ? 'Ingreso' : 'Egreso';
  }
}

