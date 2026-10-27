#!/usr/bin/env node
const fs = require('fs');
const path = require('path');

const rootDir = path.resolve(__dirname, '..');
const pkgPath = path.join(rootDir, 'package.json');
const pluginPath = path.join(rootDir, '.claude-plugin', 'plugin.json');

const pkg = JSON.parse(fs.readFileSync(pkgPath, 'utf8'));

if (fs.existsSync(pluginPath)) {
  const plugin = JSON.parse(fs.readFileSync(pluginPath, 'utf8'));
  plugin.version = pkg.version;
  fs.writeFileSync(pluginPath, JSON.stringify(plugin, null, 2) + '\n', 'utf8');
  console.log(`Synced version ${pkg.version} to .claude-plugin/plugin.json`);
}
