#!/usr/bin/env node

import { execSync } from "child_process";
import { run } from "./shared.mjs";

/**
 * @typedef {{
 *   id: number,
 *   name: string,
 *   description: string,
 *   make: string,
 *   model: string,
 *   width: number,
 *   height: number,
 *   refreshRate: number,
 *   x: number,
 *   y: number,
 *   activeWorkspace: { id: number, name: string },
 *   specialWorkspace: { id: number, name: string },
 *   reserved: number[],
 *   scale: number,
 *   transform: number,
 *   focused: number,
 *   dpmsStatus: number,
 *   vrr: number
 * }} Monitor
 */

/**
 * @typedef {{
 *  id: number,
 *  name: string,
 *  monitor: string,
 *  windows: number,
 *  hasfullscreen: boolean,
 *  lastwindow: string,
 *  lastwindowtitle: string
 * }} Workspace
 */

let cacheText = "";

const workspaces = () => {
  const monitor = Number.parseInt(process.argv[2]);

  /**
   * @type {Monitor[]}
   */
  const monitors = JSON.parse(execSync("hyprctl monitors -j").toString());

  /**
   * @type {Workspace[]}
   */
  const workspaces = JSON.parse(execSync("hyprctl workspaces -j").toString());

  const monitorWorkspaces = workspaces.filter(
    (w) => w.monitor === monitors[monitor].name
  );

  let workspacesText = "";
  monitorWorkspaces.forEach((workspace) => {
    // Don't show workspace if the there are no windows in it, but show if it's the active workspace
    if (
      workspace.windows === 0 &&
      monitors[monitor].activeWorkspace.id !== workspace.id
    ) {
      return;
    }

    workspacesText += `
        (eventbox :onclick "hyprctl dispatch workspace ${workspace.id}"
          (box :class "workspace ${
            workspace.id == monitors[monitor].activeWorkspace.id
              ? "focused"
              : ""
          }"
            (label :text "${workspace.id}")
          )
        )
      `.trim();
  });

  const message = `
      (eventbox
        (box :class "workspaces" :space-evenly true :spacing 5
          ${workspacesText}
        )
      )
    `

  return message;
};

run(workspaces, 50);
