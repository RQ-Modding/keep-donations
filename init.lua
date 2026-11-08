-- Keep Donations: a world transfer keeps the donations count, Frostbuy's reward goal and Frost's
-- talk about donations, which the game resets.
-- API reference: https://rq-modding.github.io/rq-modding-docs/reference/
--
-- It works on the game's own code through rq.ain (notes/plans/plan-donations.md in the workspace):
-- ワールド切り替え処理 sets ◆寄付 to 0 and ◆寄付ボーナス to 25 and clears every event flag. With the
-- goal back at 25 and the talk unseen, Frostbuy would hand out every reward again, one per visit.

local MOD = "Keep Donations"
local TALK = "フロスト売店／寄付について"   -- Frost's talk; while unseen, Frostbuy sets the goal to 25

local held   -- the values read before the transfer, until it ends
local last   -- what the last transfer kept, for the Lab

local function read()
  return {
    donations = rq.ain.global("◆寄付"),
    goal = rq.ain.global("◆寄付ボーナス"),
    talk = rq.scene.seen(TALK),
    world = rq.ain.global("◆ワールド"),
  }
end

rq.ain.hook("ワールド切り替え処理", {
  before = function()
    held = read()
  end,
  after = function()
    local v = held
    held = nil
    if not v then return end
    rq.ain.set_global("◆寄付", v.donations)
    rq.ain.set_global("◆寄付ボーナス", v.goal)
    if v.talk then rq.scene.seen(TALK, true) end
    last = v
    rq.log(string.format("%s: kept %d donations (goal %d) through the transfer to world %d",
      MOD, v.donations, v.goal, rq.ain.global("◆ワールド")))
  end,
})

rq.log(MOD .. " loaded")

-- For the Lab: what the last transfer kept ({ donations, goal, talk, world }), or nil.
return {
  last = function() return last end,
}
