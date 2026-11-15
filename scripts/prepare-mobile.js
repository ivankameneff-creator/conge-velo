const fs = require('fs');
const path = require('path');

const rootDir = path.resolve(__dirname, '..');
const wwwDir = path.join(rootDir, 'www');

if (!fs.existsSync(wwwDir)) {
  fs.mkdirSync(wwwDir, { recursive: true });
}

fs.copyFileSync(path.join(rootDir, 'index.html'), path.join(wwwDir, 'index.html'));

const cfgPath = path.join(rootDir, 'supabase-config.js');
const samplePath = path.join(rootDir, 'supabase-config.sample.js');
const targetCfg = path.join(wwwDir, 'supabase-config.js');

if (fs.existsSync(cfgPath)) {
  fs.copyFileSync(cfgPath, targetCfg);
} else if (fs.existsSync(samplePath)) {
  fs.copyFileSync(samplePath, targetCfg);
} else {
  fs.writeFileSync(targetCfg, 'window.ZENLEAVE_SUPABASE_CONFIG = {};\n');
}

console.log('Mobile assets successfully prepared in www/');
