export interface Debt {
  id: string;
  name: string;
  totalAmount: number;
  paidAmount: number;
  description: string;
  interestRate?: number;
  startDate: Date;
  dueDate?: Date;
  createdAt: Date;
  status: 'active' | 'paid' | 'overdue';
}

