import os from 'os';
import path from 'path';
import { DOTFILES_ROOT, log } from '../lib/utils.ts';
import type { Package } from '../lib/utils.ts';
import { installPackages } from '../lib/packages.ts';
import { symlinkAll, promptSymlinks } from '../lib/symlink.ts';

const HOME = os.homedir();

export const SYSTEM_PACKAGES: Package[] = [
  { name: 'waywall-working-git', source: 'aur', description: 'waywall Wayland compositor' },
];

const SYMLINKS = [
  {
    src: path.join(DOTFILES_ROOT, 'waywall'),
    dest: path.join(HOME, '.config/waywall'),
  },
];

export async function runWaywall(): Promise<void> {
  log.info('Installing waywall packages...');
  await installPackages({ system: SYSTEM_PACKAGES, pip: [] });

  await symlinkAll(await promptSymlinks(SYMLINKS));

  log.ok('waywall setup complete.');
}
