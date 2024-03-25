#!/usr/bin/env bun

import { spawn } from "child_process";
import { $ } from "bun";

const i3msg = spawn("i3-msg", ["-t", "subscribe", "-m", '[ "window" ]']);

i3msg.stdout.on("data", async () => {
  await $`pkill rofi`;
});
