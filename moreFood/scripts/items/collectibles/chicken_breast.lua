local mod = moreFood
local ChickenBreast = {}
ChickenBreast.name = "Chicken Breast"
ChickenBreast.ID = Isaac.GetItemIdByName("Chicken Breast")
local game = Game()
local CHICKEN_BREAST_TIMER = "ChickenBreastTimer"
local CHICKEN_BREAST_TIME = 120 * 30


-- ...existing code...

function ChickenBreast:OnPlayerEffectUpdate(player)
    local data = player:GetData()
    local count = player:GetCollectibleNum(ChickenBreast.ID)
    if count > (data._ChickenBreastLastCount or 0) then
        -- 增加一格红心上限
        player:AddMaxHearts(2, false)
    end
    data._ChickenBreastLastCount = count
end

function ChickenBreast:statchange(player, flag)
    if player:HasCollectible(ChickenBreast.ID) then
        local itemcount = player:GetCollectibleNum(ChickenBreast.ID)
        local data = player:GetData()
        local timer = data[CHICKEN_BREAST_TIMER] or 0
        local t = 1
        if timer > 0 then
            t = 1 - (timer / CHICKEN_BREAST_TIME) -- t从0逐渐变为1
        end
        -- 线性插值负到正
        local function lerp(min, max)
            return min + (max - min) * t
        end

        local increasedspeed = lerp(-0.4, 0.2) * itemcount
        local increasedtearrange = lerp(-100, 50) * itemcount
        local increaseddamage = lerp(-1.5, 1) * itemcount

        if flag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + increasedspeed
        end
        if flag == CacheFlag.CACHE_RANGE then
            player.TearRange = player.TearRange + increasedtearrange
        end
        if flag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + increaseddamage
        end
    end
end

function ChickenBreast:ChickenBreastUpdateEffect()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(ChickenBreast.ID) then
            local data = player:GetData()
            local count = player:GetCollectibleNum(ChickenBreast.ID)
            -- 检查是否首次获得
            if not data[CHICKEN_BREAST_TIMER] or (data.LastChickenBreastCount and count > data.LastChickenBreastCount) then
                data[CHICKEN_BREAST_TIMER] = CHICKEN_BREAST_TIME
            end
            data.LastChickenBreastCount = count
            -- 计时器递减
            if data[CHICKEN_BREAST_TIMER] and data[CHICKEN_BREAST_TIMER] > 0 then
                data[CHICKEN_BREAST_TIMER] = data[CHICKEN_BREAST_TIMER] - 1
                player:AddCacheFlags(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_LUCK | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_RANGE | CacheFlag.CACHE_SHOTSPEED | CacheFlag.CACHE_DAMAGE)
                player:EvaluateItems()
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag) ChickenBreast:statchange(player, flag) end)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function() ChickenBreast:ChickenBreastUpdateEffect() end)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    ChickenBreast:OnPlayerEffectUpdate(player)
end)

return ChickenBreast