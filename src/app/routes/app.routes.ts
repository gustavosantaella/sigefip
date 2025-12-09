import { Routes } from "@angular/router";

/**
 * Rutas principales de la aplicación
 * Estas rutas se reutilizan tanto en la versión nativa como en dev-preview
 */
export const appRoutes: Routes = [
  {
    path: "",
    loadComponent: () =>
      import("../modules/home/home.component").then((m) => m.HomeComponent),
  },
  {
    path: "incomes",
    loadComponent: () =>
      import("../modules/incomes/incomes.component").then(
        (m) => m.IncomesComponent
      ),
  },
  {
    path: "expenses",
    loadComponent: () =>
      import("../modules/expenses/expenses.component").then(
        (m) => m.ExpensesComponent
      ),
  },
  {
    path: "categories",
    loadComponent: () =>
      import("../modules/categories/categories.component").then(
        (m) => m.CategoriesComponent
      ),
  },
  {
    path: "accounts-receivable",
    loadComponent: () =>
      import(
        "../modules/accounts-receivable/accounts-receivable.component"
      ).then((m) => m.AccountsReceivableComponent),
  },
  {
    path: "accounts-payable",
    loadComponent: () =>
      import("../modules/accounts-payable/accounts-payable.component").then(
        (m) => m.AccountsPayableComponent
      ),
  },
  {
    path: "debts",
    loadComponent: () =>
      import("../modules/debts/debts.component").then((m) => m.DebtsComponent),
  },
];
