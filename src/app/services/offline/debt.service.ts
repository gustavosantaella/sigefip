import { Injectable } from '@angular/core';
import { StorageService } from './storage.service';
import { Debt } from '../../models/debt.model';

@Injectable({
  providedIn: 'root'
})
export class DebtService {
  private readonly STORAGE_KEY = 'debts';

  constructor(private storage: StorageService) {}

  async getAll(): Promise<Debt[]> {
    const debts = await this.storage.get<Debt[]>(this.STORAGE_KEY);
    return (debts || []).map(debt => ({
      ...debt,
      startDate: new Date(debt.startDate),
      dueDate: debt.dueDate ? new Date(debt.dueDate) : undefined,
      createdAt: new Date(debt.createdAt),
      status: this.calculateStatus(debt.totalAmount, debt.paidAmount, debt.dueDate)
    }));
  }

  async getById(id: string): Promise<Debt | null> {
    const debts = await this.getAll();
    return debts.find(d => d.id === id) || null;
  }

  async getByStatus(status: 'active' | 'paid' | 'overdue'): Promise<Debt[]> {
    const debts = await this.getAll();
    return debts.filter(d => d.status === status);
  }

  async create(debt: Omit<Debt, 'id' | 'createdAt' | 'status'>): Promise<Debt> {
    const debts = await this.storage.get<Debt[]>(this.STORAGE_KEY) || [];
    const newDebt: Debt = {
      ...debt,
      id: this.generateId(),
      createdAt: new Date(),
      status: this.calculateStatus(debt.totalAmount, debt.paidAmount, debt.dueDate)
    };
    debts.push(newDebt);
    await this.storage.set(this.STORAGE_KEY, debts);
    return (await this.getById(newDebt.id))!;
  }

  async update(id: string, updates: Partial<Debt>): Promise<Debt | null> {
    const debts = await this.storage.get<Debt[]>(this.STORAGE_KEY) || [];
    const index = debts.findIndex(d => d.id === id);
    if (index === -1) return null;
    
    const updated = { ...debts[index], ...updates };
    updated.status = this.calculateStatus(
      updated.totalAmount,
      updated.paidAmount,
      updated.dueDate
    );
    debts[index] = updated;
    await this.storage.set(this.STORAGE_KEY, debts);
    return (await this.getById(id));
  }

  async addPayment(id: string, amount: number): Promise<Debt | null> {
    const debt = await this.getById(id);
    if (!debt) return null;
    
    const newPaidAmount = Math.min(debt.paidAmount + amount, debt.totalAmount);
    return this.update(id, { paidAmount: newPaidAmount });
  }

  async delete(id: string): Promise<boolean> {
    const debts = await this.storage.get<Debt[]>(this.STORAGE_KEY) || [];
    const filtered = debts.filter(d => d.id !== id);
    if (filtered.length === debts.length) return false;
    
    await this.storage.set(this.STORAGE_KEY, filtered);
    return true;
  }

  async getTotal(): Promise<number> {
    const debts = await this.getAll();
    return debts.reduce((sum, debt) => sum + (debt.totalAmount - debt.paidAmount), 0);
  }

  private calculateStatus(
    totalAmount: number,
    paidAmount: number,
    dueDate?: Date
  ): 'active' | 'paid' | 'overdue' {
    if (paidAmount >= totalAmount) return 'paid';
    if (dueDate && new Date() > dueDate) return 'overdue';
    return 'active';
  }

  private generateId(): string {
    return Date.now().toString(36) + Math.random().toString(36).substr(2);
  }
}

