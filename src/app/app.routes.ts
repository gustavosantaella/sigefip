import { Routes } from "@angular/router";
import { appRoutes } from "./routes/app.routes";

export const routes: Routes = [
  // Ruta principal - usa las rutas de la aplicación
  ...appRoutes,
  // Ruta de desarrollo - reutiliza las mismas rutas como children
  {
    path: "dev-preview",
    loadComponent: () =>
      import("./components/dev-preview/dev-preview.component").then(
        (m) => m.DevPreviewComponent
      ),
    children: appRoutes, // Reutiliza las mismas rutas
  },
];
