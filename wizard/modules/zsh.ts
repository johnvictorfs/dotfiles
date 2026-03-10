import fs from 'fs/promises';
import os from 'os';
import path from 'path';
import { spawnSync } from 'child_process';
import { DOTFILES_ROOT, exec, log } from '../lib/utils.ts';
import type { Package } from '../lib/utils.ts';
import { installPackages } from '../lib/packages.ts';
import { symlinkAll, promptSymlinks } from '../lib/symlink.ts';

const HOME = os.homedir();

export const SYSTEM_PACKAGES: Package[] = [
  { name: 'zsh', source: 'pacman', description: 'Z shell' },
];

export const SYMLINKS = [
  {
    src:  path.join(DOTFILES_ROOT, '.zshrc'),
    dest: path.join(HOME, '.zshrc'),
  },
  {
    src:  path.join(DOTFILES_ROOT, '.aliases'),
    dest: path.join(HOME, '.aliases'),
  },
  // jvfs.zsh-theme is sourced directly from the dotfiles path in .zshrc —
  // no symlink needed.
];

async function installZgenom(): Promise<void> {
  const dest = path.join(HOME, '.zgenom');
  try {
    await fs.access(dest);
    log.info('zgenom already installed.');
  } catch {
    log.info('Cloning zgenom...');
    await exec('git', ['clone', 'https://github.com/jandamm/zgenom.git', dest]);
    log.ok('zgenom installed.');
  }
}

function getZshPath(): string {
  const result = spawnSync('which', ['zsh'], { encoding: 'utf8' });
  return result.stdout.trim() || '/usr/bin/zsh';
}

export async function runZsh(): Promise<void> {
  log.info('Installing zsh packages...');
  await installPackages({ system: SYSTEM_PACKAGES, pip: [] });

  await symlinkAll(await promptSymlinks(SYMLINKS));

  await installZgenom();

  log.info('Changing default shell to zsh...');
  await exec('chsh', ['-s', getZshPath()]);

  log.ok('zsh setup complete.');
  log.warn('Log out and back in for the shell change to take effect.');
}
