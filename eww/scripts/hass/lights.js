#!/usr/bin/env node

const server = process.env.HASS_SERVER
const token = process.env.HASS_TOKEN

/**
 * @param {string} entityId example: 'light.luz_quarto'
 */
const toggleLight = async (entityId) => {
  await fetch(`${server}/api/services/light/toggle`, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      entity_id: entityId
    })
  })
}

if (process.argv[2]) {
  toggleLight(process.argv[2])
} else {
  const run = async () => {
    let lastMessage = ''
    while (true) {
      // TODO: class name for colors
      const message = `
        (eventbox :onclick "~/dotfiles/eww/scripts/hass/lights.js light.luz_quarto"
          (label :text "" :class "light-control")
        )
      `.trim()

      if (lastMessage !== message) {
        lastMessage = message
        console.log(message)
      }

      await new Promise((resolve) => setTimeout(resolve, 50))
    }
  }

  run()
}
