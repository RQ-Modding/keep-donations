# Changelog

Each section is a version of the mod, the `version` in `mod.json`. The release workflow copies the
section of a tagged version into the release notes.

## 1.1.1

- Works through the loader's calls for the world transfer and the donations (`rq.world.on_transfer`,
  `on_transfer_after`, `rq.shop.donations`, `set_donations`) instead of the game's code. Nothing
  changes for players.
- Needs loader 2.23.0.

## 1.1.0

- A page in Config's Mods tab shows the save's donations and sets the count by hand. Set asks on
  the page, then puts the next reward at the next multiple of 25 above the count, so no reward is given twice, and
  marks Frost's talk seen.
- Needs loader 2.22.0 (`rq.uikit.stepper`).

## 1.0.0

First version.
- A world transfer keeps the donations count, Frostbuy's reward goal and Frost's talk about
  donations seen.
