export interface AccountPayable {
  id: string;
  creditor: string;
  amount: number;
  paidAmount: number;
  description: string;
  dueDate: Date;
  createdAt: Date;
  status: 'pending' | 'partial' | 'paid';
}

