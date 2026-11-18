# Keep Donations

Keep your donations when you move to a new world. The game sets the count back to 0 on a world
transfer; with this mod the count, and Frostbuy's rewards for it, carry on.

## Showcase

<img width="1263" height="915" alt="image" src="https://github.com/user-attachments/assets/41e192ad-d5c5-4d0e-889b-b1cba08962b6" />

## What it changes

- On a world transfer (Alice's "Go to World 2" or "Go to World 3"), the **donations** count stays
  as it was, on the town's DONATIONS and in the vault.
- Frostbuy's **reward goal** stays too, so the next reward comes after the next 25 donations, as
  before the transfer. (If only the count were kept, Frostbuy would hand out every reward you already
  got again, one per visit.)
- Frost's talk about donations stays seen, so it does not play again.
- Everything else the transfer resets (quests, fame, the quest count, Frostbuy's other first-visit
  scenes) is reset as the game does.

## Keys and settings

The mod's page in Config's **Mods** tab, **Keep Donations**, shows the loaded save's donations, the
next reward's goal and the world, and sets the count by hand:

- Choose the new count (0 to 99999) with **-** and **+** (Shift for 10 at a time), the wheel, or a
  click on the number to type it.
- **Set** asks in the game's own Yes/No dialog, over Config. Yes writes the count, puts the next
  reward at the next multiple of 25 above it, so the rewards the count already earned are not given
  again, and marks Frost's talk about donations seen.
- With no save loaded (Config from the title screen) the page says so.

The save keeps the new count when the game saves.

## Saves

The kept count, and one set on the page, is the game's own value in the save: it stays after the mod
is removed. The mod keeps no data of its own.

A save that went through a transfer before the mod was installed has lost its old count, and the
mod cannot bring it back.

## Works with

Tested with every RQ Modding mod installed. It touches no other mod's data.

## Install

Needs [RQ MOD](https://github.com/RQ-Modding/RQ-Mod) with loader **2.28.0** or newer. Extract the
release zip into the game's `mods` folder, so that you have `mods/keep-donations/mod.json`.

## License

MIT, see [LICENSE](LICENSE).
