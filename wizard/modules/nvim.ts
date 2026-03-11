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
  { name: "neovim", source: "pacman", description: "Neovim text editor" },
  {
    name: "fd",
    source: "pacman",
    description: "File finder (used by telescope.nvim)",
  },
  {
    name: "ripgrep",
    source: "pacman",
    description: "Fast grep (used by telescope.nvim)",
  },
];

export const SYMLINKS: SymlinkSpec[] = [
  {
    src: path.join(DOTFILES_ROOT, "nvim"),
    dest: path.join(HOME, ".config/nvim"),
  },
];

export async function runNvim() {
  await installPackages({ system: SYSTEM_PACKAGES });
  await applySymlinks(SYMLINKS);
  log.ok("nvim setup complete.");
  log.info("Plugins will be installed by lazy.nvim on first launch.");
}
