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
  { name: "mangowm", source: "aur", description: "mangowm window manager" },
  { name: "waybar", source: "pacman", description: "Status bar for Wayland" },
  {
    name: "wlrobs-hg",
    source: "aur",
    description: "OBS wlroots screen capture plugin",
  },
  {
    name: "grim",
    source: "pacman",
    description: "Screenshot backend for flameshot on Wayland",
  },
  {
    name: "xdg-desktop-portal-wlr",
    source: "pacman",
    description: "Screensharing + screen recording for wlroots compositors",
  },
];

export const SYMLINKS: SymlinkSpec[] = [
  {
    src: path.join(DOTFILES_ROOT, "mango/config.conf"),
    dest: path.join(HOME, ".config/mango/config.conf"),
  },
  {
    src: path.join(DOTFILES_ROOT, "waybar"),
    dest: path.join(HOME, ".config/waybar"),
  },
];

export async function runMango() {
  log.info("Installing mango packages...");
  await installPackages({ system: SYSTEM_PACKAGES });

  await applySymlinks(SYMLINKS);

  log.ok("mango setup complete.");
}
