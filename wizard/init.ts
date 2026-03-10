import { log } from './lib/utils.ts';
import { ensurePacman, ensureParu } from './lib/packages.ts';
import { confirm, selectModules, closeReadline } from './lib/prompt.ts';
import { runShared, SYSTEM_PACKAGES as SHARED_SYS, PIP_PACKAGES as SHARED_PIP } from './modules/shared.ts';
import { runI3, SYSTEM_PACKAGES as I3_SYS, PIP_PACKAGES as I3_PIP } from './modules/i3.ts';
import { runMango, SYSTEM_PACKAGES as MANGO_SYS } from './modules/mango.ts';
import { runWaywall, SYSTEM_PACKAGES as WAYWALL_SYS } from './modules/waywall.ts';
import { runVscode, SYSTEM_PACKAGES as VSCODE_SYS } from './modules/vscode.ts';
import { runZsh, SYSTEM_PACKAGES as ZSH_SYS } from './modules/zsh.ts';
import type { WizardModule } from './lib/utils.ts';

const CYAN = '\x1b[36m';
const BOLD = '\x1b[1m';
const RESET = '\x1b[0m';

function printBanner(): void {
  console.log(`
${CYAN}${BOLD}╔══════════════════════════════════╗
║       dotfiles wizard            ║
╚══════════════════════════════════╝${RESET}
`);
}

const modules: WizardModule[] = [
  {
    id: 1,
    label: 'Shared (fonts, themes, kitty, dunst, rofi, ...)',
    status: 'available',
    packages: { system: SHARED_SYS, pip: SHARED_PIP },
    run: runShared,
  },
  {
    id: 2,
    label: 'i3 + polybar',
    status: 'available',
    packages: { system: I3_SYS, pip: I3_PIP },
    run: runI3,
  },
  {
    id: 3,
    label: 'mango + waybar',
    status: 'available',
    packages: { system: MANGO_SYS, pip: [] },
    run: runMango,
  },
  {
    id: 4,
    label: 'waywall',
    status: 'available',
    packages: { system: WAYWALL_SYS, pip: [] },
    run: runWaywall,
  },
  {
    id: 5,
    label: 'VSCode',
    status: 'available',
    packages: { system: VSCODE_SYS, pip: [] },
    run: runVscode,
  },
  {
    id: 6,
    label: 'zsh + oh-my-zsh',
    status: 'available',
    packages: { system: ZSH_SYS, pip: [] },
    run: runZsh,
  },
];

function printPackagePreview(selected: WizardModule[]): void {
  const DIM = '\x1b[2m';
  const YELLOW_LOCAL = '\x1b[33m';
  const RESET_LOCAL = '\x1b[0m';

  console.log(`\n${BOLD}Packages to install:${RESET_LOCAL}\n`);
  for (const mod of selected) {
    if (!mod.packages) continue;
    const { system, pip } = mod.packages;
    if (system.length === 0 && pip.length === 0) continue;
    console.log(`  ${CYAN}${mod.label}${RESET_LOCAL}`);
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

  const selected = await selectModules(modules);

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
    console.log(`\n${CYAN}${BOLD}── ${mod.label} ──${RESET}\n`);
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
