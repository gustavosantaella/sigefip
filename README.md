# Sigefip - Aplicación Angular con Capacitor e Ionic

Aplicación Angular 17 con Capacitor 5 e Ionic 7 configurada y lista para desarrollo móvil.

## 🚀 Características

- Angular 17 con Standalone Components
- Ionic 7 integrado con componentes UI nativos
- Capacitor 5 integrado
- Configuración lista para Android/iOS
- Diseño responsive y moderno
- Iconos con Ionicons

## 📋 Prerrequisitos

- Node.js (v18 o superior)
- npm o yarn
- Android Studio (para desarrollo Android)
- Xcode (para desarrollo iOS - solo macOS)

## 🛠️ Instalación

1. Instalar dependencias:
```bash
npm install
```

## 🏃 Desarrollo

Ejecutar la aplicación en modo desarrollo:
```bash
npm start
```

La aplicación estará disponible en `http://localhost:4200`

## 📱 Capacitor

### Agregar plataforma

Para agregar Android:
```bash
npm run cap:add android
```

Para agregar iOS:
```bash
npm run cap:add ios
```

### Sincronizar cambios

Después de hacer cambios, sincronizar con Capacitor:
```bash
npm run cap:sync
```

### Abrir en IDE nativo

Para abrir en Android Studio:
```bash
npm run cap:open android
```

Para abrir en Xcode:
```bash
npm run cap:open ios
```

### Ejecutar en dispositivo/emulador

```bash
npm run cap:run android
npm run cap:run ios
```

## 🏗️ Build

Para producción:
```bash
npm run build
```

## 📁 Estructura del Proyecto

```
sigefip/
├── src/
│   ├── app/
│   │   ├── app.component.ts
│   │   ├── app.routes.ts
│   │   └── home/
│   │       └── home.component.ts
│   ├── assets/
│   ├── index.html
│   ├── main.ts
│   └── styles.css
├── angular.json
├── capacitor.config.ts
└── package.json
```

## 📝 Notas

- Asegúrate de ejecutar `npm run cap:sync` después de cada build antes de probar en dispositivos nativos
- El `webDir` en `capacitor.config.ts` apunta a `dist/sigefip/browser` (Angular 17 genera los archivos en el subdirectorio browser)
- La aplicación usa Ionic 7 con componentes standalone
- Los iconos se cargan usando `addIcons()` de ionicons

## 🎨 Componentes Ionic

La aplicación incluye ejemplos de componentes Ionic:
- `ion-header` y `ion-toolbar` para la barra superior
- `ion-content` para el contenido principal
- `ion-card` para tarjetas
- `ion-list` e `ion-item` para listas
- `ion-icon` para iconos

Puedes encontrar más componentes en la [documentación de Ionic](https://ionicframework.com/docs/components).

