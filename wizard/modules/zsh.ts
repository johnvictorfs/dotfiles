import fs from "fs/promises";
import { spawnSync } from "child_process";
import {
  HOME,
  DOTFILES_ROOT,
  path,
  exec,
  log,
  installPackages,
  applySymlinks,
  type Package,
  type SymlinkSpec,
} from "../lib/api.ts";

export const SYSTEM_PACKAGES: Package[] = [
  { name: "zsh", source: "pacman", description: "Z shell" },
];

export const SYMLINKS: SymlinkSpec[] = [
  {
    src: path.join(DOTFILES_ROOT, ".zshrc"),
    dest: path.join(HOME, ".zshrc"),
  },
  {
    src: path.join(DOTFILES_ROOT, ".aliases"),
    dest: path.join(HOME, ".aliases"),
  },
  // jvfs.zsh-theme is sourced directly from the dotfiles path in .zshrc —
  // no symlink needed.
];

async function installZgenom() {
  const dest = path.join(HOME, ".zgenom");
  try {
    await fs.access(dest);
    log.info("zgenom already installed.");
  } catch {
    log.info("Cloning zgenom...");
    await exec("git", ["clone", "https://github.com/jandamm/zgenom.git", dest]);
    log.ok("zgenom installed.");
  }
}

function getZshPath(): string {
  const result = spawnSync("which", ["zsh"], { encoding: "utf8" });
  return result.stdout.trim() || "/usr/bin/zsh";
}

export async function runZsh() {
  log.info("Installing zsh packages...");
  await installPackages({ system: SYSTEM_PACKAGES });

  await applySymlinks(SYMLINKS);

  await installZgenom();

  log.info("Changing default shell to zsh...");
  await exec("chsh", ["-s", getZshPath()]);

  log.ok("zsh setup complete.");
  log.warn("Log out and back in for the shell change to take effect.");
}
