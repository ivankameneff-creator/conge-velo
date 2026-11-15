const fs = require('fs');
const path = require('path');

const rootDir = path.resolve(__dirname, '..');
const wwwDir = path.join(rootDir, 'www');
const androidAssetsDir = path.join(rootDir, 'android', 'app', 'src', 'main', 'assets');
const androidPublicDir = path.join(androidAssetsDir, 'public');

// 1. Créer les dossiers cibles
[wwwDir, androidAssetsDir, androidPublicDir].forEach(dir => {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
});

// 2. Déterminer la configuration Supabase
const cfgPath = path.join(rootDir, 'supabase-config.js');
const samplePath = path.join(rootDir, 'supabase-config.sample.js');
let supabaseConfigContent = 'window.ZENLEAVE_SUPABASE_CONFIG = {};\n';

if (fs.existsSync(cfgPath)) {
  supabaseConfigContent = fs.readFileSync(cfgPath, 'utf8');
} else if (fs.existsSync(samplePath)) {
  supabaseConfigContent = fs.readFileSync(samplePath, 'utf8');
}

// 3. Copier index.html et supabase-config.js dans www/
const indexContent = fs.readFileSync(path.join(rootDir, 'index.html'), 'utf8');
fs.writeFileSync(path.join(wwwDir, 'index.html'), indexContent);
fs.writeFileSync(path.join(wwwDir, 'supabase-config.js'), supabaseConfigContent);

// 4. Copier directement dans android/app/src/main/assets/public/
fs.writeFileSync(path.join(androidPublicDir, 'index.html'), indexContent);
fs.writeFileSync(path.join(androidPublicDir, 'supabase-config.js'), supabaseConfigContent);
fs.writeFileSync(path.join(androidPublicDir, 'cordova.js'), '');
fs.writeFileSync(path.join(androidPublicDir, 'cordova_plugins.js'), '');

// 5. Générer capacitor.config.json dans les assets Android
const capConfig = {
  appId: "fr.zenleave.congevelo",
  appName: "Congés & Vélo",
  webDir: "www",
  server: {
    androidScheme: "https"
  }
};
fs.writeFileSync(
  path.join(androidAssetsDir, 'capacitor.config.json'),
  JSON.stringify(capConfig, null, 2) + '\n'
);

// 6. Générer capacitor.plugins.json dans les assets Android
const capPlugins = [
  {
    pkg: "@capacitor/app",
    classpath: "com.capacitorjs.plugins.app.AppPlugin"
  }
];
fs.writeFileSync(
  path.join(androidAssetsDir, 'capacitor.plugins.json'),
  JSON.stringify(capPlugins, null, 2) + '\n'
);

console.log('✅ Assets mobiles synchronisés avec succès dans www/ et android/app/src/main/assets/public/ !');
