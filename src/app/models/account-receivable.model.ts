export interface AccountReceivable {
  id: string;
  debtor: string;
  amount: number;
  paidAmount: number;
  description: string;
  dueDate: Date;
  createdAt: Date;
  status: 'pending' | 'partial' | 'paid';
}

