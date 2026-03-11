import {
  HOME,
  DOTFILES_ROOT,
  path,
  log,
  installPackages,
  applySymlinks,
  type Package,
  type SymlinkSpec,
} from "../lib/api.ts";

export const SYSTEM_PACKAGES: Package[] = [
  {
    name: "rofi",
    source: "pacman",
    description: "Application launcher / dmenu replacement",
  },
];

export const SYMLINKS: SymlinkSpec[] = [
  {
    src: path.join(DOTFILES_ROOT, "rofi"),
    dest: path.join(HOME, ".config/rofi"),
  },
];

export async function runRofi() {
  await installPackages({ system: SYSTEM_PACKAGES });
  await applySymlinks(SYMLINKS);
  log.ok("rofi setup complete.");
}
