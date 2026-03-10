import { exec, log } from '../lib/utils.ts';
import type { Package } from '../lib/utils.ts';
import { installPackages } from '../lib/packages.ts';

export const SYSTEM_PACKAGES: Package[] = [
  { name: 'tlp', source: 'pacman', description: 'Laptop power management' },
];

export async function runTlp(): Promise<void> {
  log.info('Installing tlp...');
  await installPackages({ system: SYSTEM_PACKAGES, pip: [] });

  log.info('Enabling and starting tlp...');
  await exec('sudo', ['systemctl', 'enable', '--now', 'tlp']);

  log.ok('tlp setup complete.');
}
