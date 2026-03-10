import os from 'os';
import path from 'path';
import { DOTFILES_ROOT, log } from '../lib/utils.ts';
import type { Package } from '../lib/utils.ts';
import { installPackages } from '../lib/packages.ts';
import { symlinkAll, promptSymlinks } from '../lib/symlink.ts';

const HOME = os.homedir();

export const SYSTEM_PACKAGES: Package[] = [
  { name: 'dunst', source: 'pacman', description: 'Notification daemon' },
];

export const SYMLINKS = [
  {
    src:  path.join(DOTFILES_ROOT, 'dunst'),
    dest: path.join(HOME, '.config/dunst'),
  },
];

export async function runDunst(): Promise<void> {
  await installPackages({ system: SYSTEM_PACKAGES, pip: [] });
  await symlinkAll(await promptSymlinks(SYMLINKS));
  log.ok('dunst setup complete.');
}
