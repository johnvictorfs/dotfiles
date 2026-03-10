import os from 'os';
import path from 'path';
import { DOTFILES_ROOT, log } from '../lib/utils.ts';
import type { Package } from '../lib/utils.ts';
import { installPackages } from '../lib/packages.ts';
import { symlinkAll, promptSymlinks } from '../lib/symlink.ts';

const HOME = os.homedir();

export const SYSTEM_PACKAGES: Package[] = [
  { name: 'zathura',          source: 'pacman', description: 'PDF viewer' },
  { name: 'zathura-pdf-mupdf', source: 'pacman', description: 'MuPDF backend for zathura' },
];

export const SYMLINKS = [
  {
    src:  path.join(DOTFILES_ROOT, 'zathura/zathurarc'),
    dest: path.join(HOME, '.config/zathura/zathurarc'),
  },
];

export async function runZathura(): Promise<void> {
  await installPackages({ system: SYSTEM_PACKAGES, pip: [] });
  await symlinkAll(await promptSymlinks(SYMLINKS));
  log.ok('zathura setup complete.');
}
