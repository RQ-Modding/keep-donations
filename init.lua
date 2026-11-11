-- Keep Donations: a world transfer keeps the donations count, Frostbuy's reward goal and Frost's
-- talk about donations, which the game resets.
-- API reference: https://rq-modding.github.io/rq-modding-docs/reference/
--
-- The game's world transfer sets the donations count to 0 and the goal to 25 and clears every event
-- flag (notes/plans/plan-donations.md in the workspace). With the goal back at 25 and the talk unseen,
-- Frostbuy would hand out every reward again, one per visit. The mod reads them before the reset
-- and writes them back after it (rq.world.on_transfer and on_transfer_after, rq.shop.donations,
-- loader 2.23.0).

local MOD = "Keep Donations"
local TALK = "フロスト売店／寄付について"   -- Frost's talk; while unseen, Frostbuy sets the goal to 25

local held   -- the values read before the transfer, until it ends
local last   -- what the last transfer kept, for the Lab

local function read()
  local donations, goal = rq.shop.donations()
  return {
    donations = donations,
    goal = goal,
    talk = rq.scene.seen(TALK),
    world = rq.world.current() or 0,
  }
end

rq.world.on_transfer(function()
  held = read()
end)

rq.world.on_transfer_after(function(ctx)
  local v = held
  held = nil
  if not v then return end
  rq.shop.set_donations(v.donations, v.goal)
  if v.talk then rq.scene.seen(TALK, true) end
  last = v
  rq.log(string.format("%s: kept %d donations (goal %d) through the transfer to world %d",
    MOD, v.donations, v.goal, ctx.world))
end)

-- The count by hand (1.1.0), on the mod's page in Config's Mods tab. "Set" writes the count, puts
-- the goal at the next multiple of 25 above it, so the rewards the count already earned are not
-- given again, and marks Frost's talk seen, so the talk does not set the goal back to 25.
local STEP = 25
local MAX = 99999
local wanted -- the stepper's number, until set

local function goal_for(n)
  return (n // STEP + 1) * STEP
end

-- A save is loaded once the game is past the title: its world is 1 or more.
local function loaded()
  return rq.world.current() ~= nil
end

local function set_count(n)
  rq.shop.set_donations(n, goal_for(n))
  if n > 0 then rq.scene.seen(TALK, true) end
  rq.log(string.format("%s: donations set to %d (goal %d)", MOD, n, goal_for(n)))
end

rq.config.page{
  id = "keep-donations",
  title = "Keep Donations",
  draw = function(ui)
    if not loaded() then
      ui.label("Load a save to see or change its donations.", { dim = true })
      ui.stepper(0, { id = "count", label = "New count", max = MAX, w = 90, disabled = true })
      ui.button("Set", { id = "set", disabled = true })
      return
    end
    local v = read()
    ui.label(string.format("Donations: %d     Next reward at: %d     World: %d", v.donations, v.goal, v.world))
    ui.space(0, 6)
    wanted = wanted or v.donations
    local n = ui.stepper(wanted, { id = "count", label = "New count", min = 0, max = MAX, w = 90,
      tip = "Shift with - or + changes it by 10; a click on the number types it." })
    wanted = n
    -- Set asks with the game's Yes/No, over Config since loader 2.28.0 (1.2.0).
    if ui.button("Set", { id = "set", tip = "Writes the count into the loaded save." }) then
      if rq.ui.confirm(string.format("Set donations to %d?\nThe next reward comes at %d.", n, goal_for(n))) then
        set_count(n)
      end
    end
    ui.space(0, 6)
    ui.label("The rewards the count already earned are not given again.", { dim = true, size = 15 })
    ui.label("The save keeps it when the game saves.", { dim = true, size = 15 })
  end,
  on_open = function() wanted = nil end,
}

rq.log(MOD .. " loaded")

-- For the Lab: what the last transfer kept ({ donations, goal, talk, world }), or nil; and the
-- page's "Set" without its dialog.
return {
  last = function() return last end,
  set = function(n)
    if math.type(n) ~= "integer" or n < 0 or n > MAX then error("keep-donations: a count from 0 to " .. MAX, 2) end
    set_count(n)
  end,
  goal_for = goal_for,
}
