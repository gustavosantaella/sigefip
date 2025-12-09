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
  // Aquí puedes agregar más rutas de tu aplicación
  // {
  //   path: "otra-ruta",
  //   loadComponent: () => import("../modules/otra-ruta/otra-ruta.component").then((m) => m.OtraRutaComponent),
  // },
];

