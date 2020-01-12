// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import { Socket } from "phoenix"
import LiveSocket from "phoenix_live_view"

const Hooks = {}

Hooks.ScrollLock = {
    mounted() {
        this.lockScroll()
    },
    destroyed() {
        this.unlockScroll()
    },
    lockScroll() {
        // Add right padding to the body so the page doesn't shift 
        // when we disable scrolling
        const scrollbarWidth =
            window.innerWidth - document.documentElement.clientWidth
        document.body.style.paddingRight = `${scrollbarWidth}px`
        // Save the scroll position
        this.scrollPosition = window.pageYOffset || document.body.scrollTop
        // Add classes to body to fix its position
        document.body.classList.add('fix-position')
        // Add negative top position in order for body to stay in place
        document.body.style.top = `-${this.scrollPosition}px`
    },
    unlockScroll() {
        // Remove tweaks for scrollbar
        document.body.style.paddingRight = null
        // Remove classes from body to unfix position
        document.body.classList.remove('fix-position')
        // Restore the scroll position of the body before it got locked
        document.documentElement.scrollTop = this.scrollPosition
        // Remove the negative top inline style from body
        document.body.style.top = null
    }
}

let liveSocket = new LiveSocket("/live", Socket, {
    hooks: Hooks
})

liveSocket.connect()