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
  IonDatetimeButton,
  IonDatetime,
  IonButtons,
  IonBackButton,
  IonBadge
} from '@ionic/angular/standalone';
import { add, create, trash } from 'ionicons/icons';
import { addIcons } from 'ionicons';
import { DebtService } from '../../services/offline/debt.service';
import { Debt } from '../../models/debt.model';

@Component({
  selector: 'app-debts',
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
    IonDatetimeButton,
    IonDatetime,
    IonButtons,
    IonBackButton,
    IonBadge
  ],
  templateUrl: './debts.component.html',
  styleUrl: './debts.component.css'
})
export class DebtsComponent implements OnInit {
  debts: Debt[] = [];
  isModalOpen = false;
  isPaymentModalOpen = false;
  editingDebt: Debt | null = null;
  selectedDebt: Debt | null = null;
  
  formData = {
    name: '',
    totalAmount: 0,
    paidAmount: 0,
    description: '',
    interestRate: 0,
    startDate: new Date().toISOString(),
    dueDate: ''
  };

  paymentAmount = 0;

  constructor(private debtService: DebtService) {
    addIcons({ add, create, trash });
  }

  async ngOnInit() {
    await this.loadData();
  }

  async loadData() {
    this.debts = await this.debtService.getAll();
  }

  openModal(debt?: Debt) {
    if (debt) {
      this.editingDebt = debt;
      this.formData = {
        name: debt.name,
        totalAmount: debt.totalAmount,
        paidAmount: debt.paidAmount,
        description: debt.description,
        interestRate: debt.interestRate || 0,
        startDate: debt.startDate.toISOString(),
        dueDate: debt.dueDate ? debt.dueDate.toISOString() : ''
      };
    } else {
      this.editingDebt = null;
      this.formData = {
        name: '',
        totalAmount: 0,
        paidAmount: 0,
        description: '',
        interestRate: 0,
        startDate: new Date().toISOString(),
        dueDate: ''
      };
    }
    this.isModalOpen = true;
  }

  openPaymentModal(debt: Debt) {
    this.selectedDebt = debt;
    this.paymentAmount = 0;
    this.isPaymentModalOpen = true;
  }

  closeModal() {
    this.isModalOpen = false;
    this.editingDebt = null;
  }

  closePaymentModal() {
    this.isPaymentModalOpen = false;
    this.selectedDebt = null;
    this.paymentAmount = 0;
  }

  async save() {
    if (!this.formData.name || !this.formData.description || this.formData.totalAmount <= 0) {
      return;
    }

    const debtData: any = {
      name: this.formData.name,
      totalAmount: this.formData.totalAmount,
      paidAmount: this.formData.paidAmount,
      description: this.formData.description,
      startDate: new Date(this.formData.startDate)
    };

    if (this.formData.interestRate > 0) {
      debtData.interestRate = this.formData.interestRate;
    }

    if (this.formData.dueDate) {
      debtData.dueDate = new Date(this.formData.dueDate);
    }

    if (this.editingDebt) {
      await this.debtService.update(this.editingDebt.id, debtData);
    } else {
      await this.debtService.create(debtData);
    }

    await this.loadData();
    this.closeModal();
  }

  async addPayment() {
    if (!this.selectedDebt || this.paymentAmount <= 0) {
      return;
    }

    await this.debtService.addPayment(this.selectedDebt.id, this.paymentAmount);
    await this.loadData();
    this.closePaymentModal();
  }

  async delete(id: string) {
    if (confirm('¿Estás seguro de eliminar esta deuda?')) {
      await this.debtService.delete(id);
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

  getStatusLabel(status: string): string {
    const labels: { [key: string]: string } = {
      'active': 'Activa',
      'paid': 'Pagada',
      'overdue': 'Vencida'
    };
    return labels[status] || status;
  }

  getStatusColor(status: string): string {
    const colors: { [key: string]: string } = {
      'active': 'warning',
      'paid': 'success',
      'overdue': 'danger'
    };
    return colors[status] || 'medium';
  }

  getRemainingAmount(debt: Debt): number {
    return debt.totalAmount - debt.paidAmount;
  }
}

