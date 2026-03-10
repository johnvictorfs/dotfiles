import os from 'os';
import path from 'path';
import { DOTFILES_ROOT, log } from '../lib/utils.ts';
import type { Package } from '../lib/utils.ts';
import { installPackages } from '../lib/packages.ts';
import { symlinkAll, promptSymlinks } from '../lib/symlink.ts';

const HOME = os.homedir();

export const SYSTEM_PACKAGES: Package[] = [
  { name: 'neovim',  source: 'pacman', description: 'Neovim text editor' },
  { name: 'fd',      source: 'pacman', description: 'File finder (used by telescope.nvim)' },
  { name: 'ripgrep', source: 'pacman', description: 'Fast grep (used by telescope.nvim)' },
];

export const SYMLINKS = [
  {
    src:  path.join(DOTFILES_ROOT, 'nvim'),
    dest: path.join(HOME, '.config/nvim'),
  },
];

export async function runNvim(): Promise<void> {
  await installPackages({ system: SYSTEM_PACKAGES, pip: [] });
  await symlinkAll(await promptSymlinks(SYMLINKS));
  log.ok('nvim setup complete.');
  log.info('Plugins will be installed by lazy.nvim on first launch.');
}
