import os from 'os';
import path from 'path';
import { DOTFILES_ROOT, log } from '../lib/utils.ts';
import type { Package } from '../lib/utils.ts';
import { installPackages } from '../lib/packages.ts';
import { symlinkAll, promptSymlinks } from '../lib/symlink.ts';

const HOME = os.homedir();

export const SYSTEM_PACKAGES: Package[] = [
  { name: 'mangowm',                source: 'aur',    description: 'mangowm window manager' },
  { name: 'waybar',                 source: 'pacman', description: 'Status bar for Wayland' },
  { name: 'wlrobs-hg',              source: 'aur',    description: 'OBS wlroots screen capture plugin' },
  { name: 'grim',                   source: 'pacman', description: 'Screenshot backend for flameshot on Wayland' },
  { name: 'xdg-desktop-portal-wlr', source: 'pacman', description: 'Screensharing + screen recording for wlroots compositors' },
];

const SYMLINKS = [
  {
    src: path.join(DOTFILES_ROOT, 'mango/config.conf'),
    dest: path.join(HOME, '.config/mango/config.conf'),
  },
  {
    src: path.join(DOTFILES_ROOT, 'waybar'),
    dest: path.join(HOME, '.config/waybar'),
  },
];

export async function runMango(): Promise<void> {
  log.info('Installing mango packages...');
  await installPackages({ system: SYSTEM_PACKAGES, pip: [] });

  await symlinkAll(await promptSymlinks(SYMLINKS));

  log.ok('mango setup complete.');
}
