<<<<<<< HEAD
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

=======
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

>>>>>>> d35c1c50f9ec8083dc8f476c254e12ae4506c252
return PolioVaccines