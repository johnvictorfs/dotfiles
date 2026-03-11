import fs from "fs/promises";
import { spawnSync } from "child_process";
import { log, setVerbose } from "./lib/utils.ts";
import type { WizardModule, SymlinkSpec } from "./lib/utils.ts";
import { ensurePacman, ensureParu } from "./lib/packages.ts";
import { confirm, selectModules, closeReadline } from "./lib/prompt.ts";
import { COLORS } from "./lib/colors.ts";
import {
  runShared,
  SYSTEM_PACKAGES as SHARED_SYS,
  PIP_PACKAGES as SHARED_PIP,
  SYMLINKS as SHARED_LINKS,
} from "./modules/shared.ts";
import {
  runI3,
  SYSTEM_PACKAGES as I3_SYS,
  PIP_PACKAGES as I3_PIP,
  SYMLINKS as I3_LINKS,
} from "./modules/i3.ts";
import {
  runMango,
  SYSTEM_PACKAGES as MANGO_SYS,
  SYMLINKS as MANGO_LINKS,
} from "./modules/mango.ts";
import {
  runWaywall,
  SYSTEM_PACKAGES as WAYWALL_SYS,
  SYMLINKS as WAYWALL_LINKS,
} from "./modules/waywall.ts";
import {
  runVscode,
  SYSTEM_PACKAGES as VSCODE_SYS,
  SYMLINKS as VSCODE_LINKS,
} from "./modules/vscode.ts";
import {
  runZsh,
  SYSTEM_PACKAGES as ZSH_SYS,
  SYMLINKS as ZSH_LINKS,
} from "./modules/zsh.ts";
import {
  runZathura,
  SYSTEM_PACKAGES as ZATHURA_SYS,
  SYMLINKS as ZATHURA_LINKS,
} from "./modules/zathura.ts";
import {
  runRofi,
  SYSTEM_PACKAGES as ROFI_SYS,
  SYMLINKS as ROFI_LINKS,
} from "./modules/rofi.ts";
import {
  runNvim,
  SYSTEM_PACKAGES as NVIM_SYS,
  SYMLINKS as NVIM_LINKS,
} from "./modules/nvim.ts";
import {
  runKitty,
  SYSTEM_PACKAGES as KITTY_SYS,
  SYMLINKS as KITTY_LINKS,
} from "./modules/kitty.ts";
import {
  runDunst,
  SYSTEM_PACKAGES as DUNST_SYS,
  SYMLINKS as DUNST_LINKS,
} from "./modules/dunst.ts";
import { runTlp, SYSTEM_PACKAGES as TLP_SYS } from "./modules/tlp.ts";

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
    label: "Shared (fonts, themes, ...)",
    packages: { system: SHARED_SYS, pip: SHARED_PIP },
    symlinks: SHARED_LINKS,
    run: runShared,
  },
  {
    id: 2,
    label: "i3 + polybar",
    packages: { system: I3_SYS, pip: I3_PIP },
    symlinks: I3_LINKS,
    run: runI3,
  },
  {
    id: 3,
    label: "mango + waybar",
    packages: { system: MANGO_SYS },
    symlinks: MANGO_LINKS,
    run: runMango,
  },
  {
    id: 4,
    label: "waywall",
    packages: { system: WAYWALL_SYS },
    symlinks: WAYWALL_LINKS,
    run: runWaywall,
  },
  {
    id: 5,
    label: "VSCode",
    packages: { system: VSCODE_SYS },
    symlinks: VSCODE_LINKS,
    run: runVscode,
  },
  {
    id: 6,
    label: "zsh + oh-my-zsh",
    packages: { system: ZSH_SYS },
    symlinks: ZSH_LINKS,
    run: runZsh,
  },
  {
    id: 7,
    label: "zathura",
    packages: { system: ZATHURA_SYS },
    symlinks: ZATHURA_LINKS,
    run: runZathura,
  },
  {
    id: 8,
    label: "rofi",
    packages: { system: ROFI_SYS },
    symlinks: ROFI_LINKS,
    run: runRofi,
  },
  {
    id: 9,
    label: "nvim",
    packages: { system: NVIM_SYS },
    symlinks: NVIM_LINKS,
    run: runNvim,
  },
  {
    id: 10,
    label: "kitty",
    packages: { system: KITTY_SYS },
    symlinks: KITTY_LINKS,
    run: runKitty,
  },
  {
    id: 11,
    label: "dunst",
    packages: { system: DUNST_SYS },
    symlinks: DUNST_LINKS,
    run: runDunst,
  },
  {
    id: 12,
    label: "tlp (laptop power management)",
    packages: { system: TLP_SYS },
    run: runTlp,
  },
];

function getInstalledPackages(): Set<string> {
  log.debug("Running pacman -Qq...");
  const result = spawnSync("pacman", ["-Qq"], { encoding: "utf8" });
  const set = new Set(result.stdout.split("\n").filter(Boolean));
  log.debug(`pacman reports ${set.size} installed packages.`);
  return set;
}

async function isSymlinkCorrect(spec: SymlinkSpec): Promise<boolean> {
  try {
    const stat = await fs.lstat(spec.dest);
    if (!stat.isSymbolicLink()) {
      log.debug(`  symlink ${spec.dest}: exists but is not a symlink`);
      return false;
    }
    const current = await fs.readlink(spec.dest);
    const ok = current === spec.src;
    log.debug(
      `  symlink ${spec.dest}: ${ok ? "ok" : `wrong target → ${current}`}`,
    );
    return ok;
  } catch {
    log.debug(`  symlink ${spec.dest}: missing`);
    return false;
  }
}

async function checkModule(
  mod: WizardModule,
  installed: Set<string>,
): Promise<boolean> {
  log.debug(`Checking module "${mod.label}":`);
  if (mod.packages?.system) {
    for (const pkg of mod.packages.system) {
      const found = installed.has(pkg.name);
      log.debug(`  package ${pkg.name}: ${found ? "installed" : "missing"}`);
      if (!found) return false;
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
  console.log(`\n${COLORS.BOLD}Packages to install:${COLORS.RESET}\n`);
  for (const mod of selected) {
    if (!mod.packages) continue;

    const { system, pip } = mod.packages;

    if ((system?.length === 0 || !system) && (pip?.length === 0 || !pip))
      continue;
    console.log(`  ${COLORS.CYAN}${mod.label}${COLORS.RESET}`);

    if (system && system.length > 0) {
      const formatted = system
        .map((p) =>
          p.source === "aur"
            ? `${p.name}${COLORS.YELLOW}[aur]${COLORS.RESET}`
            : p.name,
        )
        .join(", ");
      console.log(`    ${COLORS.DIM}system:${COLORS.RESET} ${formatted}`);
    }

    if (pip && pip.length > 0) {
      console.log(
        `    ${COLORS.DIM}pip:${COLORS.RESET}    ${pip.map((p) => p.name).join(", ")}`,
      );
    }

    console.log();
  }
}

async function main() {
  setVerbose(process.argv.includes("-v"));
  printBanner();

  await ensurePacman();
  await ensureParu();

  log.info("Checking module status...");
  const installed = getInstalledPackages();
  const checks = await Promise.all(
    modules.map((m) => checkModule(m, installed)),
  );
  const doneIds = new Set(modules.filter((_, i) => checks[i]).map((m) => m.id));

  const selected = await selectModules(modules, doneIds);

  if (selected.length === 0) {
    log.warn("No modules selected. Exiting.");
    closeReadline();
    return;
  }

  printPackagePreview(selected);
  const proceed = await confirm("Proceed with installation?");
  if (!proceed) {
    log.warn("Aborted.");
    closeReadline();
    return;
  }

  let failed = false;
  for (const mod of selected) {
    console.log(
      `\n${COLORS.CYAN}${COLORS.BOLD}── ${mod.label} ──${COLORS.RESET}\n`,
    );
    try {
      await mod.run();
    } catch (err: any) {
      log.error(`Module "${mod.label}" failed: ${err.message}`);
      failed = true;
      const cont = await confirm("Continue with remaining modules?");
      if (!cont) break;
    }
  }

  closeReadline();

  if (failed) {
    log.warn("Wizard completed with errors.");
  } else {
    log.ok("All done!");
  }
}

main().catch((err) => {
  log.error(err.message);
  closeReadline();
  process.exit(1);
});
