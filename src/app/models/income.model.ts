export interface Income {
  id: string;
  amount: number;
  description: string;
  categoryId: string;
  categoryName?: string;
  date: Date;
  createdAt: Date;
}

