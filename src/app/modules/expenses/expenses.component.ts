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
import { add, create, trash } from 'ionicons/icons';
import { addIcons } from 'ionicons';
import { ExpenseService } from '../../services/offline/expense.service';
import { CategoryService } from '../../services/offline/category.service';
import { Expense } from '../../models/expense.model';
import { Category } from '../../models/category.model';

@Component({
  selector: 'app-expenses',
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
  templateUrl: './expenses.component.html',
  styleUrl: './expenses.component.css'
})
export class ExpensesComponent implements OnInit {
  expenses: Expense[] = [];
  categories: Category[] = [];
  isModalOpen = false;
  editingExpense: Expense | null = null;
  
  formData = {
    amount: 0,
    description: '',
    categoryId: '',
    date: new Date().toISOString()
  };

  constructor(
    private expenseService: ExpenseService,
    private categoryService: CategoryService
  ) {
    addIcons({ add, create, trash });
  }

  async ngOnInit() {
    await this.loadData();
  }

  async loadData() {
    this.expenses = await this.expenseService.getAll();
    this.categories = await this.categoryService.getByType('expense');
  }

  openModal(expense?: Expense) {
    if (expense) {
      this.editingExpense = expense;
      this.formData = {
        amount: expense.amount,
        description: expense.description,
        categoryId: expense.categoryId,
        date: expense.date.toISOString()
      };
    } else {
      this.editingExpense = null;
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
    this.editingExpense = null;
  }

  async save() {
    if (!this.formData.description || !this.formData.categoryId || this.formData.amount <= 0) {
      return;
    }

    if (this.editingExpense) {
      await this.expenseService.update(this.editingExpense.id, {
        amount: this.formData.amount,
        description: this.formData.description,
        categoryId: this.formData.categoryId,
        date: new Date(this.formData.date)
      });
    } else {
      await this.expenseService.create({
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
    if (confirm('¿Estás seguro de eliminar este egreso?')) {
      await this.expenseService.delete(id);
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

