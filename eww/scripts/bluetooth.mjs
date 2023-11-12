#!/usr/bin/env node
import { execSync } from "child_process";
import { run } from "./shared.mjs";

const getDevices = () => {
  const devicesOutput = execSync("bluetoothctl devices").toString();

  const devices = devicesOutput
    .split("\n")
    .map((device) => {
      const [_, id, ...name] = device.split(" ");

      return { id, name: name.join(" ") };
    })
    .filter((device) => device.id !== undefined);

  return devices;
};

const getBluetoothInfo = () => {
  const devices = getDevices();

  /**
   * @type {{
   *  id: string
   *  name: string
   *  icon: string
   *  paired: boolean
   *  connected: boolean
   *  trusted: boolean
   * }[]}
   */
  const devicesInfo = [];

  devices.map((device) => {
    const deviceInfo = execSync(`bluetoothctl info ${device.id}`).toString();

    const paired = deviceInfo.includes("Paired: yes");
    const connected = deviceInfo.includes("Connected: yes");
    const trusted = deviceInfo.includes("Trusted: yes");
    const name = device.name;
    const icon = deviceInfo.split("Icon: ")[1]?.split("\n")[0];

    devicesInfo.push({ id: device.id, name, icon, paired, connected, trusted });
  });

  return devicesInfo;
};

const bluetoothPopup = () => {
  const devices = getBluetoothInfo();

  let message = `
    (box :halign :start :class "bluetooth-popup" :orientation "v"
      (eventbox :onclick "bluetoothctl scan on &"
        (box :class "scan-button"
          (label :text " Scan" :class "bluetooth-icon")
        )
      )

      ${devices
        .map((device) => {
          const statusIcon = device.connected ? " " : "  ";
          const className = device.connected ? "connected" : "not-connected"

          const actions = [
            {
              label:  device.connected ? "  Unpair" : " Pair",
              command: device.connected ? `bluetoothctl unpair ${device.id}` : `bluetoothctl pair ${device.id} && bluetoothctl connect ${device.id}`
            },
            {
              label: device.trusted ? " Untrust" : " Trust",
              command: device.trusted ? `bluetoothctl untrust ${device.id}` : `bluetoothctl trust ${device.id}`
            }
          ]

          return `
            (box :class "bluetooth-device" :halign :center :valign :center :orientation "v"
              (eventbox :class "device-name ${className}"
                (label :text "${statusIcon} ${device.name}" :class "bluetooth-icon")
              )

              (box :class "device-state" :halign :center :valign :center :spacing 5
                ${actions.map(action => `
                  (eventbox :class "device-action" :onclick "${action.command}"
                    (label :text "${action.label}" :class "action-label")
                  )
                `).join("\n").trim()}
              )
            )
          `.trim();


                // (eventbox :class "device-action" :onclick "${device.trusted ? `bluetoothctl untrust ${device.id}` : `bluetoothctl trust ${device.id}`}"
                //   (label :text "${device.trusted ? " Untrust" : " Trust"}")
                // )
        })
        .join("\n")
        .trim()}
    )
  `.trim();

  return message;
};

run(bluetoothPopup, 200);
