import { Injectable } from '@angular/core';
import { StorageService } from './storage.service';
import { Income } from '../../models/income.model';
import { CategoryService } from './category.service';

@Injectable({
  providedIn: 'root'
})
export class IncomeService {
  private readonly STORAGE_KEY = 'incomes';

  constructor(
    private storage: StorageService,
    private categoryService: CategoryService
  ) {}

  async getAll(): Promise<Income[]> {
    const incomes = await this.storage.get<Income[]>(this.STORAGE_KEY);
    const categories = await this.categoryService.getAll();
    
    return (incomes || []).map(income => ({
      ...income,
      date: new Date(income.date),
      createdAt: new Date(income.createdAt),
      categoryName: categories.find(c => c.id === income.categoryId)?.name
    }));
  }

  async getById(id: string): Promise<Income | null> {
    const incomes = await this.getAll();
    return incomes.find(i => i.id === id) || null;
  }

  async getByDateRange(startDate: Date, endDate: Date): Promise<Income[]> {
    const incomes = await this.getAll();
    return incomes.filter(i => i.date >= startDate && i.date <= endDate);
  }

  async create(income: Omit<Income, 'id' | 'createdAt' | 'categoryName'>): Promise<Income> {
    const incomes = await this.getAll();
    const newIncome: Income = {
      ...income,
      id: this.generateId(),
      createdAt: new Date()
    };
    incomes.push(newIncome);
    await this.storage.set(this.STORAGE_KEY, incomes);
    return (await this.getById(newIncome.id))!;
  }

  async update(id: string, updates: Partial<Income>): Promise<Income | null> {
    const incomes = await this.storage.get<Income[]>(this.STORAGE_KEY) || [];
    const index = incomes.findIndex(i => i.id === id);
    if (index === -1) return null;
    
    incomes[index] = { ...incomes[index], ...updates };
    await this.storage.set(this.STORAGE_KEY, incomes);
    return (await this.getById(id));
  }

  async delete(id: string): Promise<boolean> {
    const incomes = await this.storage.get<Income[]>(this.STORAGE_KEY) || [];
    const filtered = incomes.filter(i => i.id !== id);
    if (filtered.length === incomes.length) return false;
    
    await this.storage.set(this.STORAGE_KEY, filtered);
    return true;
  }

  async getTotal(): Promise<number> {
    const incomes = await this.getAll();
    return incomes.reduce((sum, income) => sum + income.amount, 0);
  }

  private generateId(): string {
    return Date.now().toString(36) + Math.random().toString(36).substr(2);
  }
}

