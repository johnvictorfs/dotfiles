import fs from 'fs/promises';
import os from 'os';
import path from 'path';
import { DOTFILES_ROOT, exec, log } from '../lib/utils.ts';
import type { Package } from '../lib/utils.ts';
import { installPackages } from '../lib/packages.ts';
import { symlinkAll, promptSymlinks } from '../lib/symlink.ts';
import { confirm } from '../lib/prompt.ts';

const HOME = os.homedir();

export const SYSTEM_PACKAGES: Package[] = [
  { name: 'waywall-working-git', source: 'aur',    description: 'waywall Wayland compositor' },
  { name: 'cmake',               source: 'pacman', description: 'Build system (needed to compile GLFW)' },
];

export const SYMLINKS = [
  {
    src: path.join(DOTFILES_ROOT, 'waywall'),
    dest: path.join(HOME, '.config/waywall'),
  },
];

const GLFW_REPO    = 'https://github.com/glfw/glfw';
const GLFW_TAG     = '3.4';
const GLFW_PATCH   = 'https://raw.githubusercontent.com/tesselslate/waywall/be3e018bb5f7c25610da73cc320233a26dfce948/contrib/glfw.patch';
const GLFW_LIB_DIR = path.join(HOME, '.local/lib64');

async function compileGlfw(): Promise<void> {
  const buildDir = '/tmp/glfw-waywall-build';

  try {
    await fs.rm(buildDir, { recursive: true, force: true });

    log.info('Cloning GLFW...');
    await exec('git', ['clone', GLFW_REPO, buildDir]);

    log.info(`Checking out GLFW ${GLFW_TAG}...`);
    await exec('git', ['checkout', GLFW_TAG], { cwd: buildDir });

    log.info('Downloading waywall GLFW patch...');
    await exec('curl', ['-o', 'glfw.patch', GLFW_PATCH], { cwd: buildDir });

    log.info('Applying patch...');
    await exec('git', ['apply', 'glfw.patch'], { cwd: buildDir });

    log.info('Configuring with cmake...');
    await exec('cmake', [
      '-S', '.',
      '-B', 'build',
      '-DBUILD_SHARED_LIBS=ON',
      '-DGLFW_BUILD_WAYLAND=ON',
    ], { cwd: buildDir });

    log.info('Compiling...');
    await exec('make', [], { cwd: path.join(buildDir, 'build') });

    const libSrc  = path.join(buildDir, 'build/src/libglfw.so');
    const libDest = path.join(GLFW_LIB_DIR, 'libglfw.so.3');
    const symDest = path.join(GLFW_LIB_DIR, 'libglfw.so');

    await fs.mkdir(GLFW_LIB_DIR, { recursive: true });

    log.info(`Copying libglfw.so → ${libDest}...`);
    await fs.copyFile(libSrc, libDest);

    // Create libglfw.so → libglfw.so.3 (relative symlink, same as the original)
    try { await fs.rm(symDest); } catch {}
    await fs.symlink('libglfw.so.3', symDest);

    log.ok(`GLFW installed to ${GLFW_LIB_DIR}`);
  } finally {
    log.info('Cleaning up build directory...');
    await fs.rm(buildDir, { recursive: true, force: true });
  }
}

export async function runWaywall(): Promise<void> {
  log.info('Installing waywall packages...');
  await installPackages({ system: SYSTEM_PACKAGES, pip: [] });

  await symlinkAll(await promptSymlinks(SYMLINKS));

  if (await confirm('Compile the custom GLFW needed for waywall?')) {
    await compileGlfw();
  }

  log.ok('waywall setup complete.');
}
