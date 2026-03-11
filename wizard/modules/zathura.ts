import {
  HOME,
  DOTFILES_ROOT,
  path,
  log,
  installPackages,
  applySymlinks,
  type SymlinkSpec,
  type Package,
} from "../lib/api.ts";

export const SYSTEM_PACKAGES: Package[] = [
  { name: "zathura", source: "pacman", description: "PDF viewer" },
  {
    name: "zathura-pdf-mupdf",
    source: "pacman",
    description: "MuPDF backend for zathura",
  },
];

export const SYMLINKS: SymlinkSpec[] = [
  {
    src: path.join(DOTFILES_ROOT, "zathura/zathurarc"),
    dest: path.join(HOME, ".config/zathura/zathurarc"),
  },
];

export async function runZathura() {
  await installPackages({ system: SYSTEM_PACKAGES });
  await applySymlinks(SYMLINKS);
  log.ok("zathura setup complete.");
}
