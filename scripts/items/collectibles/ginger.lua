local mod = moreFood
local Ginger = {}
Ginger.name = "Ginger"
Ginger.ID = Isaac.GetItemIdByName("Ginger")
local game = Game()

local BASE_TRANSFORM_CHANCE = 1  -- 基础转换概率1%
local QUALITY_MODIFIERS = {
    [0] = 20,  -- 0级品质道具20%概率转换
    [1] = 10,  -- 1级10%
    [2] = 5,  -- 2级5%
    [3] = 1,   -- 3级1%
    [4] = 0.1    -- 4级0.1%
}
local SPEED_UP = 3.0        -- 攻速提升

function Ginger:CheckPickup(player)
    if not player then return end
    local data = player:GetData()
    local count = player:GetCollectibleNum(Ginger.ID)
    data._GingerLastCount = data._GingerLastCount or 0
    
    if count > data._GingerLastCount then
        Ginger:OnPickup(player)
        -- 增加一格红心上限
        player:AddMaxHearts(2, false)
    end
    data._GingerLastCount = count
end

function Ginger:OnPEffectUpdate(player)
    local data = player:GetData()
    local currentCount = player:GetCollectibleCount()
    
    -- 更新上一帧道具数
    data.LastItemCount = data.LastItemCount or currentCount
    
    -- 如果道具数增加且不是因为获得姜
    if currentCount > data.LastItemCount and not player:HasCollectible(Ginger.ID) then
        -- 查找最后获得的道具
        for i = 1, currentCount - data.LastItemCount do
            for id = CollectibleType.NUM_COLLECTIBLES - 1, 1, -1 do
                if player:HasCollectible(id) and id ~= Ginger.ID then
                    -- 获取道具品质并计算转换概率
                    local itemConfig = Isaac.GetItemConfig():GetCollectible(id)
                    if itemConfig then
                        local quality = itemConfig.Quality
                        local transformChance = QUALITY_MODIFIERS[quality] or BASE_TRANSFORM_CHANCE
                        -- 转换
                        if math.random(100) <= transformChance then
                            player:RemoveCollectible(id)
                            player:AddCollectible(Ginger.ID, 0, false)
                        end
                    end
                    break
                end
            end
        end
    end
    
    -- 更新上一帧的道具数
    data.LastItemCount = currentCount
end

function Ginger:OnPickup(player)
    -- 麻痹
    local pillEffect = PillEffect.PILLEFFECT_PARALYSIS
    game:GetItemPool():IdentifyPill(pillEffect)
    player:UsePill(pillEffect, 0, UseFlag.USE_NOANIM | UseFlag.USE_NOCOSTUME)
    
    player.MaxFireDelay = math.max(1, player.MaxFireDelay - SPEED_UP)  -- 提升攻速
    player.Luck = player.Luck + 6  -- 增加幸运值
end

-- 初始化玩家数据
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)
    player:GetData()._GingerLastCount = player:GetCollectibleNum(Ginger.ID)
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    Ginger:OnPEffectUpdate(player)
    Ginger:CheckPickup(player)
end)

return Ginger