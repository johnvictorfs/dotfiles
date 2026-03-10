import os from 'os';
import path from 'path';
import { DOTFILES_ROOT, log } from '../lib/utils.ts';
import type { Package } from '../lib/utils.ts';
import { installPackages } from '../lib/packages.ts';
import { symlinkAll, promptSymlinks } from '../lib/symlink.ts';

const HOME = os.homedir();

export const SYSTEM_PACKAGES: Package[] = [
  { name: 'rofi', source: 'pacman', description: 'Application launcher / dmenu replacement' },
];

export const SYMLINKS = [
  {
    src:  path.join(DOTFILES_ROOT, 'rofi'),
    dest: path.join(HOME, '.config/rofi'),
  },
];

export async function runRofi(): Promise<void> {
  await installPackages({ system: SYSTEM_PACKAGES, pip: [] });
  await symlinkAll(await promptSymlinks(SYMLINKS));
  log.ok('rofi setup complete.');
}
