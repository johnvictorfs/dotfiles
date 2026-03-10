import os from 'os';
import path from 'path';
import { DOTFILES_ROOT, log } from '../lib/utils.ts';
import type { Package } from '../lib/utils.ts';
import { installPackages } from '../lib/packages.ts';
import { symlinkAll, promptSymlinks } from '../lib/symlink.ts';

const HOME = os.homedir();

export const SYSTEM_PACKAGES: Package[] = [
  { name: 'code', source: 'pacman', description: 'Visual Studio Code' },
];

const SYMLINKS = [
  {
    src:  path.join(DOTFILES_ROOT, 'vscode/settings.json'),
    dest: path.join(HOME, '.config/Code/User/settings.json'),
  },
  {
    src:  path.join(DOTFILES_ROOT, 'vscode/keybindings.json'),
    dest: path.join(HOME, '.config/Code/User/keybindings.json'),
  },
];

export async function runVscode(): Promise<void> {
  log.info('Installing VSCode...');
  await installPackages({ system: SYSTEM_PACKAGES, pip: [] });

  await symlinkAll(await promptSymlinks(SYMLINKS));

  log.ok('VSCode setup complete.');
}
