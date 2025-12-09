import { Injectable } from '@angular/core';
import { StorageService } from './storage.service';
import { Category } from '../../models/category.model';

@Injectable({
  providedIn: 'root'
})
export class CategoryService {
  private readonly STORAGE_KEY = 'categories';

  constructor(private storage: StorageService) {}

  async getAll(): Promise<Category[]> {
    const categories = await this.storage.get<Category[]>(this.STORAGE_KEY);
    return categories || [];
  }

  async getById(id: string): Promise<Category | null> {
    const categories = await this.getAll();
    return categories.find(c => c.id === id) || null;
  }

  async getByType(type: 'income' | 'expense'): Promise<Category[]> {
    const categories = await this.getAll();
    return categories.filter(c => c.type === type);
  }

  async create(category: Omit<Category, 'id' | 'createdAt'>): Promise<Category> {
    const categories = await this.getAll();
    const newCategory: Category = {
      ...category,
      id: this.generateId(),
      createdAt: new Date()
    };
    categories.push(newCategory);
    await this.storage.set(this.STORAGE_KEY, categories);
    return newCategory;
  }

  async update(id: string, updates: Partial<Category>): Promise<Category | null> {
    const categories = await this.getAll();
    const index = categories.findIndex(c => c.id === id);
    if (index === -1) return null;
    
    categories[index] = { ...categories[index], ...updates };
    await this.storage.set(this.STORAGE_KEY, categories);
    return categories[index];
  }

  async delete(id: string): Promise<boolean> {
    const categories = await this.getAll();
    const filtered = categories.filter(c => c.id !== id);
    if (filtered.length === categories.length) return false;
    
    await this.storage.set(this.STORAGE_KEY, filtered);
    return true;
  }

  private generateId(): string {
    return Date.now().toString(36) + Math.random().toString(36).substr(2);
  }
}

