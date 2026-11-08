# Testing Keep Donations

For people and agents who test the mod in the game. Read it before you use anything the mod adds.
Assume nothing about the mod when it is not installed: check `logs\rqmod.log` for
`Keep Donations loaded`.

## What it adds

Nothing on screen. A hook on the game's world transfer (`ワールド切り替え処理`) puts back three values
after it:

| Value | Read with | The game alone after a transfer |
| --- | --- | --- |
| Donations | `rq.ain.global("◆寄付")`, the hub's `donations` control | 0 |
| Frostbuy's reward goal | `rq.ain.global("◆寄付ボーナス")` | 25 |
| Frost's talk seen | `rq.scene.seen("フロスト売店／寄付について")` | false |

Each transfer writes `Keep Donations: kept N donations (goal G) through the transfer to world W` to
`logs\rqmod.log`.

## How to check it

1. On the town hub, read the three values.
2. Stand for a transfer: `rq.ain.call("ワールド切り替え処理")` from a Lab job. It runs the game's whole
   transfer (every quest reset, fame cut), so do it only in the Lab, whose save comes back when it
   stops. `◆ワールド` is not changed by the call; Alice's choice sets it before.
3. The three values are as before.
4. Enter Frostbuy: the donation talk does not play, and the goal does not change unless the count
   has reached it. Frostbuy's other first-visit scenes do play again, as in any new world (the
   transfer clears every event flag); a hook on `フロスト売店／寄付について` counts only the donation
   talk.

## Forcing it for a test

- `rq.mod.get("keep-donations").last()` returns what the last transfer kept: `donations`, `goal`,
  `talk`, `world` (before the transfer), or nil.
- `rq.ain.set_global("◆寄付", n)` and `("◆寄付ボーナス", n)` set the count and the goal;
  `rq.scene.seen("フロスト売店／寄付について", false)` makes the talk unseen.

## Test Lab

`test-lab/scenarios/keep-donations.lua`: the three values kept, Frostbuy after (no talk, no reward),
an unseen talk kept unseen, zero donations, and the next reward still coming at the goal.

Not checked: Alice's real "Go to World 2" scene; the direct call runs the same function.
