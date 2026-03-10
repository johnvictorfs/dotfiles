import os from 'os';
import path from 'path';
import { DOTFILES_ROOT, exec, log } from '../lib/utils.ts';
import type { Package } from '../lib/utils.ts';
import { installPackages } from '../lib/packages.ts';
import { symlinkAll, promptSymlinks } from '../lib/symlink.ts';

const HOME = os.homedir();

export const SYSTEM_PACKAGES: Package[] = [
  { name: 'bluez',                          source: 'pacman', description: 'Bluetooth stack' },
  { name: 'blueman',                        source: 'pacman', description: 'Bluetooth frontend' },
  { name: 'jq',                             source: 'pacman', description: 'CLI JSON processor' },
  { name: 'fzf',                            source: 'pacman', description: 'Fuzzy finder' },
  { name: 'fd',                             source: 'pacman', description: 'Alternative to find, pairs with fzf' },
  { name: 'go',                             source: 'pacman', description: 'Go programming language' },
  { name: 'yarn',                           source: 'pacman', description: 'Node.js package manager' },
  { name: 'nodejs-n',                       source: 'aur',    description: 'Node.js version manager' },
  { name: 'papirus-icon-theme',             source: 'pacman', description: 'Icon theme' },
  { name: 'nordic-theme-git',               source: 'aur',    description: 'GTK theme' },
  { name: 'materia-gtk-theme',              source: 'pacman', description: 'GTK theme' },
  { name: 'exa',                            source: 'pacman', description: 'Alternative to ls' },
  { name: 'python-pip',                     source: 'pacman', description: 'Python package manager' },
  { name: 'python-dbus',                    source: 'pacman', description: 'Python dbus API' },
  { name: 'lxappearance-gtk3',              source: 'aur',    description: 'GTK theme settings GUI' },
  { name: 'adobe-source-han-sans-jp-fonts', source: 'pacman', description: 'Japanese (kanji/hiragana/katakana) font' },
  { name: 'ttf-jetbrains-mono',             source: 'pacman', description: 'JetBrains Mono font' },
  { name: 'ttf-fantasque-sans-mono',        source: 'aur',    description: 'Fantasque Sans Mono font' },
  { name: 'ttf-font-awesome',               source: 'pacman', description: 'Font Awesome icons' },
  { name: 'ttf-google-sans',                source: 'aur',    description: 'Google Sans font' },
  { name: 'ttf-material-design-icons',      source: 'aur',    description: 'Material Design icons' },
  { name: 'ttf-firacode-nerd',              source: 'pacman', description: 'Fira Code Nerd Font' },
  { name: 'noto-fonts',                     source: 'pacman', description: 'Google Noto fonts' },
  { name: 'noto-fonts-cjk',                 source: 'pacman', description: 'Noto CJK fonts' },
  { name: 'kitty',                          source: 'pacman', description: 'Terminal emulator' },
  { name: 'dunst',                          source: 'pacman', description: 'Notification daemon' },
  { name: 'rofi',                           source: 'pacman', description: 'Application launcher / dmenu replacement' },
  { name: 'nautilus',                       source: 'pacman', description: 'File manager' },
  { name: 'network-manager-applet',         source: 'pacman', description: 'NetworkManager tray applet' },
  { name: 'zathura',                        source: 'pacman', description: 'PDF viewer' },
  { name: 'zathura-pdf-mupdf',              source: 'pacman', description: 'MuPDF backend for zathura' },
  { name: 'foliate',                        source: 'pacman', description: 'e-Book reader' },
  { name: 'mpv',                            source: 'pacman', description: 'Video player' },
  { name: 'playerctl',                      source: 'pacman', description: 'Media control CLI' },
  { name: 'pamixer',                        source: 'pacman', description: 'Volume control CLI' },
  { name: 'light',                          source: 'pacman', description: 'Brightness control CLI' },
  { name: 'calc',                           source: 'pacman', description: 'Terminal calculator' },
  { name: 'flameshot',                      source: 'pacman', description: 'Screenshot tool' },
  { name: 'highlight',                      source: 'pacman', description: 'Syntax highlighting (for ccat)' },
  { name: 'pipewire-pulse',                 source: 'pacman', description: 'PulseAudio-compatible PipeWire backend' },
];

export const PIP_PACKAGES = [
  { name: 'bs4',         description: 'BeautifulSoup HTML parser' },
  { name: 'html5lib',    description: 'HTML5 parser' },
  { name: 'fontawesome', description: 'Font Awesome icon names API' },
];

const SYMLINKS = [
  { src: path.join(DOTFILES_ROOT, '.bin'),            dest: path.join(HOME, '.bin') },
  { src: path.join(DOTFILES_ROOT, '.profile'),        dest: path.join(HOME, '.profile') },
  { src: path.join(DOTFILES_ROOT, '.fonts'),          dest: path.join(HOME, '.fonts') },
  { src: path.join(DOTFILES_ROOT, 'kitty/kitty.conf'),dest: path.join(HOME, '.config/kitty/kitty.conf') },
  { src: path.join(DOTFILES_ROOT, 'dunst'),           dest: path.join(HOME, '.config/dunst') },
  { src: path.join(DOTFILES_ROOT, 'zathura/zathurarc'),dest: path.join(HOME, '.config/zathura/zathurarc') },
  { src: path.join(DOTFILES_ROOT, 'rofi'),            dest: path.join(HOME, '.config/rofi') },
];

export async function runShared(): Promise<void> {
  log.info('Installing shared packages...');
  await installPackages({ system: SYSTEM_PACKAGES, pip: PIP_PACKAGES });

  await symlinkAll(await promptSymlinks(SYMLINKS));

  log.info('Enabling system services...');
  await exec('sudo', ['systemctl', 'enable', '--now', 'bluetooth.service']);
  await exec('systemctl', ['enable', '--now', '--user', 'pipewire-pulse']);

  log.ok('Shared setup complete.');
}
