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
  IonDatetimeButton,
  IonDatetime,
  IonButtons,
  IonBackButton
} from '@ionic/angular/standalone';
import { add, create, trash, calendar } from 'ionicons/icons';
import { addIcons } from 'ionicons';
import { IncomeService } from '../../services/offline/income.service';
import { CategoryService } from '../../services/offline/category.service';
import { Income } from '../../models/income.model';
import { Category } from '../../models/category.model';

@Component({
  selector: 'app-incomes',
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
    IonDatetimeButton,
    IonDatetime,
    IonButtons,
    IonBackButton
  ],
  templateUrl: './incomes.component.html',
  styleUrl: './incomes.component.css'
})
export class IncomesComponent implements OnInit {
  incomes: Income[] = [];
  categories: Category[] = [];
  isModalOpen = false;
  editingIncome: Income | null = null;
  
  formData = {
    amount: 0,
    description: '',
    categoryId: '',
    date: new Date().toISOString()
  };

  constructor(
    private incomeService: IncomeService,
    private categoryService: CategoryService
  ) {
    addIcons({ add, create, trash, calendar });
  }

  async ngOnInit() {
    await this.loadData();
  }

  async loadData() {
    this.incomes = await this.incomeService.getAll();
    this.categories = await this.categoryService.getByType('income');
  }

  openModal(income?: Income) {
    if (income) {
      this.editingIncome = income;
      this.formData = {
        amount: income.amount,
        description: income.description,
        categoryId: income.categoryId,
        date: income.date.toISOString()
      };
    } else {
      this.editingIncome = null;
      this.formData = {
        amount: 0,
        description: '',
        categoryId: '',
        date: new Date().toISOString()
      };
    }
    this.isModalOpen = true;
  }

  closeModal() {
    this.isModalOpen = false;
    this.editingIncome = null;
  }

  async save() {
    if (!this.formData.description || !this.formData.categoryId || this.formData.amount <= 0) {
      return;
    }

    if (this.editingIncome) {
      await this.incomeService.update(this.editingIncome.id, {
        amount: this.formData.amount,
        description: this.formData.description,
        categoryId: this.formData.categoryId,
        date: new Date(this.formData.date)
      });
    } else {
      await this.incomeService.create({
        amount: this.formData.amount,
        description: this.formData.description,
        categoryId: this.formData.categoryId,
        date: new Date(this.formData.date)
      });
    }

    await this.loadData();
    this.closeModal();
  }

  async delete(id: string) {
    if (confirm('¿Estás seguro de eliminar este ingreso?')) {
      await this.incomeService.delete(id);
      await this.loadData();
    }
  }

  formatDate(date: Date): string {
    return new Date(date).toLocaleDateString('es-ES');
  }

  formatCurrency(amount: number): string {
    return new Intl.NumberFormat('es-ES', {
      style: 'currency',
      currency: 'EUR'
    }).format(amount);
  }
}

