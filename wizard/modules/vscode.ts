import {
  HOME,
  DOTFILES_ROOT,
  path,
  exec,
  log,
  confirm,
  COLORS,
  installPackages,
  applySymlinks,
  type Package,
  type SymlinkSpec,
} from "../lib/api.ts";

export const SYSTEM_PACKAGES: Package[] = [
  {
    name: "visual-studio-code-bin",
    source: "pacman",
    description: "Visual Studio Code",
  },
];

export const SYMLINKS: SymlinkSpec[] = [
  {
    src: path.join(DOTFILES_ROOT, "vscode/settings.json"),
    dest: path.join(HOME, ".config/Code/User/settings.json"),
  },
  {
    src: path.join(DOTFILES_ROOT, "vscode/keybindings.json"),
    dest: path.join(HOME, ".config/Code/User/keybindings.json"),
  },
];

const EXTENSIONS = [
  { id: "dbaeumer.vscode-eslint", description: "ESLint integration" },
  { id: "eamodio.gitlens", description: "Git blame, history, and more" },
  { id: "GitHub.github-vscode-theme", description: "GitHub color theme" },
  { id: "esbenp.prettier-vscode", description: "Prettier code formatter" },
  {
    id: "k--kato.intellij-idea-keybindings",
    description: "IntelliJ IDEA keybindings",
  },
  { id: "ms-python.python", description: "Python language support" },
  {
    id: "ms-python.vscode-pylance",
    description: "Python type checking and IntelliSense",
  },
  {
    id: "PKief.material-icon-theme",
    description: "Material Design file icons",
  },
];

async function promptExtensions() {
  console.log("\nExtensions to install:\n");
  for (const ext of EXTENSIONS) {
    console.log(`  ${ext.id}  ${COLORS.DIM}${ext.description}${COLORS.RESET}`);
  }
  console.log();

  const yes = await confirm("Install extensions?");
  if (!yes) return;

  for (const ext of EXTENSIONS) {
    log.info(`Installing ${ext.id}...`);
    await exec("code", ["--install-extension", ext.id]);
  }
  log.ok("Extensions installed.");
}

export async function runVscode() {
  log.info("Installing VSCode...");
  await installPackages({ system: SYSTEM_PACKAGES });

  await applySymlinks(SYMLINKS);

  await promptExtensions();

  log.ok("VSCode setup complete.");
}
