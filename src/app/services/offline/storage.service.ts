import { Injectable } from '@angular/core';
import { Preferences } from '@capacitor/preferences';

@Injectable({
  providedIn: 'root'
})
export class StorageService {
  private readonly PREFIX = 'sigefip_';

  /**
   * Saves a value to local storage
   */
  async set(key: string, value: any): Promise<void> {
    const jsonValue = JSON.stringify(value);
    await Preferences.set({
      key: this.PREFIX + key,
      value: jsonValue
    });
  }

  /**
   * Gets a value from local storage
   */
  async get<T>(key: string): Promise<T | null> {
    const { value } = await Preferences.get({ key: this.PREFIX + key });
    if (value === null) {
      return null;
    }
    return JSON.parse(value) as T;
  }

  /**
   * Removes a value from local storage
   */
  async remove(key: string): Promise<void> {
    await Preferences.remove({ key: this.PREFIX + key });
  }

  /**
   * Gets all stored keys
   */
  async keys(): Promise<string[]> {
    const { keys } = await Preferences.keys();
    return keys
      .filter(key => key.startsWith(this.PREFIX))
      .map(key => key.replace(this.PREFIX, ''));
  }

  /**
   * Clears all storage
   */
  async clear(): Promise<void> {
    const keys = await this.keys();
    for (const key of keys) {
      await this.remove(key);
    }
  }
}

