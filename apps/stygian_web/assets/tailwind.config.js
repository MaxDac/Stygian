// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/*_web.ex",
    "../lib/*_web/**/*.*ex",
    "./node_modules/flowbite/**/*.js"
  ],
  darkMode: "class",
  theme: {
    extend: {
      screens: {
        "tall": { "raw": "(min-height: 800px)" },
        "2xl": "1336px",
        "3xl": { "raw": "(min-width: 1600px)" },
        "4xl": { "raw": "(min-width: 1900px)" },
      },
      backgroundImage: {
        "login": "url('/images/LoginFrameSH.webp')",
        "main": "url('/images/HomeWallpaper.webp')",
      },
      colors: {
        brand: "#33a01b",
        "brand-inactive": "#13800b",
        internal: "#090b0a",
        "container-background": "#1a1919",
      },
      fontFamily: {
        serif: ["berolina", "serif"],
        typewriter: ["typewriter", "serif"],
        metropolitan: ["metropolitan", "serif"],
        berolina: ["berolina", "serif"],
        legrand: ["legrand", "serif"],
        normal: ["normal", "serif"],
        necrofonticon: ["necrofonticon", "serif"],
      },
      boxShadow: {
        "DEFAULT": "box-shadow: 0 0 10px #000",
      },
      dropShadow: {
        "md": "0 2px 2px rgba(0, 0, 0, 0.5)",
        "lg": "0 3px 3px rgba(0, 0, 0, 0.95)",
        "xl": "0 5px 5px rgba(0, 0, 0, 0.95)",
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("flowbite/plugin"),
    require("flowbite-typography"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({addVariant}) => addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])),
    plugin(({addVariant}) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({addVariant}) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({addVariant}) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),
  ]
}
