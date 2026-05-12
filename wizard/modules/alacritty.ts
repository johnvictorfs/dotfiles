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
  { name: "alacritty", source: "pacman", description: "GPU-accelerated terminal emulator" },
];

export const SYMLINKS: SymlinkSpec[] = [
  {
    src: path.join(DOTFILES_ROOT, "alacritty/alacritty.toml"),
    dest: path.join(HOME, ".config/alacritty/alacritty.toml"),
  },
];

export async function runAlacritty() {
  await installPackages({ system: SYSTEM_PACKAGES });
  await applySymlinks(SYMLINKS);
  log.ok("alacritty setup complete.");
}
