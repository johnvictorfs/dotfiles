import { exec, log, installPackages, type Package } from "../lib/api.ts";

export const SYSTEM_PACKAGES: Package[] = [
  { name: "tlp", source: "pacman", description: "Laptop power management" },
];

export async function runTlp() {
  log.info("Installing tlp...");
  await installPackages({ system: SYSTEM_PACKAGES });

  log.info("Enabling and starting tlp...");
  await exec("sudo", ["systemctl", "enable", "--now", "tlp"]);

  log.ok("tlp setup complete.");
}
