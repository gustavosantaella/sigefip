import { CapacitorConfig } from "@capacitor/cli";

const config: CapacitorConfig = {
  appId: "com.sigefip.app",
  appName: "sigefip",
  webDir: "dist/sigefip/browser",
  server: {
    androidScheme: "https",
  },
};

export default config;
