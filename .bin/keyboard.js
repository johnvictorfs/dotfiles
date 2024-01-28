#!/usr/bin/env bun
import { $ } from 'bun'

const notify = (message) => $`dunstify -r 1000 -u low -t 1000 "Keyboard Layout" "${message}"`

if (process.argv[2] === 'toggle') {
  // 'layout:     us' | 'layout:     us'
  const layout = await $`setxkbmap -query | grep layout`.text()
  const layoutCode =  layout.includes('us') ? 'us' : 'br'

  if (layoutCode === 'us') {
    await $`setxkbmap -model abnt2 -layout br`
    await notify("ABNT2")
  } else {
    await $`setxkbmap -model pc104 -layout us`
    await notify("US")
  }
}

if (process.argv[2] === 'watch') {
  /**
   * @type {'us' | 'br' | null}
   */
  let lastCode = null

  const printLayoutCode = async () => {
    // 'layout:     us' | 'layout:     us'
    const layout = await $`setxkbmap -query | grep layout`.text()
    const layoutCode = layout.includes('us') ? 'us' : 'br'

    if (!lastCode || lastCode !== layoutCode) {
      console.log(layoutCode.toUpperCase())
      lastCode = layoutCode
    }
  }

  const period = process.argv[3] ? parseInt(process.argv[3]) : 1000

  printLayoutCode()
  setInterval(printLayoutCode, period)
}
