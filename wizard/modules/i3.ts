import os from 'os';
import path from 'path';
import { DOTFILES_ROOT, exec, log } from '../lib/utils.ts';
import type { Package } from '../lib/utils.ts';
import { installPackages } from '../lib/packages.ts';
import { symlinkAll, promptSymlinks } from '../lib/symlink.ts';

const HOME = os.homedir();

export const SYSTEM_PACKAGES: Package[] = [
  { name: 'i3',                  source: 'pacman', description: 'i3 window manager' },
  { name: 'i3exit',              source: 'aur',    description: 'Suspend/lock/logout commands for i3' },
  { name: 'picom',               source: 'pacman', description: 'Compositor' },
  { name: 'polybar',             source: 'pacman', description: 'Status bar' },
  { name: 'arandr',              source: 'pacman', description: 'Multi-monitor setup GUI' },
  { name: 'lightdm',             source: 'pacman', description: 'Display manager (login screen)' },
  { name: 'lightdm-gtk-greeter', source: 'pacman', description: 'LightDM GTK greeter' },
  { name: 'xorg-server',         source: 'pacman', description: 'X display server' },
  { name: 'nitrogen',            source: 'pacman', description: 'Wallpaper manager' },
  { name: 'maim',                source: 'pacman', description: 'Screenshot tool' },
  { name: 'xclip',               source: 'pacman', description: 'Clipboard utility' },
  { name: 'xsel',                source: 'pacman', description: 'Clipboard utility' },
];

export const PIP_PACKAGES = [
  { name: 'i3ipc', description: 'i3 IPC events API' },
];

export const SYMLINKS = [
  { src: path.join(DOTFILES_ROOT, 'i3/config'),    dest: path.join(HOME, '.config/i3/config') },
  { src: path.join(DOTFILES_ROOT, 'polybar'),      dest: path.join(HOME, '.config/polybar') },
  { src: path.join(DOTFILES_ROOT, 'picom'),        dest: path.join(HOME, '.config/picom') },
  { src: path.join(DOTFILES_ROOT, 'eww'),          dest: path.join(HOME, '.config/eww') },
  { src: path.join(DOTFILES_ROOT, '.Xresources'),  dest: path.join(HOME, '.Xresources') },
];

const WALLPAPER = path.join(DOTFILES_ROOT, 'images/solid_wallpaper_2.png');

export async function runI3(): Promise<void> {
  log.info('Installing i3 packages...');
  await installPackages({ system: SYSTEM_PACKAGES, pip: PIP_PACKAGES });

  await symlinkAll(await promptSymlinks(SYMLINKS));

  log.info('Loading .Xresources...');
  await exec('xrdb', [path.join(HOME, '.Xresources')]);

  log.info('Setting wallpaper with nitrogen...');
  await exec('nitrogen', ['--set-auto', WALLPAPER]);

  log.info('Enabling lightdm (will not start — would kill current session)...');
  await exec('sudo', ['systemctl', 'enable', 'lightdm']);

  log.ok('i3 setup complete.');
}
