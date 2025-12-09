import { Injectable } from '@angular/core';
import { StorageService } from './storage.service';
import { Expense } from '../../models/expense.model';
import { CategoryService } from './category.service';

@Injectable({
  providedIn: 'root'
})
export class ExpenseService {
  private readonly STORAGE_KEY = 'expenses';

  constructor(
    private storage: StorageService,
    private categoryService: CategoryService
  ) {}

  async getAll(): Promise<Expense[]> {
    const expenses = await this.storage.get<Expense[]>(this.STORAGE_KEY);
    const categories = await this.categoryService.getAll();
    
    return (expenses || []).map(expense => ({
      ...expense,
      date: new Date(expense.date),
      createdAt: new Date(expense.createdAt),
      categoryName: categories.find(c => c.id === expense.categoryId)?.name
    }));
  }

  async getById(id: string): Promise<Expense | null> {
    const expenses = await this.getAll();
    return expenses.find(e => e.id === id) || null;
  }

  async getByDateRange(startDate: Date, endDate: Date): Promise<Expense[]> {
    const expenses = await this.getAll();
    return expenses.filter(e => e.date >= startDate && e.date <= endDate);
  }

  async getByCategory(categoryId: string): Promise<Expense[]> {
    const expenses = await this.getAll();
    return expenses.filter(e => e.categoryId === categoryId);
  }

  async create(expense: Omit<Expense, 'id' | 'createdAt' | 'categoryName'>): Promise<Expense> {
    const expenses = await this.storage.get<Expense[]>(this.STORAGE_KEY) || [];
    const newExpense: Expense = {
      ...expense,
      id: this.generateId(),
      createdAt: new Date()
    };
    expenses.push(newExpense);
    await this.storage.set(this.STORAGE_KEY, expenses);
    return (await this.getById(newExpense.id))!;
  }

  async update(id: string, updates: Partial<Expense>): Promise<Expense | null> {
    const expenses = await this.storage.get<Expense[]>(this.STORAGE_KEY) || [];
    const index = expenses.findIndex(e => e.id === id);
    if (index === -1) return null;
    
    expenses[index] = { ...expenses[index], ...updates };
    await this.storage.set(this.STORAGE_KEY, expenses);
    return (await this.getById(id));
  }

  async delete(id: string): Promise<boolean> {
    const expenses = await this.storage.get<Expense[]>(this.STORAGE_KEY) || [];
    const filtered = expenses.filter(e => e.id !== id);
    if (filtered.length === expenses.length) return false;
    
    await this.storage.set(this.STORAGE_KEY, filtered);
    return true;
  }

  async getTotal(): Promise<number> {
    const expenses = await this.getAll();
    return expenses.reduce((sum, expense) => sum + expense.amount, 0);
  }

  private generateId(): string {
    return Date.now().toString(36) + Math.random().toString(36).substr(2);
  }
}

