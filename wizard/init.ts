import fs from 'fs/promises';
import { spawnSync } from 'child_process';
import { log } from './lib/utils.ts';
import type { WizardModule, SymlinkSpec } from './lib/utils.ts';
import { ensurePacman, ensureParu } from './lib/packages.ts';
import { confirm, selectModules, closeReadline } from './lib/prompt.ts';
import { COLORS } from './lib/colors.ts';
import { runShared, SYSTEM_PACKAGES as SHARED_SYS, PIP_PACKAGES as SHARED_PIP, SYMLINKS as SHARED_LINKS } from './modules/shared.ts';
import { runI3, SYSTEM_PACKAGES as I3_SYS, PIP_PACKAGES as I3_PIP, SYMLINKS as I3_LINKS } from './modules/i3.ts';
import { runMango, SYSTEM_PACKAGES as MANGO_SYS, SYMLINKS as MANGO_LINKS } from './modules/mango.ts';
import { runWaywall, SYSTEM_PACKAGES as WAYWALL_SYS, SYMLINKS as WAYWALL_LINKS } from './modules/waywall.ts';
import { runVscode, SYSTEM_PACKAGES as VSCODE_SYS, SYMLINKS as VSCODE_LINKS } from './modules/vscode.ts';
import { runZsh, SYSTEM_PACKAGES as ZSH_SYS, SYMLINKS as ZSH_LINKS } from './modules/zsh.ts';
import { runZathura, SYSTEM_PACKAGES as ZATHURA_SYS, SYMLINKS as ZATHURA_LINKS } from './modules/zathura.ts';
import { runRofi, SYSTEM_PACKAGES as ROFI_SYS, SYMLINKS as ROFI_LINKS } from './modules/rofi.ts';
import { runNvim, SYSTEM_PACKAGES as NVIM_SYS, SYMLINKS as NVIM_LINKS } from './modules/nvim.ts';

function printBanner(): void {
  console.log(`
${COLORS.CYAN}${COLORS.BOLD}╔══════════════════════════════════╗
║       dotfiles wizard            ║
╚══════════════════════════════════╝${COLORS.RESET}
`);
}

const modules: WizardModule[] = [
  {
    id: 1,
    label: 'Shared (fonts, themes, kitty, dunst, rofi, ...)',
    packages: { system: SHARED_SYS, pip: SHARED_PIP },
    symlinks: SHARED_LINKS,
    run: runShared,
  },
  {
    id: 2,
    label: 'i3 + polybar',
    packages: { system: I3_SYS, pip: I3_PIP },
    symlinks: I3_LINKS,
    run: runI3,
  },
  {
    id: 3,
    label: 'mango + waybar',
    packages: { system: MANGO_SYS, pip: [] },
    symlinks: MANGO_LINKS,
    run: runMango,
  },
  {
    id: 4,
    label: 'waywall',
    packages: { system: WAYWALL_SYS, pip: [] },
    symlinks: WAYWALL_LINKS,
    run: runWaywall,
  },
  {
    id: 5,
    label: 'VSCode',
    packages: { system: VSCODE_SYS, pip: [] },
    symlinks: VSCODE_LINKS,
    run: runVscode,
  },
  {
    id: 6,
    label: 'zsh + oh-my-zsh',
    packages: { system: ZSH_SYS, pip: [] },
    symlinks: ZSH_LINKS,
    run: runZsh,
  },
  {
    id: 7,
    label: 'zathura',
    packages: { system: ZATHURA_SYS, pip: [] },
    symlinks: ZATHURA_LINKS,
    run: runZathura,
  },
  {
    id: 8,
    label: 'rofi',
    packages: { system: ROFI_SYS, pip: [] },
    symlinks: ROFI_LINKS,
    run: runRofi,
  },
  {
    id: 9,
    label: 'nvim',
    packages: { system: NVIM_SYS, pip: [] },
    symlinks: NVIM_LINKS,
    run: runNvim,
  },
];

function getInstalledPackages(): Set<string> {
  const result = spawnSync('pacman', ['-Qq'], { encoding: 'utf8' });
  return new Set(result.stdout.split('\n').filter(Boolean));
}

async function isSymlinkCorrect(spec: SymlinkSpec): Promise<boolean> {
  try {
    const stat = await fs.lstat(spec.dest);
    if (!stat.isSymbolicLink()) return false;
    return (await fs.readlink(spec.dest)) === spec.src;
  } catch {
    return false;
  }
}

async function checkModule(mod: WizardModule, installed: Set<string>): Promise<boolean> {
  if (mod.packages) {
    for (const pkg of mod.packages.system) {
      if (!installed.has(pkg.name)) return false;
    }
  }
  if (mod.symlinks) {
    for (const spec of mod.symlinks) {
      if (!(await isSymlinkCorrect(spec))) return false;
    }
  }
  return true;
}

function printPackagePreview(selected: WizardModule[]): void {
  const DIM = '\x1b[2m';
  const YELLOW_LOCAL = '\x1b[33m';
  const RESET_LOCAL = '\x1b[0m';

  console.log(`\n${COLORS.BOLD}Packages to install:${COLORS.RESET}\n`);
  for (const mod of selected) {
    if (!mod.packages) continue;
    const { system, pip } = mod.packages;
    if (system.length === 0 && pip.length === 0) continue;
    console.log(`  ${COLORS.CYAN}${mod.label}${COLORS.RESET}`);
    if (system.length > 0) {
      const formatted = system
        .map((p) => p.source === 'aur' ? `${p.name}${YELLOW_LOCAL}[aur]${RESET_LOCAL}` : p.name)
        .join(', ');
      console.log(`    ${DIM}system:${RESET_LOCAL} ${formatted}`);
    }
    if (pip.length > 0) {
      console.log(`    ${DIM}pip:${RESET_LOCAL}    ${pip.map((p) => p.name).join(', ')}`);
    }
    console.log();
  }
}

async function main(): Promise<void> {
  printBanner();

  await ensurePacman();
  await ensureParu();

  log.info('Checking module status...');
  const installed = getInstalledPackages();
  const checks = await Promise.all(modules.map((m) => checkModule(m, installed)));
  const doneIds = new Set(modules.filter((_, i) => checks[i]).map((m) => m.id));

  const selected = await selectModules(modules, doneIds);

  if (selected.length === 0) {
    log.warn('No modules selected. Exiting.');
    closeReadline();
    return;
  }

  printPackagePreview(selected);
  const proceed = await confirm('Proceed with installation?');
  if (!proceed) {
    log.warn('Aborted.');
    closeReadline();
    return;
  }

  let failed = false;
  for (const mod of selected) {
    console.log(`\n${COLORS.CYAN}${COLORS.BOLD}── ${mod.label} ──${COLORS.RESET}\n`);
    try {
      await mod.run();
    } catch (err: any) {
      log.error(`Module "${mod.label}" failed: ${err.message}`);
      failed = true;
      const cont = await confirm('Continue with remaining modules?');
      if (!cont) break;
    }
  }

  closeReadline();

  if (failed) {
    log.warn('Wizard completed with errors.');
  } else {
    log.ok('All done!');
  }
}

main().catch((err) => {
  log.error(err.message);
  closeReadline();
  process.exit(1);
});
