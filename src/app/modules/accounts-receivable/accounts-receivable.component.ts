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
import { AccountReceivableService } from '../../services/offline/account-receivable.service';
import { AccountReceivable } from '../../models/account-receivable.model';

@Component({
  selector: 'app-accounts-receivable',
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
  templateUrl: './accounts-receivable.component.html',
  styleUrl: './accounts-receivable.component.css'
})
export class AccountsReceivableComponent implements OnInit {
  accounts: AccountReceivable[] = [];
  isModalOpen = false;
  isPaymentModalOpen = false;
  editingAccount: AccountReceivable | null = null;
  selectedAccount: AccountReceivable | null = null;
  
  formData = {
    debtor: '',
    amount: 0,
    paidAmount: 0,
    description: '',
    dueDate: new Date().toISOString()
  };

  paymentAmount = 0;

  constructor(private accountReceivableService: AccountReceivableService) {
    addIcons({ add, create, trash });
  }

  async ngOnInit() {
    await this.loadData();
  }

  async loadData() {
    this.accounts = await this.accountReceivableService.getAll();
  }

  openModal(account?: AccountReceivable) {
    if (account) {
      this.editingAccount = account;
      this.formData = {
        debtor: account.debtor,
        amount: account.amount,
        paidAmount: account.paidAmount,
        description: account.description,
        dueDate: account.dueDate.toISOString()
      };
    } else {
      this.editingAccount = null;
      this.formData = {
        debtor: '',
        amount: 0,
        paidAmount: 0,
        description: '',
        dueDate: new Date().toISOString()
      };
    }
    this.isModalOpen = true;
  }

  openPaymentModal(account: AccountReceivable) {
    this.selectedAccount = account;
    this.paymentAmount = 0;
    this.isPaymentModalOpen = true;
  }

  closeModal() {
    this.isModalOpen = false;
    this.editingAccount = null;
  }

  closePaymentModal() {
    this.isPaymentModalOpen = false;
    this.selectedAccount = null;
    this.paymentAmount = 0;
  }

  async save() {
    if (!this.formData.debtor || !this.formData.description || this.formData.amount <= 0) {
      return;
    }

    if (this.editingAccount) {
      await this.accountReceivableService.update(this.editingAccount.id, {
        debtor: this.formData.debtor,
        amount: this.formData.amount,
        paidAmount: this.formData.paidAmount,
        description: this.formData.description,
        dueDate: new Date(this.formData.dueDate)
      });
    } else {
      await this.accountReceivableService.create({
        debtor: this.formData.debtor,
        amount: this.formData.amount,
        paidAmount: 0,
        description: this.formData.description,
        dueDate: new Date(this.formData.dueDate)
      });
    }

    await this.loadData();
    this.closeModal();
  }

  async addPayment() {
    if (!this.selectedAccount || this.paymentAmount <= 0) {
      return;
    }

    await this.accountReceivableService.addPayment(this.selectedAccount.id, this.paymentAmount);
    await this.loadData();
    this.closePaymentModal();
  }

  async delete(id: string) {
    if (confirm('¿Estás seguro de eliminar esta cuenta por cobrar?')) {
      await this.accountReceivableService.delete(id);
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
      'pending': 'Pendiente',
      'partial': 'Parcial',
      'paid': 'Pagado'
    };
    return labels[status] || status;
  }

  getStatusColor(status: string): string {
    const colors: { [key: string]: string } = {
      'pending': 'warning',
      'partial': 'primary',
      'paid': 'success'
    };
    return colors[status] || 'medium';
  }

  getRemainingAmount(account: AccountReceivable): number {
    return account.amount - account.paidAmount;
  }
}

