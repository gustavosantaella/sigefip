import { Injectable } from '@angular/core';
import { StorageService } from './storage.service';
import { AccountReceivable } from '../../models/account-receivable.model';

@Injectable({
  providedIn: 'root'
})
export class AccountReceivableService {
  private readonly STORAGE_KEY = 'accounts_receivable';

  constructor(private storage: StorageService) {}

  async getAll(): Promise<AccountReceivable[]> {
    const accounts = await this.storage.get<AccountReceivable[]>(this.STORAGE_KEY);
    return (accounts || []).map(account => ({
      ...account,
      dueDate: new Date(account.dueDate),
      createdAt: new Date(account.createdAt),
      status: this.calculateStatus(account.amount, account.paidAmount)
    }));
  }

  async getById(id: string): Promise<AccountReceivable | null> {
    const accounts = await this.getAll();
    return accounts.find(a => a.id === id) || null;
  }

  async getByStatus(status: 'pending' | 'partial' | 'paid'): Promise<AccountReceivable[]> {
    const accounts = await this.getAll();
    return accounts.filter(a => a.status === status);
  }

  async create(account: Omit<AccountReceivable, 'id' | 'createdAt' | 'status'>): Promise<AccountReceivable> {
    const accounts = await this.storage.get<AccountReceivable[]>(this.STORAGE_KEY) || [];
    const newAccount: AccountReceivable = {
      ...account,
      id: this.generateId(),
      createdAt: new Date(),
      status: this.calculateStatus(account.amount, account.paidAmount)
    };
    accounts.push(newAccount);
    await this.storage.set(this.STORAGE_KEY, accounts);
    return (await this.getById(newAccount.id))!;
  }

  async update(id: string, updates: Partial<AccountReceivable>): Promise<AccountReceivable | null> {
    const accounts = await this.storage.get<AccountReceivable[]>(this.STORAGE_KEY) || [];
    const index = accounts.findIndex(a => a.id === id);
    if (index === -1) return null;
    
    const updated = { ...accounts[index], ...updates };
    updated.status = this.calculateStatus(updated.amount, updated.paidAmount);
    accounts[index] = updated;
    await this.storage.set(this.STORAGE_KEY, accounts);
    return (await this.getById(id));
  }

  async addPayment(id: string, amount: number): Promise<AccountReceivable | null> {
    const account = await this.getById(id);
    if (!account) return null;
    
    const newPaidAmount = Math.min(account.paidAmount + amount, account.amount);
    return this.update(id, { paidAmount: newPaidAmount });
  }

  async delete(id: string): Promise<boolean> {
    const accounts = await this.storage.get<AccountReceivable[]>(this.STORAGE_KEY) || [];
    const filtered = accounts.filter(a => a.id !== id);
    if (filtered.length === accounts.length) return false;
    
    await this.storage.set(this.STORAGE_KEY, filtered);
    return true;
  }

  async getTotal(): Promise<number> {
    const accounts = await this.getAll();
    return accounts.reduce((sum, account) => sum + (account.amount - account.paidAmount), 0);
  }

  private calculateStatus(amount: number, paidAmount: number): 'pending' | 'partial' | 'paid' {
    if (paidAmount === 0) return 'pending';
    if (paidAmount >= amount) return 'paid';
    return 'partial';
  }

  private generateId(): string {
    return Date.now().toString(36) + Math.random().toString(36).substr(2);
  }
}

