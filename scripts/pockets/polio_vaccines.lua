local mod = moreFood
local PolioVaccines = {}
PolioVaccines.name = "Polio Vaccines"
PolioVaccines.ID = Isaac.GetPillEffectByName("Polio Vaccines")
local game = Game()

function PolioVaccines:onuse(_, pillEffect, player, useFlags)
    -- 调用dagaz
    player:UseCard(Card.RUNE_DAGAZ, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
end

mod:AddCallback(ModCallbacks.MC_USE_PILL, function(...) return PolioVaccines:onuse(...) end, PolioVaccines.ID)

return PolioVaccines