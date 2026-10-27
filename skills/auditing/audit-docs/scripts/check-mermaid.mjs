// Parse every ```mermaid block in the given markdown files and report the ones that do not parse.
//
// Usage:  node check-mermaid.mjs <file.md> [file.md ...]
//   e.g.  node check-mermaid.mjs $(grep -rl '```mermaid' etc/docs --include='*.md')
//
// One-time setup (Node 18+), outside the repo:
//   mkdir -p /tmp/mmd-check && cd /tmp/mmd-check && npm init -y && npm i mermaid jsdom
// Override the install location with MMD_DIR=/path/to/dir.
//
// Prints "<file>:<first line of block>  <error>" per failing block; exit code 1 if any.
// Typical causes: a ';' inside a sequence-diagram message or note (it ends the statement),
// unquoted '(' inside a flowchart node label, or an unbalanced rect/alt/end.
import fs from 'node:fs';
import path from 'node:path';
import { pathToFileURL } from 'node:url';

const dir = process.env.MMD_DIR || '/tmp/mmd-check';
const load = (rel) => import(pathToFileURL(path.join(dir, 'node_modules', rel)).href);

let mermaid;
try {
  // The fake DOM must exist BEFORE mermaid is imported, or DOMPurify fails to initialise.
  const { JSDOM } = await load('jsdom/lib/api.js');
  const dom = new JSDOM('<!DOCTYPE html><body></body>');
  globalThis.window = dom.window;
  globalThis.document = dom.window.document;
  mermaid = (await load('mermaid/dist/mermaid.core.mjs')).default;
} catch (e) {
  console.error(`Cannot load mermaid/jsdom from ${dir}. Run the one-time setup in this file's header.`);
  process.exit(2);
}

let failures = 0;
let blocks = 0;
for (const file of process.argv.slice(2)) {
  const text = fs.readFileSync(file, 'utf8');
  for (const m of text.matchAll(/```mermaid\n([\s\S]*?)```/g)) {
    blocks++;
    const startLine = text.slice(0, m.index).split('\n').length + 1;
    try {
      await mermaid.parse(m[1]);
    } catch (e) {
      failures++;
      const msg = String(e.message || e).split('\n').slice(0, 3).join(' | ');
      console.log(`${file}:${startLine}  ${msg}`);
    }
  }
}
console.error(`mermaid blocks: ${blocks}, failing: ${failures}`);
process.exit(failures ? 1 : 0);
