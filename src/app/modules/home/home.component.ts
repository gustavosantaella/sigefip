import { Component, OnInit } from "@angular/core";
import { CommonModule } from "@angular/common";
import { RouterLink } from "@angular/router";
import { Capacitor } from "@capacitor/core";
import {
  IonHeader,
  IonToolbar,
  IonTitle,
  IonContent,
  IonCard,
  IonCardHeader,
  IonCardTitle,
  IonCardContent,
  IonItem,
  IonLabel,
  IonList,
  IonIcon,
  IonGrid,
  IonRow,
  IonCol,
} from "@ionic/angular/standalone";
import {
  wallet,
  trendingUp,
  trendingDown,
  people,
  card,
  cash,
  addCircle,
  list,
} from "ionicons/icons";
import { addIcons } from "ionicons";
import { IncomeService } from "../../services/offline/income.service";
import { ExpenseService } from "../../services/offline/expense.service";
import { AccountReceivableService } from "../../services/offline/account-receivable.service";
import { AccountPayableService } from "../../services/offline/account-payable.service";
import { DebtService } from "../../services/offline/debt.service";

@Component({
  selector: "app-home",
  standalone: true,
  imports: [
    CommonModule,
    RouterLink,
    IonHeader,
    IonToolbar,
    IonTitle,
    IonContent,
    IonCard,
    IonCardHeader,
    IonCardTitle,
    IonCardContent,
    IonItem,
    IonLabel,
    IonList,
    IonIcon,
    IonGrid,
    IonRow,
    IonCol,
  ],
  templateUrl: "./home.component.html",
  styleUrl: "./home.component.css",
})
export class HomeComponent implements OnInit {
  platform = "web";
  isNative = false;

  totalIncome = 0;
  totalExpense = 0;
  totalReceivable = 0;
  totalPayable = 0;
  totalDebt = 0;

  balance = 0;

  constructor(
    private incomeService: IncomeService,
    private expenseService: ExpenseService,
    private receivableService: AccountReceivableService,
    private payableService: AccountPayableService,
    private debtService: DebtService
  ) {
    this.platform = Capacitor.getPlatform();
    this.isNative = Capacitor.isNativePlatform();
    addIcons({
      wallet,
      trendingUp,
      trendingDown,
      people,
      card,
      cash,
      addCircle,
      list,
    });
  }

  async ngOnInit() {
    await this.loadDashboard();
  }

  async loadDashboard() {
    this.totalIncome = await this.incomeService.getTotal();
    this.totalExpense = await this.expenseService.getTotal();
    this.totalReceivable = await this.receivableService.getTotal();
    this.totalPayable = await this.payableService.getTotal();
    this.totalDebt = await this.debtService.getTotal();

    this.balance = this.totalIncome - this.totalExpense;
  }
}
