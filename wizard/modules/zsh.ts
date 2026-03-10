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
  { name: 'zsh',          source: 'pacman', description: 'Z shell' },
  { name: 'oh-my-zsh-git', source: 'aur',   description: 'Oh My Zsh zsh framework' },
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
  {
    // oh-my-zsh-git (AUR) uses /usr/share/oh-my-zsh; user-level custom dir
    // is controlled by $ZSH_CUSTOM, defaulting to ~/.oh-my-zsh/custom
    src:  path.join(DOTFILES_ROOT, 'zsh/jvfs.zsh-theme'),
    dest: path.join(HOME, '.oh-my-zsh/custom/themes/jvfs.zsh-theme'),
  },
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
