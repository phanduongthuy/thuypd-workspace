#!/usr/bin/env node
import { spawn } from 'node:child_process';
import readline from 'node:readline';
import process from 'node:process';

const services = [
  {
    name: 'API',
    dir: 'api.thuypd.site',
    cmd: 'npm',
    args: ['run', 'dev'],
    color: '\x1b[36m', // Cyan
    port: 'http://localhost:5001',
  },
  {
    name: 'CLIENT',
    dir: 'thuypd.site',
    cmd: 'npm',
    args: ['run', 'dev'],
    color: '\x1b[32m', // Green
    port: 'http://localhost:3000',
  },
  {
    name: 'ADMIN',
    dir: 'admin.thuypd.site',
    cmd: 'npm',
    args: ['run', 'dev'],
    color: '\x1b[35m', // Magenta
    port: 'http://localhost:3002',
  },
];

const RESET = '\x1b[0m';
const BOLD = '\x1b[1m';
const children = [];

console.log(`${BOLD}============================================================${RESET}`);
console.log(`${BOLD}🚀 Khởi chạy THUYPD.SITE Ecosystem Local Dev Services${RESET}`);
console.log(`${BOLD}============================================================${RESET}`);
for (const svc of services) {
  console.log(`  ${svc.color}[${svc.name}]${RESET} Directory: ${svc.dir} -> ${svc.port}`);
}
console.log(`${BOLD}============================================================${RESET}\n`);

function pipeOutput(stream, prefix, color) {
  if (!stream) return;
  const rl = readline.createInterface({ input: stream });
  rl.on('line', (line) => {
    console.log(`${color}${prefix}${RESET} ${line}`);
  });
}

for (const svc of services) {
  const child = spawn(svc.cmd, svc.args, {
    cwd: svc.dir,
    env: { ...process.env, FORCE_COLOR: '1' },
    stdio: ['inherit', 'pipe', 'pipe'],
    shell: process.platform === 'win32',
  });

  children.push({ svc, child });

  pipeOutput(child.stdout, `[${svc.name}]`, svc.color);
  pipeOutput(child.stderr, `[${svc.name}:ERR]`, '\x1b[31m');

  child.on('close', (code) => {
    if (code !== 0 && code !== null) {
      console.log(`${svc.color}[${svc.name}]${RESET} process exited with code ${code}`);
    }
  });
}

function cleanup() {
  console.log(`\n${BOLD}🛑 Đang dừng toàn bộ services...${RESET}`);
  for (const { child } of children) {
    try {
      if (process.platform === 'win32') {
        spawn('taskkill', ['/pid', child.pid.toString(), '/f', '/t']);
      } else {
        child.kill('SIGTERM');
      }
    } catch {
      // Ignore cleanup error
    }
  }
  process.exit(0);
}

process.on('SIGINT', cleanup);
process.on('SIGTERM', cleanup);
