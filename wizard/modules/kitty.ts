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
  { name: "kitty", source: "pacman", description: "Terminal emulator" },
];

export const SYMLINKS: SymlinkSpec[] = [
  {
    src: path.join(DOTFILES_ROOT, "kitty/kitty.conf"),
    dest: path.join(HOME, ".config/kitty/kitty.conf"),
  },
];

export async function runKitty() {
  await installPackages({ system: SYSTEM_PACKAGES });
  await applySymlinks(SYMLINKS);
  log.ok("kitty setup complete.");
}
