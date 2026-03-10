import os from 'os';
import path from 'path';
import { DOTFILES_ROOT, exec, log } from '../lib/utils.ts';
import type { Package } from '../lib/utils.ts';
import { installPackages } from '../lib/packages.ts';
import { symlinkAll, promptSymlinks } from '../lib/symlink.ts';
import { confirm } from '../lib/prompt.ts';

const HOME = os.homedir();

export const SYSTEM_PACKAGES: Package[] = [
  { name: 'code', source: 'pacman', description: 'Visual Studio Code' },
];

export const SYMLINKS = [
  {
    src:  path.join(DOTFILES_ROOT, 'vscode/settings.json'),
    dest: path.join(HOME, '.config/Code/User/settings.json'),
  },
  {
    src:  path.join(DOTFILES_ROOT, 'vscode/keybindings.json'),
    dest: path.join(HOME, '.config/Code/User/keybindings.json'),
  },
];

const EXTENSIONS = [
  { id: 'dbaeumer.vscode-eslint',          description: 'ESLint integration' },
  { id: 'eamodio.gitlens',                 description: 'Git blame, history, and more' },
  { id: 'GitHub.github-vscode-theme',      description: 'GitHub color theme' },
  { id: 'esbenp.prettier-vscode',          description: 'Prettier code formatter' },
  { id: 'k--kato.intellij-idea-keybindings', description: 'IntelliJ IDEA keybindings' },
  { id: 'ms-python.python',               description: 'Python language support' },
  { id: 'ms-python.vscode-pylance',        description: 'Python type checking and IntelliSense' },
  { id: 'PKief.material-icon-theme',       description: 'Material Design file icons' },
];

async function promptExtensions(): Promise<void> {
  const DIM = '\x1b[2m';
  const RESET = '\x1b[0m';

  console.log('\nExtensions to install:\n');
  for (const ext of EXTENSIONS) {
    console.log(`  ${ext.id}  ${DIM}${ext.description}${RESET}`);
  }
  console.log();

  const yes = await confirm('Install extensions?');
  if (!yes) return;

  for (const ext of EXTENSIONS) {
    log.info(`Installing ${ext.id}...`);
    await exec('code', ['--install-extension', ext.id]);
  }
  log.ok('Extensions installed.');
}

export async function runVscode(): Promise<void> {
  log.info('Installing VSCode...');
  await installPackages({ system: SYSTEM_PACKAGES, pip: [] });

  await symlinkAll(await promptSymlinks(SYMLINKS));

  await promptExtensions();

  log.ok('VSCode setup complete.');
}
