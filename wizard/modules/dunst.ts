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
  { name: "dunst", source: "pacman", description: "Notification daemon" },
];

export const SYMLINKS: SymlinkSpec[] = [
  {
    src: path.join(DOTFILES_ROOT, "dunst"),
    dest: path.join(HOME, ".config/dunst"),
  },
];

export async function runDunst() {
  await installPackages({ system: SYSTEM_PACKAGES });
  await applySymlinks(SYMLINKS);
  log.ok("dunst setup complete.");
}
