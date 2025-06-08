local mod = moreFood
local HotPot = {}
HotPot.name = "Hot Pot"
HotPot.ID = Isaac.GetItemIdByName("Hot Pot")
local game = Game()

local CHARGE_TIME = 45 -- 蓄力时间
local FLAME_DURATION = 15 -- 火焰持续时间
local FLAME_INTERVAL = 2  -- 每隔几帧发射一次火焰
local FLAME_NUM = 1      -- 每次发射火焰数量
local DAMAGE_AMOUNT = 3.5    -- 每次伤害
local DAMAGE_DURATION = 30   -- 火焰持续时间（帧）
local DAMAGE_INTERVAL = 2   -- 伤害间隔（帧）

local chargeBarProgress = {}
-- 记录玩家的蓄力进度

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)
    player:GetData()._HotPotLastCount = player:GetCollectibleNum(HotPot.ID)
end)

function HotPot:OnPlayerEffectUpdate(player)
    if not player:HasCollectible(HotPot.ID) then return end
    local data = player:GetData()
    local count = player:GetCollectibleNum(HotPot.ID)
    data._HotPotLastCount = data._HotPotLastCount or 0
    if count > data._HotPotLastCount then
        -- 增加两格红心上限并补满两格红心
        player:AddMaxHearts(4, false)
        player:AddHearts(4)
    end
    data._HotPotLastCount = count
end

function HotPot:GetShootDirection(player)
    local dir = Vector(0,0)
    if Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex) then dir = dir + Vector(-1,0) end
    if Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex) then dir = dir + Vector(1,0) end
    if Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex) then dir = dir + Vector(0,-1) end
    if Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex) then dir = dir + Vector(0,1) end
    if dir:Length() == 0 then dir = Vector(0,1) end -- 默认向上
    return -dir:Normalized() -- 反方向
end

function HotPot:SpawnFlames(player)

    local pos = player.Position
    local moveDir = player.Velocity
    if moveDir:Length() < 0.1 then moveDir = Vector(0, 1) end
    local baseAngle = (-moveDir):GetAngleDegrees()
    for i = 1, FLAME_NUM do
        local randomOffset = math.random(-45, 45)
        local fireAngle = baseAngle + randomOffset
        local dir = Vector.FromAngle(fireAngle)
        local speed = math.random(60, 90) / 5
        local spawnPos = pos + dir:Rotated(90) * ((i - (FLAME_NUM+1)/2) * 8)
        local flame = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.RED_CANDLE_FLAME, 0, spawnPos, dir * speed, player):ToEffect()
        flame.SpawnerEntity = player
        flame:GetData().HotPotFlame = true
        flame:GetData().StartFrame = game:GetFrameCount()
        flame:GetData().LastDamageFrame = {}
    end
end

function HotPot:PlayerHotPotUpdate(player)
    if not player:HasCollectible(HotPot.ID) then return end
    local data = player:GetData()
    data.HotPotCharge = data.HotPotCharge or 0
    data.HotPotFlameTimer = data.HotPotFlameTimer or 0
    data.HotPotFlameCooldown = data.HotPotFlameCooldown or 0

    if data.HotPotFlameCooldown > 0 then
        data.HotPotFlameCooldown = data.HotPotFlameCooldown - 1
    end

    local isShooting = false
    for _, key in ipairs({ButtonAction.ACTION_SHOOTLEFT, ButtonAction.ACTION_SHOOTRIGHT, ButtonAction.ACTION_SHOOTUP, ButtonAction.ACTION_SHOOTDOWN}) do
        if Input.IsActionPressed(key, player.ControllerIndex) then isShooting = true break end
    end

    if isShooting and data.HotPotFlameCooldown == 0 and data.HotPotFlameTimer == 0 then
        data.HotPotCharge = data.HotPotCharge + 1
        chargeBarProgress[player.Index] = math.min(data.HotPotCharge / CHARGE_TIME, 1)
    else
        chargeBarProgress[player.Index] = 0
        if data.HotPotCharge >= CHARGE_TIME and data.HotPotFlameCooldown == 0 then
            data.HotPotFlameTimer = FLAME_DURATION
            data.HotPotFlameCooldown = FLAME_DURATION
        end
        data.HotPotCharge = 0
    end

    if data.HotPotFlameTimer > 0 then
        data.HotPotFlameTimer = data.HotPotFlameTimer - 1
        if data.HotPotFlameTimer % FLAME_INTERVAL == 0 then
            HotPot:SpawnFlames(player)
        end
    end
end

function HotPot:OnRender()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if chargeBarProgress[player.Index] and chargeBarProgress[player.Index] > 0 then
            local percent = chargeBarProgress[player.Index]
            local barLen = math.floor(percent * 10)
            local bar = string.rep("■", barLen) .. string.rep(" ", 10 - barLen)
            local pos = Isaac.WorldToScreen(player.Position) + Vector(-28, -40)
            Isaac.RenderText("[" .. bar .. "]", pos.X, pos.Y, 1, 1, 1, 1)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    HotPot:OnPlayerEffectUpdate(player)
    HotPot:PlayerHotPotUpdate(player)
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    HotPot:OnRender()
end)

-- 火焰伤害判定
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.Variant == EffectVariant.RED_CANDLE_FLAME then
        -- 防止byd莫名其妙返回值的安全检查
        if not effect then return end
        
        local data = effect:GetData()
        if type(data) ~= "table" then return end
        if not data.HotPotFlame then return end
        
        local currentFrame = game:GetFrameCount()
        if not data.LastDamageFrame then
            data.LastDamageFrame = {}
        end
        if not data.StartFrame then
            data.StartFrame = currentFrame
        end
        
        if currentFrame - data.StartFrame <= DAMAGE_DURATION then
            for _, entity in ipairs(Isaac.FindInRadius(effect.Position, 20, EntityPartition.ENEMY)) do
                if entity:IsVulnerableEnemy() and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
                    local entityHash = GetPtrHash(entity)
                    local lastDamageFrame = data.LastDamageFrame[entityHash] or 0
                    
                    if currentFrame - lastDamageFrame >= DAMAGE_INTERVAL then
                        entity:TakeDamage(DAMAGE_AMOUNT, 0, EntityRef(effect), 0)
                        data.LastDamageFrame[entityHash] = currentFrame
                        Game():SpawnParticles(entity.Position, EffectVariant.BLOOD_PARTICLE, 1, 2, Color(1,1,1,1))
                    end
                end
            end
        end
    end
end, EffectVariant.RED_CANDLE_FLAME)

return HotPot