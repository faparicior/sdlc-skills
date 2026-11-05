#!/usr/bin/env node
const fs = require('fs');
const path = require('path');

const rootDir = path.resolve(__dirname, '..');
const pkgPath = path.join(rootDir, 'package.json');
const pkg = JSON.parse(fs.readFileSync(pkgPath, 'utf8'));

// 1. Sync plugin.json
const pluginPath = path.join(rootDir, '.claude-plugin', 'plugin.json');
if (fs.existsSync(pluginPath)) {
  const plugin = JSON.parse(fs.readFileSync(pluginPath, 'utf8'));
  plugin.version = pkg.version;
  fs.writeFileSync(pluginPath, JSON.stringify(plugin, null, 2) + '\n', 'utf8');
  console.log(`Synced version ${pkg.version} to .claude-plugin/plugin.json`);
}

// 2. Sync marketplace.json files
const marketplacePaths = [
  path.join(rootDir, '.claude-plugin', 'marketplace.json'),
  path.join(rootDir, '.agents', 'plugins', 'marketplace.json'),
];

for (const mPath of marketplacePaths) {
  if (fs.existsSync(mPath)) {
    const marketplace = JSON.parse(fs.readFileSync(mPath, 'utf8'));
    marketplace.version = pkg.version;
    if (Array.isArray(marketplace.plugins)) {
      for (const p of marketplace.plugins) {
        if (p.name === 'sdlc-skills') {
          p.version = pkg.version;
        }
      }
    }
    fs.writeFileSync(mPath, JSON.stringify(marketplace, null, 2) + '\n', 'utf8');
    const relative = path.relative(rootDir, mPath);
    console.log(`Synced version ${pkg.version} to ${relative}`);
  }
}
