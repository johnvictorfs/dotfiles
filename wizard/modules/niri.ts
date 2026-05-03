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
  { name: "niri", source: "pacman", description: "niri Wayland compositor" },
  { name: "xwayland-satellite", source: "pacman", description: "XWayland support for niri" },
  { name: "xdg-desktop-portal-gnome", source: "pacman", description: "XDG desktop portal (GNOME)" },
  { name: "xdg-desktop-portal-gtk", source: "pacman", description: "XDG desktop portal (GTK)" },
  { name: "alacritty", source: "pacman", description: "GPU-accelerated terminal emulator" },
  { name: "dms-shell-niri", source: "pacman", description: "DMS shell for niri" },
  { name: "matugen", source: "pacman", description: "Material You color generation" },
  { name: "cava", source: "pacman", description: "Audio visualizer" },
  { name: "qt6-multimedia-ffmpeg", source: "pacman", description: "Qt6 multimedia FFmpeg backend" },
];

export const SYMLINKS: SymlinkSpec[] = [
  {
    src: path.join(DOTFILES_ROOT, "niri"),
    dest: path.join(HOME, ".config/niri"),
  },
];

export async function runNiri() {
  log.info("Installing niri packages...");
  await installPackages({ system: SYSTEM_PACKAGES });

  await applySymlinks(SYMLINKS);

  log.info("Enabling dms user service for niri...");
  await exec("systemctl", ["--user", "add-wants", "niri.service", "dms"]);

  log.ok("niri setup complete.");
}
